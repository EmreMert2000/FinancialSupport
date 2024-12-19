class Company {
  final int? id;
  final String name;
  final double debt;
  final double credit;
  final DateTime date;

  Company({
    this.id,
    required this.name,
    required this.debt,
    required this.credit,
    required this.date,
  });

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json['id'],
        name: json['name'],
        debt: json['debt'],
        credit: json['credit'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'debt': debt,
      'credit': credit,
      'date': date.toIso8601String(),
    };
  }
}
