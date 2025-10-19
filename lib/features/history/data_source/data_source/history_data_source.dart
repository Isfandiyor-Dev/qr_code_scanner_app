import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_request.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class HistoryDataSource {
  static final HistoryDataSource _instance = HistoryDataSource._internal();
  static Database? _database;

  factory HistoryDataSource() {
    return _instance;
  }

  HistoryDataSource._internal();

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
          scannedAt TEXT,
          isGenerated INTEGER
        )
      ''');
  }

  Future<int> insertQrCode(QrCodeRequest qrCode) async {
    final Database db = await database;
    // Avval shu kod bazada bormi, tekshiramiz
    final existing = await db.query(
      'history',
      where: 'code = ?',
      whereArgs: [qrCode.code],
    );

    if (existing.isNotEmpty) {
      // Agar bor bo‘lsa — faqat vaqtini yangilaymiz
      return await db.update(
        'history',
        {'scannedAt': DateTime.now().toIso8601String()},
        where: 'code = ?',
        whereArgs: [qrCode.code],
      );
    } else {
      // Agar yo‘q bo‘lsa — yangi yozuv qo‘shamiz
      return await db.insert('history', qrCode.toJson());
    }
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
