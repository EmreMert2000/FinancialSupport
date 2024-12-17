import 'package:flutter/material.dart';
import 'package:finance/data/product.dart';
import 'package:finance/Db/db_helper.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  String? errorMessage;
  final DatabaseHelper _dbHelper;

  // Yapıcı metod ile bağımlılık enjeksiyonu
  ProductViewModel({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Veritabanından ürünleri çekme
  Future<void> fetchProducts() async {
    try {
      _products = await _dbHelper.fetchProducts();
      print('Fetched products: $_products'); // Debugging purpose
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error fetching products: $e';
      print('Error fetching products: $e');
      notifyListeners(); // Error mesajı UI'da görünsün
    }
  }

  // Ürün ekleme
  Future<void> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      _products.add(product); // Yeni ürünü listeye ekle
      notifyListeners(); // Listeyi güncelle
    } catch (e) {
      errorMessage = 'Error adding product: $e';
      print('Error adding product: $e');
      notifyListeners(); // Error mesajı UI'da görünsün
    }
  }

  // Ürün silme
  Future<void> deleteProduct(int id) async {
    try {
      await _dbHelper.deleteProduct(id);
      _products.removeWhere(
          (product) => product.id == id); // Silinen ürünü listeden çıkar
      notifyListeners(); // Listeyi güncelle
    } catch (e) {
      errorMessage = 'Error deleting product: $e';
      print('Error deleting product: $e');
      notifyListeners(); // Error mesajı UI'da görünsün
    }
  }

  // Ürün güncelleme
  Future<void> editProduct(Product updatedProduct) async {
    try {
      await _dbHelper
          .updateProduct(updatedProduct); // Ürünü veritabanında güncelle
      // Listede güncellenmiş ürünü bul ve yenisiyle değiştir
      int index =
          _products.indexWhere((product) => product.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      notifyListeners(); // Listeyi güncelle
    } catch (e) {
      errorMessage = 'Error updating product: $e';
      print('Error updating product: $e');
      notifyListeners(); // Error mesajı UI'da görünsün
    }
  }
}
