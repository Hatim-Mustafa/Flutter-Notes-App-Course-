import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> errorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: content,
    optionBuilder: () => {"OK": null},
  );
}
