import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHarcamalar {
  static final DatabaseHarcamalar instance = DatabaseHarcamalar._init();

  static Database? _database;

  DatabaseHarcamalar._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('harcamalar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const realType = 'REAL NOT NULL';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE harcamalar (
      id $idType,
      miktar $realType,
      aciklama $textType,
      tarih $dateType
    )
    ''');
  }

  Future<void> create(Harcama harcama) async {
    final db = await instance.database;

    await db.insert(
      'harcamalar',
      harcama.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Harcama>> readAllHarcamalar() async {
    final db = await instance.database;

    const orderBy = 'id ASC';
    final result = await db.query('harcamalar', orderBy: orderBy);

    return result.map((json) => Harcama.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'harcamalar',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

class Harcama {
  final int? id;
  final double miktar;
  final String aciklama;
  final DateTime tarih;

  Harcama({this.id, required this.miktar, required this.aciklama, required this.tarih});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'miktar': miktar,
      'aciklama': aciklama,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory Harcama.fromMap(Map<String, dynamic> map) {
    return Harcama(
      id: map['id'],
      miktar: map['miktar'],
      aciklama: map['aciklama'],
      tarih: DateTime.parse(map['tarih']),
    );
  }
}
