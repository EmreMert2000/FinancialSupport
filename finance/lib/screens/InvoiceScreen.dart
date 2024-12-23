import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceCreateScreen extends StatefulWidget {
  @override
  _InvoiceCreateScreenState createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _invoices = [];
  List<Map<String, dynamic>> _filteredInvoices = [];
  bool _isProductSectionVisible = false;
  Database? _db;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _searchController.addListener(_filterInvoices);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInvoices);
    super.dispose();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'invoices.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE invoices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            company TEXT NOT NULL,
            totalPrice REAL NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invoiceId INTEGER NOT NULL,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY(invoiceId) REFERENCES invoices(id)
          )
        ''');
      },
    );

    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final result = await _db!.query('invoices');
    setState(() {
      _invoices = result;
      _filteredInvoices = result;
    });
  }

  void _filterInvoices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInvoices = _invoices.where((invoice) {
        final company = invoice['company'].toLowerCase();
        return company.contains(query);
      }).toList();
    });
  }

  void _addItem() {
    setState(() {
      _items.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _createInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    final totalPrice = _items.fold(0.0, (sum, item) {
      final quantity = int.tryParse(item['quantity'].text) ?? 0;
      final price = double.tryParse(item['price'].text) ?? 0.0;
      return sum + (quantity * price);
    });

    final invoiceId = await _db!.insert('invoices', {
      'company': _companyController.text,
      'totalPrice': totalPrice,
      'createdAt': DateTime.now().toIso8601String(),
    });

    for (var item in _items) {
      await _db!.insert('items', {
        'invoiceId': invoiceId,
        'name': item['name'].text,
        'quantity': int.tryParse(item['quantity'].text) ?? 0,
        'price': double.tryParse(item['price'].text) ?? 0.0,
      });
    }

    _formKey.currentState!.reset();
    setState(() {
      _items.clear();
      _isProductSectionVisible = false;
    });
    _loadInvoices();
  }

  Future<void> _deleteInvoice(int id) async {
    await _db!.delete('items', where: 'invoiceId = ?', whereArgs: [id]);
    await _db!.delete('invoices', where: 'id = ?', whereArgs: [id]);
    _loadInvoices();
  }

  Future<void> _generatePdf(Map<String, dynamic> invoice) async {
    final pdf = pw.Document();

    final items = await _db!.query(
      'items',
      where: 'invoiceId = ?',
      whereArgs: [invoice['id']],
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nizam Yapi Malzemeleri',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Malzeme alan Firma: ${invoice['company']}',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 20),

              // Ürün Tablosu
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColor.fromInt(0xffe0e0e0)),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Ürün Adi',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Adet',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Birim Fiyat',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Toplam Fiyat',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...items.map<pw.TableRow>((item) {
                    final totalPrice =
                        (item['quantity'] as int) * (item['price'] as double);
                    return pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(item['name'] as String),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(item['quantity'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('${item['price']} TL'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('${totalPrice.toStringAsFixed(2)} TL'),
                      ),
                    ]);
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),
              // Toplam Fiyat ve KDV Bilgisi
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Genel Toplam: ${invoice['totalPrice']} TL',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  '(KDV Dahildir)',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColor.fromInt(0xff7b7b7b),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İrsaliye Oluştur')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: 'Firma İsmi',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen firma ismi girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isProductSectionVisible = true;
                        _addItem();
                      });
                    },
                    child: Text('Ürün Ekle'),
                  ),
                  if (_isProductSectionVisible)
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _items[index]['name'],
                                    decoration: InputDecoration(
                                      labelText: 'Ürün Adı',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Lütfen ürün adını girin';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _items[index]['quantity'],
                                    decoration: InputDecoration(
                                      labelText: 'Adet',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Lütfen adet girin';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _items[index]['price'],
                                    decoration: InputDecoration(
                                      labelText: 'Fiyat',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Lütfen fiyat girin';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _createInvoice,
                          child: Text('İrsaliye Oluştur'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Divider(height: 32),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Firma İsmi Ara',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = _filteredInvoices[index];
                return Card(
                  child: ListTile(
                    title: Text(invoice['company']),
                    subtitle: Text('Toplam: ${invoice['totalPrice']} TL'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.picture_as_pdf),
                          onPressed: () => _generatePdf(invoice),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteInvoice(invoice['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
