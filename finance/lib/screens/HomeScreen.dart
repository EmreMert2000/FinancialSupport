import 'package:finance/screens/InvoiceScreen.dart';

import 'package:flutter/material.dart';
import 'ProductScreen.dart';
import 'missing_list_screen.dart';
import 'package:finance/screens/CompanyScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoş Geldin, Nizam Yapi!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuButton(context, 'Ürünler', Icons.bar_chart, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                  }),
                  _buildMenuButton(context, 'Eksikler', Icons.folder, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MissingListScreen()),
                    );
                  }),
                  _buildMenuButton(context, 'İrsaliyelerim', Icons.file_copy,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InvoiceCreateScreen()),
                    );
                  }),
                  _buildMenuButton(
                      context, 'Muhasebe Hesabım', Icons.account_balance, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompanyScreen()),
                    );
                  }),
                  _buildMenuButton(
                      context, 'Ayarlar', Icons.account_balance, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
