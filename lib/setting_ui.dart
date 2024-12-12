import 'package:flutter/material.dart';
import 'package:flutter_shop/dashboard.dart';
import 'main.dart';  // Import isDarkMode from main.dart

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),  // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => DashboardPage()));  // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Aktifkan tema gelap'),
            value: MyApp.isDarkMode.value, // Use MyApp.isDarkMode to access the value
            onChanged: (value) {
              setState(() {
                MyApp.isDarkMode.value = value; // Update the dark mode status
              });
            },
          ),
        ],
      ),
    );
  }
}
