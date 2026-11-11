#!/usr/bin/env bash
#
# reconcile-upstream.sh [TARGET]
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
# TARGET defaults to the newest upstream release tag (vX.Y.Z[-preN]); pass any
# upstream commit-ish otherwise (e.g. upstream/main, or a specific commit). The
# "new tag" is just one instance of that.
#
# Merge commits are reverted too (with `-m 1`): this branch never pushes
# upstream, so nothing of ours lives inside an upstream merge and there is no
# merge-unique content of ours to preserve — we just mirror TARGET.
#
# Env:
#   BRANCH           branch to reconcile              (default android_legacy)
#   UPSTREAM_REMOTE  remote name                      (default upstream)
#   UPSTREAM_URL     url used if the remote is absent (default appshubcc/Bettbox)
#   PUSH=1           push the branch when done        (default: no push)
#   DRY_RUN=1        stop after the pre-flight dry run (default: apply)
#
# Run with -h/--help for the full usage.
#
set -euo pipefail

branch=${BRANCH:-android_legacy}
remote=${UPSTREAM_REMOTE:-upstream}
upstream_url=${UPSTREAM_URL:-https://github.com/appshubcc/Bettbox.git}
push=${PUSH:-0}
dry_run=${DRY_RUN:-0}
release_re='^v[0-9]+\.[0-9]+\.[0-9]+(-pre[0-9]+)?$'
exclude_re='-android-legacy$'

say() { printf '==> %s\n' "$*" >&2; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: reconcile-upstream.sh [TARGET]

Make TARGET an ancestor of the fork branch by reverting the upstream commits
that TARGET no longer contains ("abandoned" commits), then merging TARGET.
Run it after upstream rewrites `main` (force-push) and the branch still carries
commits from the old line.

Arguments:
  TARGET   upstream commit-ish to adopt; defaults to the newest upstream
           release tag matching vX.Y.Z[-preN] (e.g. v1.19.8-pre1).
           Examples: v1.19.8-pre1, upstream/main, a commit hash.

Options:
  -h, --help   show this help and exit

Environment variables (no flags):
  BRANCH           branch to reconcile                (default: android_legacy)
  UPSTREAM_REMOTE  remote name                        (default: upstream)
  UPSTREAM_URL     URL used if the remote is absent   (default: appshubcc/Bettbox)
  PUSH=1           push the branch when done          (default: no push)
  DRY_RUN=1        stop after the pre-flight dry run  (default: apply)

Exit status:
  0   reconciled, or already up to date
  1   precondition or usage error
  2   a revert conflicts; nothing was changed

The dry run always runs first: the whole revert series is simulated, the first
conflicting commit is named, and the working tree is left untouched.
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
target_arg=${1:-}

# --- preconditions ---------------------------------------------------------
[ -z "$(git status --porcelain)" ] || die "working tree not clean"
git rev-parse --verify --quiet "refs/heads/$branch" >/dev/null || die "no branch: $branch"
[ "$(git branch --show-current)" = "$branch" ] || die "checkout '$branch' first"

git remote get-url "$remote" >/dev/null 2>&1 || {
  say "adding remote $remote"
  git remote add "$remote" "$upstream_url"
}

say "fetching from $remote"
git fetch --force "$remote" '+refs/heads/*:refs/remotes/'"$remote"'/*' '+refs/tags/*:refs/tags/*' >/dev/null

# --- pick TARGET -----------------------------------------------------------
if [ -n "$target_arg" ]; then
  target=$target_arg
else
  target=$(git tag --list 'v*' | grep -E -- "$release_re" | grep -vE -- "$exclude_re" | sort -V | tail -n1 || true)
fi
[ -n "$target" ] || die "no TARGET and no upstream release tag matching $release_re"
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

if [ "${#abandoned[@]}" -eq 0 ] && git merge-base --is-ancestor "$target_sha" HEAD; then
  say "nothing abandoned and $target is already an ancestor — up to date"
  exit 0
fi

is_merge() { [ "$(git rev-list --parents -n1 "$1" | wc -w)" -gt 2 ]; }

revert_one() { # revert_one <commit> <mode: dry|apply>
  local c=$1 mode=$2
  if is_merge "$c"; then
    if [ "$mode" = dry ]; then git revert -n -m 1 --no-edit "$c" >/dev/null 2>&1
    else                        git revert    -m 1 --no-edit "$c"; fi
  else
    if [ "$mode" = dry ]; then git revert -n --no-edit "$c" >/dev/null 2>&1
    else                        git revert    --no-edit "$c"; fi
  fi
}

# --- pre-flight: surface the first revert that would conflict ---------------
# Simulate the whole sequence first (no lasting change) so we report the exact
# commit that breaks instead of leaving half-applied reverts behind.
clean_count=0
conflict_commit=""
if [ "${#abandoned[@]}" -gt 0 ]; then
  start_sha=$(git rev-parse HEAD)
  for c in "${abandoned[@]}"; do
    if revert_one "$c" dry; then clean_count=$((clean_count + 1)); else conflict_commit=$c; break; fi
  done
  git revert --abort >/dev/null 2>&1 || true
  git reset -q --hard "$start_sha"
  [ -z "$(git status --porcelain)" ] || die "dry-run left the tree dirty; refusing to continue"
fi

if [ -n "$conflict_commit" ]; then
  say "DRY-RUN: ${clean_count}/${#abandoned[@]} revert cleanly, then this conflicts:"
  say "         $(git log --oneline --no-decorate -1 "$conflict_commit")"
  say "         nothing changed; resolve manually or choose another TARGET"
  exit 2
fi
say "dry-run: all ${#abandoned[@]} revert(s) apply cleanly"

if [ "$dry_run" = 1 ]; then
  say "DRY_RUN=1: stopping before applying"
  exit 0
fi

# --- apply the reverts (newest first) --------------------------------------
if [ "${#abandoned[@]}" -gt 0 ]; then
  say "reverting ${#abandoned[@]} abandoned commit(s)"
  for c in "${abandoned[@]}"; do
    say "  git revert$(is_merge "$c" && printf ' -m 1' || true) $(git log --oneline --no-decorate -1 "$c")"
    if ! revert_one "$c" apply; then
      git revert --abort 2>/dev/null || true
      die "unexpected conflict at $c; resolve manually"
    fi
  done
fi

# --- make TARGET an ancestor ----------------------------------------------
if git merge-base --is-ancestor "$target_sha" HEAD; then
  say "$target became reachable through the reverts"
else
  say "merging $target"
  if ! git merge --no-ff -m "Merge $target into $branch" "$target_sha"; then
    git merge --abort 2>/dev/null || true
    die "merge of $target hit a conflict; resolve manually"
  fi
fi

git merge-base --is-ancestor "$target_sha" HEAD || die "post-check failed: $target is not an ancestor"
say "OK: $target is now an ancestor of $branch"

if [ "$push" = 1 ]; then
  say "pushing $branch"
  git push origin "$branch"
else
  say "done (not pushed; set PUSH=1 to push)"
fi
