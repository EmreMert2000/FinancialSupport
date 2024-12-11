import 'package:finance/Db/invoiceDb.dart';

import '../data/invoiceModel.dart';

class InvoiceViewModel {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> createInvoice(Invoice invoice, List<InvoiceItem> items) async {
    final db = await _databaseHelper.database;

    final invoiceId = await db.insert('invoices', invoice.toMap());
    for (var item in items) {
      await db.insert(
          'invoiceItems', item.copyWith(invoiceId: invoiceId).toMap());
    }

    return invoiceId;
  }

  Future<List<Invoice>> getInvoices() async {
    final db = await _databaseHelper.database;
    final result = await db.query('invoices', orderBy: 'createdAt DESC');

    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) async {
    final db = await _databaseHelper.database;
    final result = await db
        .query('invoiceItems', where: 'invoiceId = ?', whereArgs: [invoiceId]);

    return result.map((map) => InvoiceItem.fromMap(map)).toList();
  }
}

extension on InvoiceItem {
  copyWith({required int invoiceId}) {}
}
