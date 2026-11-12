#!/usr/bin/env bash
#
# reconcile-upstream.sh TARGET
#
# Strip from the fork branch the upstream commits that TARGET no longer
# contains ("abandoned" commits), then make TARGET an ancestor of the branch.
#
# Why: upstream rewrites `main` from time to time (force-push), so commits the
# branch already adopted can disappear from the new line. The abandoned set is
# exactly
#
#     git rev-list OLD --not TARGET
#
# where OLD is the upstream side of the branch's most recent merge (the second
# parent, M^2) — i.e. the last upstream commit the branch adopted.
#
# TARGET is any upstream commit-ish: a release tag (vX.Y.Z[-preN]), upstream/main,
# or a specific commit.
#
# Merge commits are reverted too (with `-m 1`): this branch never pushes
# upstream, so nothing of ours lives inside an upstream merge and there is no
# merge-unique content of ours to preserve — we just mirror TARGET.
#
# The revert series is incremental and resumable. A commit whose revert commit
# already exists on the branch (standard "This reverts commit <sha>." trailer)
# is skipped, so a conflict is a pause point, not a dead end: resolve it, run
# `git revert --continue`, and re-run. The final merge is handled the same way:
# on conflict it is left in the working tree for you to commit.
#
# Env:
#   BRANCH           branch to reconcile              (default android_legacy)
#   UPSTREAM_REMOTE  remote name                      (default upstream)
#   UPSTREAM_URL     url used if the remote is absent (default appshubcc/Bettbox)
#
# Run with -h/--help for the full usage.
#
set -euo pipefail

branch=${BRANCH:-android_legacy}
remote=${UPSTREAM_REMOTE:-upstream}
upstream_url=${UPSTREAM_URL:-https://github.com/appshubcc/Bettbox.git}

say() { printf '==> %s\n' "$*" >&2; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: reconcile-upstream.sh TARGET

Make TARGET an ancestor of the fork branch by reverting the upstream commits
that TARGET no longer contains ("abandoned" commits), then merging TARGET.
Run it after upstream rewrites `main` (force-push) and the branch still carries
commits from the old line.

Arguments:
  TARGET   upstream commit-ish to adopt (required).
           Examples: v1.19.8, v1.19.8-pre1, upstream/main, a commit hash.

Options:
  -h, --help   show this help and exit

Environment variables (no flags):
  BRANCH           branch to reconcile                (default: android_legacy)
  UPSTREAM_REMOTE  remote name                        (default: upstream)
  UPSTREAM_URL     URL used if the remote is absent   (default: appshubcc/Bettbox)

Exit status:
  0   reconciled, or already up to date
  1   precondition or usage error
  2   a revert or the final merge conflicts; it is left in the working tree

Resumable: a commit whose revert commit is already on the branch (standard
"This reverts commit <sha>." trailer) is skipped, so a conflict is a pause
point. Resolve it, run `git revert --continue` (or `git commit` for a merge
conflict), then re-run this script to continue.
EOF
}

# --- arguments -------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      die "unknown option: $1 (try --help)"
      ;;
    *)
      break
      ;;
  esac
