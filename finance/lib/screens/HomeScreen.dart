import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatelessWidget {
  final String username; // Kullanıcı adını alacak

  HomeScreen({required this.username});

  Future<void> _logout(BuildContext context) async {
    // Oturum bilgisini temizle
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Giriş ekranına yönlendir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

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
              'Hoş Geldin, $username!',
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
                    // Ürünler ekranına yönlendirme
                  }),
                  _buildMenuButton(context, 'Eksikler', Icons.folder, () {
                    // Eksikler ekranına yönlendirme
                  }),
                  _buildMenuButton(context, 'İrsaliyelerim', Icons.file_copy,
                      () {
                    // İrsaliyelerim ekranına yönlendirme
                  }),
                  _buildMenuButton(
                      context, 'Muhasebe Hesabım', Icons.account_balance, () {
                    // Muhasebe Hesabım ekranına yönlendirme
                  }),
                  _buildMenuButton(context, 'Ayarlar', Icons.settings, () {
                    // Ayarlar ekranına yönlendirme
                  }),
                  _buildMenuButton(context, 'Çıkış Yap', Icons.logout, () {
                    _logout(context);
                  }),
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
