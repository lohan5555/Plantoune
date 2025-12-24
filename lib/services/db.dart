import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseService {
  static sql.Database? _database;

  static Future<sql.Database?> get database async {
    if (_database != null) return _database!;

    _database = await sql.openDatabase(
      join(await sql.getDatabasesPath(), 'plantoune.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plantes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            text TEXT,
            latitude REAl,
            longitude REAL,
            imagePath TEXT
          )
        ''');
      },
    );
    return _database;
  }
}