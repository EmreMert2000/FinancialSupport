class Invoice {
  final int? id;
  final String companyName;
  final double totalPrice;
  final DateTime createdAt;

  Invoice(
      {this.id,
      required this.companyName,
      required this.totalPrice,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      companyName: map['companyName'],
      totalPrice: map['totalPrice'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class InvoiceItem {
  final int? id;
  final int invoiceId;
  late final String name;
  late final int quantity;
  late final double price;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  static InvoiceItem fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
