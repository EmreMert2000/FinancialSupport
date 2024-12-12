import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/invoiceFile.dart';
import '../data/invoiceModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'invoice.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE invoices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            companyName TEXT,
            totalPrice REAL,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE invoice_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invoiceId INTEGER,
            name TEXT,
            quantity INTEGER,
            price REAL,
            FOREIGN KEY (invoiceId) REFERENCES invoices (id)
          )
        ''');
      },
    );
  }

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await database;
    return await db.insert('invoices', invoice.toMap());
  }

  Future<List<Invoice>> getInvoices() async {
    final db = await database;
    final result = await db.query('invoices');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<int> insertInvoiceItem(InvoiceItem item) async {
    final db = await database;
    return await db.insert('invoice_items', item.toMap());
  }

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) async {
    final db = await database;
    final result = await db.query(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );
    return result.map((map) => InvoiceItem.fromMap(map)).toList();
  }

  Future<int> deleteInvoice(int id) async {
    final db = await database;
    await db.delete('invoice_items', where: 'invoiceId = ?', whereArgs: [id]);
    return await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }
}
