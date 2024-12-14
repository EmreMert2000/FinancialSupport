import 'package:finance/data/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:finance/ViewModel/transaction_view_model.dart'; // ViewModel'e bağlantı

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionViewModel _viewModel = TransactionViewModel();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Veritabanından işlemleri yükle
  Future<void> _loadTransactions() async {
    await _viewModel.addTransaction('Salary', 3000.0, TransactionType.income);
    await _viewModel.addTransaction(
        'Groceries', 200.0, TransactionType.expense);
    setState(() {});
  }

  // İşlem eklemek için
  void _addTransaction() {
    _viewModel.addTransaction('New Transaction', 100.0, TransactionType.income);
    setState(() {});
  }

  // İşlem silmek için
  void _deleteTransaction(int index) {
    _viewModel.deleteTransaction(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: _viewModel.transactions.length,
        itemBuilder: (context, index) {
          final transaction = _viewModel.transactions[index];
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text('\$${transaction.amount.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTransaction(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        child: Icon(Icons.add),
      ),
    );
  }
}
