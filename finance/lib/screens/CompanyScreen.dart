import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ViewModel/company_viewmodel.dart';
import '../data/company.dart';

class CompanyScreen extends StatefulWidget {
  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyViewModel viewModel = CompanyViewModel();
  List<Company> companies = [];
  List<Company> filteredCompanies = [];

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _debtController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

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
      // Pass the selected date to the addCompany method
      await viewModel.addCompany(name,
          debt: debt, credit: credit, date: _selectedDate);
      _loadCompanies();
      _clearFields();
    }
  }

  void _clearFields() {
    _companyNameController.clear();
    _debtController.clear();
    _creditController.clear();
    _dateController.clear();
  }

  void _deleteCompany(int id) async {
    await viewModel.deleteCompany(id);
    _loadCompanies();
  }

  // Date Picker method
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${_selectedDate.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firma Borç/Alacak Fatura Takibi')),
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
                  decoration: InputDecoration(labelText: 'Müşteri'),
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
                // Date Picker field
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Tarih',
                    hintText: 'Tarih Seçin',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true, // Make the TextField read-only
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addCompany,
                  child: Text('Müşteri Ekle'),
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
                      "Borç: ${company.debt.toStringAsFixed(2)} TL\n"
                      "Alacak: ${company.credit.toStringAsFixed(2)} TL\n"
                      "Tarih: ${company.date != null ? DateFormat('dd/MM/yyyy').format(company.date!) : 'Seçilmedi'}",
                    ),
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
