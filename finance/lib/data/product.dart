class Product {
  int? id;
  String name;
  int quantity;
  double price;

  Product({this.id, required this.name, required this.quantity, required this.price});

  // Veritabanına eklemek için map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  // Map'ten model oluşturma
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
