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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: viewModel.filterProducts, // Arama işlemi
                    decoration: InputDecoration(
                      labelText: 'Ürün Ara',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                          DataCell(Text(product.id?.toString() ?? 'N/A')),
                          DataCell(Text(product.name)),
                          DataCell(Text(product.quantity.toString())),
                          DataCell(
                              Text('${product.price.toStringAsFixed(2)} ₺')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.red),
                                  onPressed: () {
                                    _showEditProductDialog(
                                        context, product, viewModel);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      viewModel.deleteProduct(product.id!),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
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

  // _showAddProductDialog ve _showEditProductDialog fonksiyonları aynı kalıyor
}

void _showAddProductDialog(BuildContext context) {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      final viewModel = Provider.of<ProductViewModel>(context, listen: false);

      return AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final quantity =
                  int.tryParse(_quantityController.text.trim()) ?? 0;
              final price =
                  double.tryParse(_priceController.text.trim()) ?? 0.0;

              if (name.isNotEmpty && quantity > 0 && price > 0) {
                viewModel.addProduct(
                  Product(name: name, quantity: quantity, price: price),
                );
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Lütfen geçerli değerler girin')),
                );
              }
            },
            child: Text('Ekle'),
          ),
        ],
      );
    },
  );
}

void _showEditProductDialog(
    BuildContext context, Product product, ProductViewModel viewModel) {
  final _nameController = TextEditingController(text: product.name);
  final _quantityController =
      TextEditingController(text: product.quantity.toString());
  final _priceController =
      TextEditingController(text: product.price.toString());

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Ürünü Düzenle'),
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final quantity =
                  int.tryParse(_quantityController.text.trim()) ?? 0;
              final price =
                  double.tryParse(_priceController.text.trim()) ?? 0.0;

              if (name.isNotEmpty && quantity > 0 && price > 0) {
                final updatedProduct = Product(
                  id: product.id,
                  name: name,
                  quantity: quantity,
                  price: price,
                );
                viewModel.editProduct(updatedProduct);
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Lütfen geçerli değerler girin')),
                );
              }
            },
            child: Text('Güncelle'),
          ),
        ],
      );
    },
  );
}
