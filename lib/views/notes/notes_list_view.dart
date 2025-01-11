import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {
  const NotesListView(
      {super.key, required this.notes, required this.onDeleteNote});

  final List<DatabaseNotes> notes;
  final DeleteNoteCallBack onDeleteNote;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.note,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await DeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
