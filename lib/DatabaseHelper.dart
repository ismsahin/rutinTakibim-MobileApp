import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE todos (
      id $idType,
      task $textType,
      isCompleted $boolType DEFAULT 0
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE todos ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future<void> create(String task) async {
    final db = await instance.database;

    await db.insert(
      'todos',
      {'task': task, 'isCompleted': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> readAllTodos() async {
    final db = await instance.database;

    const orderBy = 'id ASC';
    return await db.query('todos', orderBy: orderBy);
  }

  Future<void> updateCompletion(int id, int isCompleted) async {
    final db = await instance.database;

    await db.update(
      'todos',
      {'isCompleted': isCompleted},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getCountOfIncompleteTodos() async {
    final db = await instance.database;

    var result = await db.rawQuery('SELECT COUNT(*) FROM todos WHERE isCompleted = 0');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  Future<int> getCountOfCompletedTodos() async {
    final db = await instance.database;

    var result = await db.rawQuery('SELECT COUNT(*) FROM todos WHERE isCompleted = 1');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }
}
