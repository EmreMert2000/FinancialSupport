import 'package:finance/Db/db_helper.dart';
import 'package:finance/data/missing_item.dart';

class MissingListViewModel {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<MissingItem> missingItems = [];

  Future<void> loadMissingItems() async {
    missingItems = await _dbHelper.fetchMissingItems();
  }

  Future<void> addMissingItem(String name) async {
    final newItem = MissingItem(name: name);
    await _dbHelper.insertMissingItem(newItem);
    await loadMissingItems();
  }

  Future<void> removeMissingItem(int id) async {
    await _dbHelper.deleteMissingItem(id);
    await loadMissingItems();
  }
}
