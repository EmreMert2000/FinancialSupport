import 'package:flutter/material.dart';
import '../Db/db_helper.dart';
import '../data/invoice.dart';

class InvoiceViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;

  // Faturaları ve her faturadaki ürünleri veritabanından al
  Future<void> fetchInvoices() async {
    _invoices = await _dbHelper.fetchInvoicesWithItems();
    notifyListeners();
  }

  // Yeni bir irsaliye eklemek
  Future<void> addInvoice(Invoice invoice) async {
    await _dbHelper.insertInvoice(invoice);
    await fetchInvoices();
  }

  // Bir irsaliye silmek
  Future<void> deleteInvoice(int id) async {
    await _dbHelper.deleteInvoice(id);
    await fetchInvoices();
  }
}
