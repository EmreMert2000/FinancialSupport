import 'package:flutter/material.dart';
import '../Db/db_helper.dart';
import '../data/invoice.dart';
import '../data/invoice_item.dart';

class InvoiceViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;

  Future<void> fetchInvoices() async {
    _invoices = await _dbHelper.fetchInvoices();
    notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    await _dbHelper.insertInvoice(invoice);
    await fetchInvoices();
  }

  Future<void> deleteInvoice(int id) async {
    await _dbHelper.deleteInvoice(id);
    await fetchInvoices();
  }
}
