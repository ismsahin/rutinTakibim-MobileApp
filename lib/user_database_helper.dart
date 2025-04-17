import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  factory UserDatabaseHelper() => _instance;
  UserDatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, surname TEXT, image BLOB)",
    );
  }

  Future<void> saveUserInfo(String name, String surname, File? imageFile) async {
    final db = await database;
    Uint8List? imageBytes;

    if (imageFile != null) {
      imageBytes = await imageFile.readAsBytes();
    }

    await db.insert('User', {
      'name': name,
      'surname': surname,
      'image': imageBytes,
    });
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final db = await database;
    List<Map<String, dynamic>> users = await db.query('User');
    if (users.isNotEmpty) {
      Map<String, dynamic> user = users.first;
      if (user['image'] != null) {
        Uint8List imageBytes = user['image'];
        Directory tempDir = await getTemporaryDirectory();
        File imageFile = File('${tempDir.path}/user_image.png');
        await imageFile.writeAsBytes(imageBytes);
        user['imageFile'] = imageFile;
      }
      return user;
    } else {
      return {};
    }
  }
}
