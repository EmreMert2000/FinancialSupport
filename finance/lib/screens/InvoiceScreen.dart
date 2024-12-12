import 'package:finance/ViewModel/invoiceViewModel.dart';
import 'package:flutter/material.dart';

import '../data/InvoiceFile.dart';

class InvoiceListScreen extends StatelessWidget {
  final InvoiceViewModel _viewModel = InvoiceViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İrsaliye Listesi')),
      body: FutureBuilder<List<Invoice>>(
        future: _viewModel.getInvoices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('İrsaliye bulunamadı.'));
          }
          final invoices = snapshot.data!;
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return ListTile(
                title: Text(invoice.companyName),
                subtitle: Text('Toplam: ${invoice.totalPrice} TL'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _viewModel.deleteInvoice(invoice.id!);
                    (context as Element).reassemble();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InvoiceListScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
