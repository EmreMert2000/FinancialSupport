import 'package:flutter/material.dart';
import 'package:finance/data/invoiceModel.dart';
import 'package:finance/Db/invoiceDb.dart';

class InvoiceViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    _products = await _dbHelper.fetchProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _dbHelper.insertProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    await loadProducts();
  }

  Future<void> updateProduct(int id, Product product) async {
    await _dbHelper.updateProduct(id, product);
    await loadProducts();
  }
}
