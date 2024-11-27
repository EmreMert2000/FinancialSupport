import 'package:flutter/material.dart';
import 'package:finance/ViewModel/invoice_viewmodel.dart';
import 'package:finance/data/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreateInvoiceScreen extends StatefulWidget {
  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productQuantityController = TextEditingController();
  final _productPriceController = TextEditingController(); // Fiyat için controller

  final InvoiceViewModel _viewModel = InvoiceViewModel();
  final List<Map<String, dynamic>> _products = [];

  // Add a product to the list
  void _addProduct() {
    final name = _productNameController.text.trim();
    final quantity = _productQuantityController.text.trim();
    final price = _productPriceController.text.trim();

    if (name.isNotEmpty && quantity.isNotEmpty && price.isNotEmpty) {
      setState(() {
        _products.add({
          'name': name,
          'quantity': int.parse(quantity),
          'price': double.parse(price) // Fiyat bilgisini ekledik
        });
      });
      _productNameController.clear();
      _productQuantityController.clear();
      _productPriceController.clear(); // Fiyat controller'ını da temizliyoruz
    }
  }

  // Generate PDF document
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('İrsaliye Başlığı: ${_titleController.text}', style: pw.TextStyle(fontSize: 20)),
              pw.Text('Tarih: ${_dateController.text}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Ürünler:', style: pw.TextStyle(fontSize: 18)),
              ..._products.map((product) {
                return pw.Text('${product['name']} - Adet: ${product['quantity']} - Fiyat: ${product['price']}₺');
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni İrsaliye Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Müşteri Adı'),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tarih (YYYY-MM-DD)'),
              ),
              SizedBox(height: 20),
              Text('Ürünler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _productNameController,
                      decoration: InputDecoration(labelText: 'Ürün Adı'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _productQuantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Adet'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _productPriceController, // Fiyat alanı
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Fiyat'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: _addProduct,
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Adet: ${product['quantity']} - Fiyat: ${product['price']}₺'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _products.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final date = _dateController.text.trim();

                  if (title.isNotEmpty && date.isNotEmpty) {
                    try {
                      // Create invoice object with products
                      final invoice = Invoice(
                        title: title,
                        date: date,
                        items: _products.map((p) => InvoiceItem(
                          invoiceId: p['id'], // Bu alanı da eklemeyi unutmayın
                          description: p['name'], // Ürün adını description olarak kullanabiliriz
                          quantity: p['quantity'],
                          price: p['price'], // Fiyat bilgisini burada ekliyoruz
                        )).toList(),
                      );

                      // Add invoice using the ViewModel
                      await _viewModel.addInvoice(invoice);

                      // Generate PDF document
                      await _generatePdf();

                      // Navigate back to the previous screen
                      Navigator.pop(context);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('İrsaliye başarıyla oluşturuldu!')),
                      );
                    } catch (e) {
                      // Handle errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hata: ${e.toString()}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                    );
                  }
                },
                child: Text('İrsaliye Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
