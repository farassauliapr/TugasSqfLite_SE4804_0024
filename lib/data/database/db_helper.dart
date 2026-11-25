import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const _dbName = 'Barang.db';
  static const tableName = 'Nama';

  static const _dbVersion = 2;

  static const _createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT NOT NULL,
      stok INTEGER NOT NULL
    )
  ''';

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();

    return openDatabase(
      '$dir/$_dbName',
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(_createTable);
      },
    );
  }
}