class MissingItem {
  final int? id; // id opsiyonel, çünkü veritabanı otomatik olarak atar
  final String name;

  MissingItem({
    this.id, // id opsiyonel
    required this.name,
  });

  // Map'ten MissingItem nesnesi oluşturma
  factory MissingItem.fromMap(Map<String, dynamic> map) {
    return MissingItem(
      id: map['id'], // id, veritabanından gelir
      name: map['name'], // name, veritabanından gelir
    );
  }

  // MissingItem nesnesini Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id veritabanı tarafından otomatik atanır
      'name': name,
    };
  }
}
