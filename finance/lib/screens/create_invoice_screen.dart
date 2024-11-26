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

  final InvoiceViewModel _viewModel = InvoiceViewModel();
  final List<Map<String, dynamic>> _products = [];

  void _addProduct() {
    final name = _productNameController.text.trim();
    final quantity = _productQuantityController.text.trim();

    if (name.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _products.add({'name': name, 'quantity': int.parse(quantity)});
      });
      _productNameController.clear();
      _productQuantityController.clear();
    }
  }

  
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
                return pw.Text('${product['name']} - Adet: ${product['quantity']}');
              }).toList(),
            ],
          );
        },
      ),
    );

   
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
                    subtitle: Text('Adet: ${product['quantity']}'),
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
                    await _viewModel.addInvoice(
                      Invoice(
                        title: title,
                        date: date,
                        products: _products,
                      ),
                    );
                    Navigator.pop(context); 
                    await _generatePdf(); 
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
