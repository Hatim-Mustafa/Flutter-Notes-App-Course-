import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: "Cannot Share Empty Note",
    optionBuilder: () => {"OK": null},
  );
}