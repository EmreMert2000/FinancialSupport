import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance/data/invoice.dart';

import 'package:finance/data/missing_item.dart';
import 'package:finance/data/product.dart';

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
      version: 1,
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

    // İrsaliye tablosu
    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // İrsaliye öğeleri tablosu
    await db.execute('''
      CREATE TABLE invoice_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceId INTEGER NOT NULL,
        description TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY(invoiceId) REFERENCES invoices(id)
      )
    ''');

    // Muhasebe tablosu
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        companyName TEXT NOT NULL,
        debt REAL NOT NULL,
        credit REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          companyName TEXT NOT NULL,
          debt REAL NOT NULL,
          credit REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    }
    // Diğer versiyon yükseltmeleri eklenebilir.
  }

  // CRUD İşlemleri

  // Ürün işlemleri
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> fetchProducts() async {
    final db = await instance.database;
    final maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearProducts() async {
    final db = await instance.database;
    await db.delete('products');
  }

  // Eksik öğeler işlemleri
  Future<int> insertMissingItem(MissingItem item) async {
    final db = await database;
    return await db.insert('missing_items', {'name': item.name});
  }

  Future<List<MissingItem>> fetchMissingItems() async {
    final db = await database;
    final maps = await db.query('missing_items');
    return maps.map((map) => MissingItem.fromMap(map)).toList();
  }

  Future<int> deleteMissingItem(int id) async {
    final db = await database;
    return await db.delete('missing_items', where: 'id = ?', whereArgs: [id]);
  }

  // İrsaliye işlemleri
 // İrsaliye ve ürünleri birlikte al
  Future<List<Invoice>> fetchInvoicesWithItems() async {
    final db = await database;

    // İlk olarak tüm invoices'ı alalım
    final List<Map<String, dynamic>> invoiceMaps = await db.query('invoices');
    List<Invoice> invoices = invoiceMaps.map((map) => Invoice.fromMap(map)).toList();

    // Her invoice için ilgili invoice_items'ı alalım
    for (var invoice in invoices) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [invoice.id],
      );
      invoice.items = itemMaps.map((map) => InvoiceItem.fromMap(map)).toList();
    }

    return invoices;
  }

  // İrsaliye eklemek
  Future<int> insertInvoice(Invoice invoice) async {
    final db = await database;
    return await db.insert('invoices', invoice.toMap());
  }

  // İrsaliye silmek
  Future<int> deleteInvoice(int id) async {
    final db = await database;
    return await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }
}
