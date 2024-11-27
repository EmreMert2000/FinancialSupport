class InvoiceItem {
  int? id;
  int invoiceId;
  String productName;
  int quantity;
  double price;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  // copyWith metodunu ekliyoruz
  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    String? productName,
    int? quantity,
    double? price,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
