import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance/data/product.dart';
import 'package:finance/data/missing_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'financial_support.db');
    return await openDatabase(
      path,
      version: 3, // Veritabanı sürümünü 3 olarak belirleyin
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Kullanıcı tablosu
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Ürün tablosu
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Eksik öğeler tablosu
    await db.execute('''
      CREATE TABLE missing_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Eksik öğeler tablosunu ekle
      await db.execute('''
        CREATE TABLE missing_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Eğer versiyon 3'e yükseltiyorsanız, 'products' tablosu zaten 'onCreate' içinde oluşturulmuş olmalı
      // Burada herhangi bir işlem yapmanıza gerek yok
    }
  }

  // Kullanıcı işlemleri
  Future<int> insertUser(String username, String password) async {
    Database db = await instance.database;
    return await db.insert('users', {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    Database db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Ürün işlemleri
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    try {
      return await db.insert('products', product.toMap());
    } catch (e) {
      print("Product insertion error: $e");
      return -1; // Hata durumunda negatif bir değer döner
    }
  }

  Future<List<Product>> fetchProducts() async {
    final db = await instance.database;
    try {
      final maps = await db.query('products');
      return maps.map((map) {
        return Product(
          id: map['id'] as int?,
          name: map['name'] as String,
          quantity: map['quantity'] as int,
          price: map['price'] is int ? (map['price'] as int).toDouble() : map['price'] as double,
        );
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    try {
      return await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Product deletion error: $e");
      return -1;
    }
  }

  Future<void> clearProducts() async {
    final db = await instance.database;
    try {
      await db.delete('products');
    } catch (e) {
      print("Error clearing products: $e");
    }
  }

  // Eksik öğeler işlemleri
  Future<int> insertMissingItem(MissingItem item) async {
    final db = await database;
    return await db.insert('missing_items', {'name': item.name});
  }

  Future<List<MissingItem>> fetchMissingItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('missing_items');

    return List.generate(
      maps.length,
      (i) => MissingItem(id: maps[i]['id'], name: maps[i]['name']),
    );
  }

  Future<int> deleteMissingItem(int id) async {
    final db = await database;
    return await db.delete('missing_items', where: 'id = ?', whereArgs: [id]);
  }

  
}
