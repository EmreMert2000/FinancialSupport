import 'package:finance/ViewModel/invoiceViewModel.dart';
import 'package:flutter/material.dart';

import '../data/invoiceModel.dart';

class InvoiceCreateScreen extends StatefulWidget {
  @override
  _InvoiceCreateScreenState createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final InvoiceViewModel _viewModel = InvoiceViewModel();

  final TextEditingController _companyController = TextEditingController();
  final List<InvoiceItem> _items = [];

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(invoiceId: 0, name: '', quantity: 1, price: 0.0));
    });
  }

  Future<void> _createInvoice(BuildContext context) async {
    if (_companyController.text.isEmpty || _items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tüm alanları doldurun.')));
      return;
    }

    final invoice = Invoice(
      companyName: _companyController.text,
      totalPrice:
          _items.fold(0, (sum, item) => sum + (item.quantity * item.price)),
      createdAt: DateTime.now(),
    );

    await _viewModel.createInvoice(invoice, _items);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('İrsaliye oluşturuldu.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İrsaliye Oluştur')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _companyController,
              decoration: InputDecoration(labelText: 'Firma İsmi'),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Ürün Ekle'),
            ),
            ..._items.map((item) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Ürün Adı'),
                      onChanged: (value) => setState(() => item.name = value),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Adet'),
                      onChanged: (value) => setState(
                          () => item.quantity = int.tryParse(value) ?? 1),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Fiyat'),
                      onChanged: (value) => setState(
                          () => item.price = double.tryParse(value) ?? 0.0),
                    ),
                  ),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: () => _createInvoice(context),
              child: Text('İrsaliye Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}
