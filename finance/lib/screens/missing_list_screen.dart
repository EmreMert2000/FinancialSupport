import 'package:flutter/material.dart';
import 'package:finance/ViewModel/missing_list_view_model.dart';

class MissingListScreen extends StatefulWidget {
  @override
  _MissingListScreenState createState() => _MissingListScreenState();
}

class _MissingListScreenState extends State<MissingListScreen> {
  final MissingListViewModel _viewModel = MissingListViewModel();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadMissingItems();
    setState(() {});
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Eksik Ekle'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Eksik adı girin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await _viewModel.addMissingItem(name);
                  setState(() {});
                }
                Navigator.of(context).pop();
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eksikler Listesi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _viewModel.missingItems.length,
              itemBuilder: (context, index) {
                final item = _viewModel.missingItems[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _viewModel.removeMissingItem(item.id!);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddDialog,
              child: Text('Eksik Ekle'),
            ),
          ),
        ],
      ),
    );
  }
}