import 'package:flutter/material.dart';
import 'package:finance/ViewModel/invoiceViewModel.dart';
import 'package:finance/data/invoiceModel.dart';

class InvoiceCreateScreen extends StatefulWidget {
  @override
  _InvoiceCreateScreenState createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final InvoiceViewModel _viewModel = InvoiceViewModel();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Creator')),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    final product = Product(
                      name: _nameController.text,
                      quantity: int.parse(_quantityController.text),
                      price: double.parse(_priceController.text),
                    );
                    _viewModel.addProduct(product);
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _viewModel,
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: _viewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = _viewModel.products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Quantity: ${product.quantity}, Price: ${product.price}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _viewModel.deleteProduct(product.id!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
