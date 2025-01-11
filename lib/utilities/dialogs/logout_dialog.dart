import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> logoutDialog(BuildContext context) {
  final content = "Are you sure you want to logout?";
  return showGenericDialog<bool>(
    context: context,
    title: "Log Out",
    content: content,
    optionBuilder: () => {
      "No": false,
      "Yes": true,
    },
  ).then((value) => value ?? false);
}
