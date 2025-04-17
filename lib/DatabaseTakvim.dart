import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime date;

  Task({this.id, required this.title, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}

class DatabaseTakvim {
  static final DatabaseTakvim instance = DatabaseTakvim._init();

  static Database? _database;

  DatabaseTakvim._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('databasetakvim.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE tasks (
      id $idType,
      date $textType,
      title $textType,
      description $textType
    )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;

    await db.insert('tasks', task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await instance.database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> fetchTasks(DateTime date) async {
    final db = await instance.database;

    final maps = await db.query(
      'tasks',
      columns: ['id', 'date', 'title', 'description'],
      where: 'date = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Task.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Task>> fetchUpcomingTasks() async {
    final db = await instance.database;
    final now = DateTime.now();
    final oneMonthLater = now.add(const Duration(days: 30));

    final maps = await db.query(
      'tasks',
      columns: ['id', 'date', 'title', 'description'],
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        now.toIso8601String().split('T')[0],
        oneMonthLater.toIso8601String().split('T')[0]
      ],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Task.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Task>> fetchAllTasks() async {
    final db = await instance.database;

    final maps = await db.query(
      'tasks',
      columns: ['id', 'date', 'title', 'description'],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Task.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteTask(Task task) async {
    final db = await instance.database;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> fetchTaskCount() async {
    final db = await instance.database;

    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tasks'));
    return count ?? 0;
  }
}
