import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

/// Local persistence for QR design configurations.
///
/// Mirrors [HistoryDataSource]: a singleton wrapping a lazily-opened sqflite
/// database in its own file (never touches `history_database.db`).
///
/// Two tables:
/// * `qr_design_items` - one row **per QR code** (`code` is the primary key),
///   so every QR keeps its own independent design.
/// * `qr_design_default` - a single row holding the global default design that
///   newly created QR codes fall back to.
class QrDesignDataSource {
  static final QrDesignDataSource _instance = QrDesignDataSource._internal();
  static Database? _database;

  static const int _defaultRowId = 1;
  static const int _dbVersion = 2;

  /// Returns the singleton QR design data source.
  factory QrDesignDataSource() => _instance;

  QrDesignDataSource._internal();

  /// Lazily opens the QR design database.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'qr_design_database.db');
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE qr_design_items (
          code TEXT PRIMARY KEY,
          config TEXT NOT NULL
        )
      ''');
    await db.execute('''
        CREATE TABLE qr_design_default (
          id INTEGER PRIMARY KEY,
          config TEXT NOT NULL
        )
      ''');
  }

  /// Migrates the original single-config schema (v1) to the per-code + default
  /// schema (v2), preserving the old design as the new global default.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS qr_design_items (
            code TEXT PRIMARY KEY,
            config TEXT NOT NULL
          )
        ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS qr_design_default (
            id INTEGER PRIMARY KEY,
            config TEXT NOT NULL
          )
        ''');
      try {
        final legacy = await db.query(
          'qr_design',
          where: 'id = ?',
          whereArgs: [1],
          limit: 1,
        );
        if (legacy.isNotEmpty) {
          await db.insert(
            'qr_design_default',
            {'id': _defaultRowId, 'config': legacy.first['config']},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await db.execute('DROP TABLE IF EXISTS qr_design');
      } catch (_) {
        // A failed legacy migration must never block opening the database.
      }
    }
  }

  // Per-QR designs.

  /// Returns the stored config JSON for [code], or `null` if none is saved.
  Future<String?> getConfigForCode(String code) async {
    final db = await database;
    final rows = await db.query(
      'qr_design_items',
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['config'] as String?;
  }

  /// Upserts the design [configJson] for [code].
  Future<void> saveConfigForCode(String code, String configJson) async {
    final db = await database;
    await db.insert(
      'qr_design_items',
      {'code': code, 'config': configJson},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes the saved design for [code] (falls back to the default next load).
  Future<void> deleteConfigForCode(String code) async {
    final db = await database;
    await db.delete('qr_design_items', where: 'code = ?', whereArgs: [code]);
  }

  // Global default design.

  /// Returns the global default config JSON, or `null` if never set.
  Future<String?> getDefaultConfig() async {
    final db = await database;
    final rows = await db.query(
      'qr_design_default',
      where: 'id = ?',
      whereArgs: [_defaultRowId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['config'] as String?;
  }

  /// Upserts the global default config.
  Future<void> saveDefaultConfig(String configJson) async {
    final db = await database;
    await db.insert(
      'qr_design_default',
      {'id': _defaultRowId, 'config': configJson},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
