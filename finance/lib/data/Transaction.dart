class MyTransaction {
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  MyTransaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });
}

enum TransactionType {
  income,
  expense,
}
