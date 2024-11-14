import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:school_pags/model/notes_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  // Static getter for the instance
  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, color TEXT, dateTime TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // New method to retrieve a note by its ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null; // Return null if no note found
  }

  // New method to count total notes
  Future<int> countNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM notes');
    return Sqflite.firstIntValue(result) ??
        0; // Returns the count or 0 if no notes
  }
}
