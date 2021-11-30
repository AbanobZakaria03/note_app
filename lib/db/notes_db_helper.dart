import 'dart:async';

import 'package:note_app/model/note.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  final String tableName = "myTable";
  final int version = 1;
  final String id = '_id'; //in sqlite database we have always _ before id
  final String title = 'title';
  final String description = 'description';
  final String time = 'time';

  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final boolType = 'BOOLEAN NOT NULL';
  final integerType = 'INTEGER NOT NULL';
  final textType = 'TEXT NOT NULL';

  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    // onCreate is called if the database did not exist
    // onUpgrade is called if the database version increment
    // onDowngrade is called if the database version decrement
    return await openDatabase(path, version: version, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableName(
    $id $idType,
    $title $textType,
    $description $textType,
    $time $textType
    )
    ''');
  }

  Future<Note> addNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      where: '${this.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '$time ASC';
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      tableName,
      note.toJson(),
      where: '$id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      tableName,
      where: '${this.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}
