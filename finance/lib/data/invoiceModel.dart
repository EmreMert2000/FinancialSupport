class Product {
  String name;
  int quantity;
  double price;

  Product({required this.name, required this.quantity, required this.price});

  // SQL tablosundan veri alma
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  // SQL tablosuna veri kaydetme
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
