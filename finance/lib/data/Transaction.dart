class Transaction {
  final int id;
  final String companyName;
  final double debt;
  final double credit;
  final String date;

  Transaction({
    required this.id,
    required this.companyName,
    required this.debt,
    required this.credit,
    required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      companyName: map['companyName'],
      debt: map['debt'],
      credit: map['credit'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'debt': debt,
      'credit': credit,
      'date': date,
    };
  }
}
