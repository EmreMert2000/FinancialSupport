class InvoiceItem {
  int? id;
  int invoiceId;
  String name;
  int quantity;
  double price;

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

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
