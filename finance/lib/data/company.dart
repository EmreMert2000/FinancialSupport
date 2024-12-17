class Company {
  final int? id;
  final String name;
  final double debt;
  final double credit;

  Company({
    this.id,
    required this.name,
    required this.debt,
    required this.credit,
  });

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json['id'],
        name: json['name'],
        debt: json['debt'],
        credit: json['credit'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'debt': debt,
      'credit': credit,
    };
  }
}