done
[ $# -le 1 ] || die "too many arguments (try --help)"
target=${1:-}
[ -n "$target" ] || die "TARGET is required (try --help)"

# --- preconditions ---------------------------------------------------------
for marker in REVERT_HEAD CHERRY_PICK_HEAD MERGE_HEAD; do
  if [ -e "$(git rev-parse --git-path "$marker")" ]; then
    die "a revert/merge is in progress; finish it (--continue) or abort it (--abort) first"
  fi
done
[ -z "$(git status --porcelain)" ] || die "working tree not clean"
git rev-parse --verify --quiet "refs/heads/$branch" >/dev/null || die "no branch: $branch"
[ "$(git branch --show-current)" = "$branch" ] || die "checkout '$branch' first"

git remote get-url "$remote" >/dev/null 2>&1 || {
  say "adding remote $remote"
  git remote add "$remote" "$upstream_url"
}

say "fetching from $remote"
git fetch --force "$remote" '+refs/heads/*:refs/remotes/'"$remote"'/*' '+refs/tags/*:refs/tags/*' >/dev/null

# --- resolve TARGET --------------------------------------------------------
target_sha=$(git rev-parse --verify --quiet "${target}^{commit}") || die "unknown target: $target"
say "TARGET             = $target [$(git log -1 --format='%h %s' "$target_sha")]"

# --- OLD = upstream side of the branch's most recent merge -----------------
old=""
last_merge=$(git rev-list --first-parent --merges -n1 HEAD 2>/dev/null || true)
if [ -n "$last_merge" ]; then
  old=$(git rev-parse "${last_merge}^2" 2>/dev/null || true)
fi
say "OLD (last merge M^2) = ${old:-<none>}${old:+  [$(git log -1 --format='%h %s' "$old")]}"

# --- abandoned commits = OLD has, TARGET dropped ---------------------------
abandoned=()
if [ -n "$old" ]; then
  mapfile -t abandoned < <(git rev-list "$old" --not "$target_sha")
fi

is_merge() { [ "$(git rev-list --parents -n1 "$1" | wc -w)" -gt 2 ]; }

revert_one() { # revert_one <commit>
  local c=$1
  if is_merge "$c"; then
    git revert -m 1 --no-edit "$c"
  else
    git revert --no-edit "$c"
  fi
}

already_reverted() { # already_reverted <full-sha>
  # Matches the standard trailer of a revert commit. A revert that was later
  # re-applied ("Revert "Revert ..."") is still reported as reverted — rare,
  # resolve by hand if it ever happens.
  local c=$1 range
  if [ -n "$old" ]; then range="$old..HEAD"; else range=HEAD; fi
  git log --format=%H --grep="^This reverts commit $c\.$" "$range" | grep -q .
}

# --- drop commits whose revert is already on the branch --------------------
pending=()
if [ "${#abandoned[@]}" -gt 0 ]; then
  for c in "${abandoned[@]}"; do
    if already_reverted "$c"; then
      say "  skip    $(git log --oneline --no-decorate -1 "$c")  (already reverted)"
    else
      pending+=("$c")
    fi
  done
fi

if [ "${#pending[@]}" -eq 0 ] && git merge-base --is-ancestor "$target_sha" HEAD; then
  say "nothing left to revert and $target is already an ancestor — up to date"
  exit 0
fi
say "abandoned: ${#abandoned[@]}, already reverted: $(( ${#abandoned[@]} - ${#pending[@]} )), to revert: ${#pending[@]}"

# --- apply the reverts (newest first) --------------------------------------
if [ "${#pending[@]}" -gt 0 ]; then
  for c in "${pending[@]}"; do
    say "  git revert$(is_merge "$c" && printf ' -m 1' || true) $(git log --oneline --no-decorate -1 "$c")"
    if ! revert_one "$c"; then
      if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
        say "CONFLICT while reverting $(git log --oneline --no-decorate -1 "$c")"
        say "  resolve the conflicts, then run:  git revert --continue"
        say "  re-run this script afterwards; already-reverted commits are skipped"
        exit 2
      fi
      git revert --quit >/dev/null 2>&1 || true
      say "  no changes to commit (already in the target state); continuing"
    fi
  done
fi

# --- make TARGET an ancestor ----------------------------------------------
if git merge-base --is-ancestor "$target_sha" HEAD; then
  say "$target became reachable through the reverts"
else
  say "merging $target"
  if ! git merge --no-ff -m "Merge $target into $branch" "$target_sha"; then
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
      say "CONFLICT while merging $target"
      say "  resolve the conflicts, then commit the merge:  git commit"
      say "  or abort it:  git merge --abort"
      exit 2
    fi
    git merge --abort >/dev/null 2>&1 || true
    die "merge of $target failed; see git output above"
  fi
fi

git merge-base --is-ancestor "$target_sha" HEAD || die "post-check failed: $target is not an ancestor"
say "OK: $target is now an ancestor of $branch"
