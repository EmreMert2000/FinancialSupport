// company_viewmodel.dart
import 'package:finance/Db/company_db_helper.dart';
import '../data/company.dart';

class CompanyViewModel {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Şirket verilerini çekmek
  Future<List<Company>> fetchCompanies() async {
    return await dbHelper.getCompanies();
  }

  // Yeni şirket eklemek
  Future<void> addCompany(String name,
      {double debt = 0.0, double credit = 0.0, DateTime? date}) async {
    try {
      final currentDate = date ?? DateTime.now();
      if (name.isEmpty) {
        throw ArgumentError("Şirket adı boş olamaz");
      }
      await dbHelper.insertCompany(Company(
        name: name,
        debt: debt,
        credit: credit,
        date: currentDate,
      ));
    } catch (e) {
      print('Error adding company: $e');
    }
  }

  // Şirket güncelleme
  Future<void> updateCompany(Company company,
      {double? debtChange, double? creditChange, DateTime? date}) async {
    try {
      final updatedCompany = Company(
        id: company.id,
        name: company.name,
        debt: debtChange != null ? debtChange : company.debt,
        credit: creditChange != null ? creditChange : company.credit,
        date: date ?? company.date,
      );
      await dbHelper.updateCompany(updatedCompany);
    } catch (e) {
      print('Error updating company: $e');
    }
  }

  // Şirket silme
  Future<void> deleteCompany(int id) async {
    try {
      await dbHelper.deleteCompany(id);
    } catch (e) {
      print('Error deleting company: $e');
    }
  }
}
