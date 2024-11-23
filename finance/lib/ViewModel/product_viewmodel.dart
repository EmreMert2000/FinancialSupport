import 'package:flutter/material.dart';
import 'package:finance/data/product.dart';
import 'package:finance/Db/db_helper.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> fetchProducts() async {
    _products = await _dbHelper.fetchProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _dbHelper.insertProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    await fetchProducts();
  }

 
}
