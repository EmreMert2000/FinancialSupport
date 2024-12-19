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
    return openDatabase(
      path,
      version: 2, // Veritabanı versiyonunu artırıyoruz
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE companies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            debt REAL NOT NULL,
            credit REAL NOT NULL,
            date TEXT NOT NULL -- Yeni tarih sütunu
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Eğer eski veritabanı varsa, tablonun yapısını güncelleme
          await db.execute('''
            CREATE TABLE IF NOT EXISTS companies_temp (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              debt REAL NOT NULL,
              credit REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');

          // Eski tablodan veriyi geçici tabloya taşıyoruz
          final result = await db.query('companies');
          for (var row in result) {
            await db.insert('companies_temp', {
              'id': row['id'],
              'name': row['name'],
              'debt': row['debt'],
              'credit': row['credit'],
              'date': row['date'],
            });
          }

          // Eski tabloyu siliyoruz
          await db.execute('DROP TABLE companies');

          // Geçici tabloyu 'companies' olarak yeniden adlandırıyoruz
          await db.execute('ALTER TABLE companies_temp RENAME TO companies');
        }
      },
    );
  }

  // Şirketleri almak için getCompanies fonksiyonu
  Future<List<Company>> getCompanies() async {
    final db = await database;
    final result = await db.query('companies');
    return result.map((c) => Company.fromMap(c)).toList();
  }

  // Şirket ekleme
  Future<int> insertCompany(Company company) async {
    final db = await database;
    return await db.insert('companies', company.toMap());
  }

  // Şirket güncelleme
  Future<int> updateCompany(Company company) async {
    final db = await database;
    return await db.update(
      'companies',
      company.toMap(),
      where: 'id = ?',
      whereArgs: [company.id],
    );
  }

  // Şirket silme
  Future<int> deleteCompany(int id) async {
    final db = await database;
    return await db.delete('companies', where: 'id = ?', whereArgs: [id]);
  }
}
