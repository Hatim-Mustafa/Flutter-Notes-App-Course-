import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

const dbName = "notes.db";
const notetable = "notes";
const userTable = "user";
const idcol = "Id";
const emailcol = "email";
const userIdcol = "user_id";
const notecol = "note";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "Id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("Id" AUTOINCREMENT)
      );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "notes" (
        "Id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "note"	TEXT,
        PRIMARY KEY("Id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("Id")
      );''';

class NotesService {
  Database? _db;

  NotesService._sharedInstance();
  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  List<DatabaseNotes> _notes = [];

  final _notesStreamController =
      StreamController<List<DatabaseNotes>>.broadcast();

  Stream<List<DatabaseNotes>> get AllNotes => _notesStreamController.stream;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);

    final ExistingNote = await db.update(
      notetable,
      {notecol: text},
      where: "id = ?", //Added by myself
      whereArgs: [note.id], //Added by myself
    );

    if (ExistingNote == 0) {
      throw CouldNotUpdateNote();
    } else {
      //Some code not written from video (time: 19:57:10)
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final allNotes = await db.query(notetable);

    return allNotes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      notetable,
      where: "$idcol = ?",
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNotes.fromRow(results.first);
      _notes.remove((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final delNote = await db.delete(notetable);

    if (delNote == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes = [];
      _notesStreamController.add(_notes);
      return delNote;
    }
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();

    final delNote = await db.delete(
      notetable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (delNote == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    final noteID = await db.insert(
      notetable,
      {
        userIdcol: owner.id,
        notecol: text,
      },
    );

    final note = DatabaseNotes(
      id: noteID,
      user_id: owner.id,
      note: text,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    } else {
      final userId = await db.insert(
        userTable,
        {emailcol: email.toLowerCase()},
      );
      return DatabaseUser(
        id: userId,
        email: email.toLowerCase(),
      );
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> _ensureDBisOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToFindDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  factory DatabaseUser.fromRow(Map<String, Object?> map) => DatabaseUser(
        id: map[idcol] as int,
        email: map[emailcol] as String,
      );

  @override
  String toString() => "Person, ID: $id, email: $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;
}

class DatabaseNotes {
  final int id;
  final int user_id;
  final String note;

  DatabaseNotes({
    required this.id,
    required this.user_id,
    required this.note,
  });

  factory DatabaseNotes.fromRow(Map<String, Object?> map) => DatabaseNotes(
        id: map[idcol] as int,
        user_id: map[userIdcol] as int,
        note: map[notecol] as String,
      );

  @override
  String toString() => "Note, ID: $id, User ID: $user_id";

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;
}
