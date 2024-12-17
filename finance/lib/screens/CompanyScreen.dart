import 'package:flutter/material.dart';
import '../ViewModel/company_viewmodel.dart';
import '../data/company.dart';

class CompanyScreen extends StatefulWidget {
  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyViewModel viewModel = CompanyViewModel();
  List<Company> companies = [];
  List<Company> filteredCompanies = []; // Filtrelenmiş şirketler

  // TextEditingController tanımlamaları
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _debtController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompanies();
    _searchController.addListener(_searchCompanies);
  }

  void _loadCompanies() async {
    final result = await viewModel.fetchCompanies();
    setState(() {
      companies = result;
      filteredCompanies = companies;
    });
  }

  void _searchCompanies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCompanies = companies.where((company) {
        return company.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addCompany() async {
    final name = _companyNameController.text;
    final debt = double.tryParse(_debtController.text) ?? 0.0;
    final credit = double.tryParse(_creditController.text) ?? 0.0;

    if (name.isNotEmpty) {
      await viewModel.addCompany(name, debt: debt, credit: credit);
      _loadCompanies();
      _clearFields();
    }
  }

  void _clearFields() {
    _companyNameController.clear();
    _debtController.clear();
    _creditController.clear();
  }

  void _deleteCompany(int id) async {
    await viewModel.deleteCompany(id);
    _loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firma Borç/Alacak Takibi')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Şirket Ekleme Alanı
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'Şirket Adı'),
                ),
                TextField(
                  controller: _debtController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Borç Miktarı (TL)'),
                ),
                TextField(
                  controller: _creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Alacak Miktarı (TL)'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addCompany,
                  child: Text('Şirket Ekle'),
                ),
              ],
            ),
          ),
          Divider(),
          // Arama Çubuğu ve Kayıtlı Şirketler Başlığı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kayıtlı Şirketler',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Şirket ara...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Şirket Listesi
          Expanded(
            child: ListView.builder(
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) {
                final company = filteredCompanies[index];
                return Card(
                  child: ListTile(
                    title: Text(company.name),
                    subtitle: Text(
                        "Borç: ${company.debt} TL\nAlacak: ${company.credit} TL"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCompany(company.id!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
