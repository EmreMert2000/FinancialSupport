class Invoice {
  int? id;
  String title;
  String date;
  List<Map<String, dynamic>>? products; // Ürün listesi

  Invoice({
    this.id,
    required this.title,
    required this.date,
    this.products,
  });

  // Firestore ile uyumlu hale getirmek için fromMap ve toMap metodları ekleyin.
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'products': products,
    };
  }
}
