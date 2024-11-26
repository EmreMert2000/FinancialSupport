import 'package:flutter/material.dart';
import '../ViewModel/invoice_viewmodel.dart'; // ViewModel'i içeren dosya
import '../data/invoice.dart'; // Veri modelini içeren dosya
import 'create_invoice_screen.dart'; // İrsaliye oluşturma ekranı

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late InvoiceViewModel _viewModel;
  String _searchQuery = ''; // Arama sorgusu

  @override
  void initState() {
    super.initState();
    _viewModel = InvoiceViewModel();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    await _viewModel.fetchInvoices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = _viewModel.invoices
        .where((invoice) =>
            invoice.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('İrsaliye Yönetimi'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Müşteri ismini arayın',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: filteredInvoices.isNotEmpty
          ? ListView.builder(
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = filteredInvoices[index];
                return ListTile(
                  title: Text(invoice.title),
                  subtitle: Text(invoice.date),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _viewModel.deleteInvoice(invoice.id!);
                      _fetchInvoices();
                    },
                  ),
                );
              },
            )
          : Center(child: Text('İrsaliye bulunamadı.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateInvoiceScreen()),
          ).then((_) => _fetchInvoices()); // Yeni irsaliye sonrası listeyi güncelle
        },
        child: Icon(Icons.add),
        tooltip: 'Yeni İrsaliye Oluştur',
      ),
    );
  }
}
