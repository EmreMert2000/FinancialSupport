import 'package:flutter/material.dart';
import 'package:finance/ViewModel/product_viewmodel.dart';
import 'package:finance/data/product.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ürünler'),
        ),
        body: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Ürün Adı')),
                          DataColumn(label: Text('Adet')),
                          DataColumn(label: Text('Fiyat')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: viewModel.products.map((product) {
                          return DataRow(cells: [
                            DataCell(Text(product.id.toString())),
                            DataCell(Text(product.name)),
                            DataCell(Text(product.quantity.toString())),
                            DataCell(Text('${product.price.toStringAsFixed(2)} ₺')),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => viewModel.deleteProduct(product.id!),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => _showAddProductDialog(context),
                    child: Text('Ürün Ekle'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _quantityController = TextEditingController();
    final _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Ürün Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Ürün Adı'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Adet'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Fiyat'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
              final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

              if (name.isNotEmpty && quantity > 0 && price > 0) {
                Provider.of<ProductViewModel>(context, listen: false).addProduct(
                  Product(name: name, quantity: quantity, price: price),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
