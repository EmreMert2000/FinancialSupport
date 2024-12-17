import 'package:finance/Db/company_db_helper.dart';

import '../data/company.dart';

class CompanyViewModel {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Company>> fetchCompanies() {
    return dbHelper.getCompanies();
  }

  // addCompany metoduna debt ve credit parametrelerini ekledim
  Future<void> addCompany(String name,
      {double debt = 0.0, double credit = 0.0}) async {
    await dbHelper
        .insertCompany(Company(name: name, debt: debt, credit: credit));
  }

  Future<void> updateCompany(Company company,
      {double? debtChange, double? creditChange}) async {
    final updatedCompany = Company(
      id: company.id,
      name: company.name,
      debt: company.debt + (debtChange ?? 0),
      credit: company.credit + (creditChange ?? 0),
    );
    await dbHelper.updateCompany(updatedCompany);
  }

  Future<void> deleteCompany(int id) async {
    await dbHelper.deleteCompany(id);
  }
}
