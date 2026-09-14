import 'package:bett_box/common/common.dart';
import 'package:bett_box/state.dart';
import 'package:flutter/material.dart';

import 'dialog.dart';

class UrlPasswordDialog extends StatefulWidget {
  final String user;

  const UrlPasswordDialog({super.key, required this.user});

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
      title: appLocalizations.inputUrlPassword(widget.user),
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
                  return appLocalizations.emptyTip(appLocalizations.password);
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: appLocalizations.password,
              ),
            ),
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