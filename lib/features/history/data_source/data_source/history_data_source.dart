import 'package:qr_code_app/features/history/data_source/models/scan_qr/scan_qr_request.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

/// Local sqflite data source for scanned and generated QR history.
class HistoryDataSource {
  static final HistoryDataSource _instance = HistoryDataSource._internal();
  static Database? _database;

  factory HistoryDataSource() {
    return _instance;
  }

  HistoryDataSource._internal();

  /// Lazily opens the history database.
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

  /// Inserts [qrCode] or refreshes its timestamp when the same code exists.
  Future<int> insertQrCode(QrCodeRequest qrCode) async {
    final Database db = await database;
    final existing = await db.query(
      'history',
      where: 'code = ?',
      whereArgs: [qrCode.code],
    );

    if (existing.isNotEmpty) {
      return await db.update(
        'history',
        {'scannedAt': DateTime.now().toIso8601String()},
        where: 'code = ?',
        whereArgs: [qrCode.code],
      );
    } else {
      return await db.insert('history', qrCode.toJson());
    }
  }

  /// Returns all stored QR history rows.
  Future<List<Map<String, dynamic>>> getQrCodes() async {
    Database db = await database;
    return await db.query('history');
  }

  /// Deletes a QR history row by database [id].
  Future<int> deleteQrCode(int id) async {
    Database db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}
