import 'package:flutter/material.dart';
import 'package:finance/data/product.dart';
import 'package:finance/Db/db_helper.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _allProducts = []; // Tüm ürünler burada saklanır
  List<Product> _products = []; // Filtrelenmiş ürünler burada saklanır
  List<Product> get products => _products;

  String? errorMessage;
  final DatabaseHelper _dbHelper;

  // Yapıcı metod ile bağımlılık enjeksiyonu
  ProductViewModel({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Veritabanından ürünleri çekme
  Future<void> fetchProducts() async {
    try {
      _allProducts = await _dbHelper.fetchProducts();
      _products = List.from(_allProducts); // Başlangıçta tüm ürünleri göster
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error fetching products: $e';
      notifyListeners();
    }
  }

  // Ürün ekleme
  Future<void> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      _allProducts.add(product); // Yeni ürünü tüm listeye ekle
      _products.add(product); // Filtrelenmiş listeyi de güncelle
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error adding product: $e';
      notifyListeners();
    }
  }

  // Ürün silme
  Future<void> deleteProduct(int id) async {
    try {
      await _dbHelper.deleteProduct(id);
      _allProducts.removeWhere((product) => product.id == id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error deleting product: $e';
      notifyListeners();
    }
  }

  // Ürün güncelleme
  Future<void> editProduct(Product updatedProduct) async {
    try {
      await _dbHelper.updateProduct(updatedProduct);
      int index =
          _allProducts.indexWhere((product) => product.id == updatedProduct.id);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
      }
      int filteredIndex =
          _products.indexWhere((product) => product.id == updatedProduct.id);
      if (filteredIndex != -1) {
        _products[filteredIndex] = updatedProduct;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error updating product: $e';
      notifyListeners();
    }
  }

  // Ürünleri filtreleme (arama algoritması)
  void filterProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts); // Arama boşsa tüm ürünleri göster
    } else {
      _products = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
