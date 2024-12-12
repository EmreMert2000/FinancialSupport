import 'package:finance/Db/invoiceDb.dart';

import '../data/InvoiceFile.Dart';
import '../data/invoiceModel.dart';

class InvoiceViewModel {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createInvoice(Invoice invoice, List<InvoiceItem> items) async {
    final invoiceId = await _dbHelper.insertInvoice(invoice);
    for (var item in items) {
      item.invoiceId = invoiceId;
      await _dbHelper.insertInvoiceItem(item);
    }
    return invoiceId;
  }

  Future<List<Invoice>> getInvoices() {
    return _dbHelper.getInvoices();
  }

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) {
    return _dbHelper.getInvoiceItems(invoiceId);
  }

  Future<int> deleteInvoice(int id) {
    return _dbHelper.deleteInvoice(id);
  }
}
