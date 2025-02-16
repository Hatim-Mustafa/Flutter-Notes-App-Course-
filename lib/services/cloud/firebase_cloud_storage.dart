import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNewNote({required String userId}) async {
    final doc = await notes.add({
      userIdcol: userId,
      textcol: '',
    });

    final fetchedDoc = await doc.get();
    return CloudNote(text: '', docId: fetchedDoc.id, userId: userId);
  }

  Stream<Iterable<CloudNote>> allNotes({required String userId}) => notes
      .where(userIdcol, isEqualTo: userId)
      .snapshots()
      .map((event) => event.docs.map((e) => CloudNote.fromSnapshot(e)));

  Future<void> updateNote({
    required text,
    required docId,
  }) async {
    try {
      await notes.doc(docId).update({textcol: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String docId,
  }) async {
    try {
      await notes.doc(docId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
