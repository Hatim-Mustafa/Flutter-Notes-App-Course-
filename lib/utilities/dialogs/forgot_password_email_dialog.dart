import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> PasswordEmailDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Reset Password",
    content: "Email successfully sent",
    optionBuilder: () => {"OK": null},
  );
}