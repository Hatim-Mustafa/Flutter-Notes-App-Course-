import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> DeleteDialog(BuildContext context) {
  final content = "Are you sure you want to delete?";
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: content,
    optionBuilder: () => {
      "No": false,
      "Yes": true,
    },
  ).then((value) => value ?? false);
}