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
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'company.db');
      return openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        debt REAL NOT NULL,
        credit REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS companies_temp (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          debt REAL NOT NULL,
          credit REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');

      // Eski verileri geçici tabloya taşı
      final existingData = await db.query('companies');
      for (var row in existingData) {
        await db.insert('companies_temp', {
          'id': row['id'],
          'name': row['name'],
          'debt': row['debt'],
          'credit': row['credit'],
          // Eğer tarih eksikse varsayılan bir tarih eklenebilir
          'date': row['date'] ?? DateTime.now().toIso8601String(),
        });
      }

      // Eski tabloyu sil ve geçici tabloyu yeniden adlandır
      await db.execute('DROP TABLE companies');
      await db.execute('ALTER TABLE companies_temp RENAME TO companies');
    }
  }

  // Şirketleri almak
  Future<List<Company>> getCompanies() async {
    try {
      final db = await database;
      final result = await db.query('companies');
      return result.map((c) => Company.fromMap(c)).toList();
    } catch (e) {
      print("Error fetching companies: $e");
      return [];
    }
  }

  // Şirket eklemek
  Future<int> insertCompany(Company company) async {
    try {
      final db = await database;
      return await db.insert('companies', company.toMap());
    } catch (e) {
      print("Error inserting company: $e");
      return -1;
    }
  }

  // Şirket güncellemek
  Future<int> updateCompany(Company company) async {
    try {
      final db = await database;
      return await db.update(
        'companies',
        company.toMap(),
        where: 'id = ?',
        whereArgs: [company.id],
      );
    } catch (e) {
      print("Error updating company: $e");
      return -1;
    }
  }

  // Şirket silmek
  Future<int> deleteCompany(int id) async {
    try {
      final db = await database;
      return await db.delete('companies', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting company: $e");
      return -1;
    }
  }
}
