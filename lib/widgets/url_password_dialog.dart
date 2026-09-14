import 'package:bett_box/common/common.dart';
import 'package:bett_box/state.dart';
import 'package:flutter/material.dart';

import 'dialog.dart';

class UrlPasswordDialog extends StatefulWidget {
  final String user;
  final String? title;
  final String? labelText;
  final bool showRemember;

  const UrlPasswordDialog({
    super.key,
    required this.user,
    this.title,
    this.labelText,
    this.showRemember = true,
  });

  @override
  State<UrlPasswordDialog> createState() => _UrlPasswordDialogState();
}

class _UrlPasswordDialogState extends State<UrlPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    Navigator.of(context).pop<({String password, bool remember})>((
      password: _controller.text,
      remember: _remember,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: widget.title ?? appLocalizations.inputUrlPassword(widget.user),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
        TextButton(
          onPressed: _handleSubmit,
          child: Text(appLocalizations.submit),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: _controller,
              onFieldSubmitted: (_) => _handleSubmit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocalizations.emptyTip(
                    widget.labelText ?? appLocalizations.password,
                  );
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.labelText ?? appLocalizations.password,
              ),
            ),
            if (widget.showRemember) ...[
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _remember,
                onChanged: (value) {
                  setState(() {
                    _remember = value ?? false;
                  });
                },
                title: Text(appLocalizations.rememberUrlPassword),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<({String password, bool remember})?> showUrlPasswordDialog(
  String user,
) {
  return globalState.showCommonDialog<({String password, bool remember})>(
    child: UrlPasswordDialog(user: user),
  );
}

Future<String?> showPassphraseDialog(String keyPath) async {
  final result = await globalState.showCommonDialog<
    ({String password, bool remember})
  >(
    child: UrlPasswordDialog(
      user: keyPath,
      title: appLocalizations.sshPassphraseTitle(keyPath),
      labelText: appLocalizations.sshPassphrase,
      showRemember: false,
    ),
  );
  return result?.password;
}