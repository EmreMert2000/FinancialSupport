import 'package:finance/data/Transaction.dart'; // MyTransaction'ı import ettik
import 'package:finance/Db/transactionDb.dart';

class TransactionViewModel {
  List<MyTransaction> _transactions =
      []; // 'Transaction' yerine 'MyTransaction' kullanıyoruz

  List<MyTransaction> get transactions => _transactions;

  // Veri tabanına işlem eklemek için fonksiyon
  Future<void> addTransaction(
      String title, double amount, TransactionType type) async {
    final newTransaction = MyTransaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
    );

    // DBHelper sınıfını kullanarak veritabanına işlemi ekle
    await DBHelper.instance.insertTransaction(newTransaction);
    _transactions = await DBHelper.instance.getTransactions();
  }

  // Veritabanından işlem silmek için fonksiyon
  Future<void> deleteTransaction(int id) async {
    await DBHelper.instance.deleteTransaction(id);
    _transactions = await DBHelper.instance.getTransactions();
  }

  // Gelir toplamını hesaplamak
  double totalIncome() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Gider toplamını hesaplamak
  double totalExpense() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Net bakiyeyi hesaplamak
  double netBalance() {
    return totalIncome() - totalExpense();
  }
}
