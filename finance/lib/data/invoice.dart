class Invoice {
  int? id;
  String title;
  String date;
  List<InvoiceItem> items;

  Invoice({
    this.id,
    required this.title,
    required this.date,
    required this.items,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      items: (map['items'] as List).map((e) => InvoiceItem.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class InvoiceItem {
  int? id;
  int invoiceId;
  String description;
  int quantity;
  double price;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.price,
  });

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      description: map['description'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }
}
