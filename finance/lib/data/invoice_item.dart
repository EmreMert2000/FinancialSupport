class InvoiceItem {
  final int? id;
  final int invoiceId;
  final String description;
  final int quantity;
  final double price;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      description: map['description'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
