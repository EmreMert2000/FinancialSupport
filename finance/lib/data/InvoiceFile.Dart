class Invoice {
  int? id;
  String companyName;
  double totalPrice;
  DateTime createdAt;

  Invoice({
    this.id,
    required this.companyName,
    required this.totalPrice,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      companyName: map['companyName'],
      totalPrice: map['totalPrice'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}