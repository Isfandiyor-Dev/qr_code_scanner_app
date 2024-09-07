import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  static Database? _database;

  factory HistoryService() {
    return _instance;
  }

  HistoryService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'history_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT,
          scannetAt TEXT
        )
      ''');
  }

  Future<int> insertQrCode(String code) async {
    Database db = await database;
    return await db.insert('history', {
      "code": code,
      "scannetAt": DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getQrCodes() async {
    Database db = await database;
    return await db.query('history');
  }

  Future<int> deleteQrCode(int id) async {
    Database db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}
