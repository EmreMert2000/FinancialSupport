import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance/data/company.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'company.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE companies (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          debt REAL NOT NULL,
          credit REAL NOT NULL
        )
      ''');
    });
  }

  Future<List<Company>> getCompanies() async {
    final db = await database;
    final result = await db.query('companies');
    return result.map((c) => Company.fromMap(c)).toList();
  }

  Future<int> insertCompany(Company company) async {
    final db = await database;
    return await db.insert('companies', company.toMap());
  }

  Future<int> updateCompany(Company company) async {
    final db = await database;
    return await db.update(
      'companies',
      company.toMap(),
      where: 'id = ?',
      whereArgs: [company.id],
    );
  }

  Future<int> deleteCompany(int id) async {
    final db = await database;
    return await db.delete('companies', where: 'id = ?', whereArgs: [id]);
  }
}
