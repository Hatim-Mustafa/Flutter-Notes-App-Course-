import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String text;
  final String docId;
  final String userId;

  CloudNote({
    required this.text,
    required this.docId,
    required this.userId,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        userId = snapshot.data()[userIdcol] as String,
        text = snapshot.data()[textcol] as String;
}
