class Product {
  final int? id; // Ürün ID'si (otomatik atanabilir)
  final String name; // Ürün adı
  final int quantity; // Ürün adeti
  final double price; // Ürün fiyatı

  Product({this.id, required this.name, required this.quantity, required this.price});

  // SQL Veritabanı için JSON dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
