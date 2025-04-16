//filepath: lib/views/settings_screen.dart

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
            child: ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: _darkMode,
                onChanged: _toggleTheme,
                activeColor: AppConstants.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Data Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
            child: ListTile(
              title: const Text('Clear All Data'),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: _clearData,
            ),
          ),
        ],
      ),
    );
  }

  void _clearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all chats and settings. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              // Logic to clear data could be added here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared')),
              );
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _toggleTheme(bool value) {
    setState(() => _darkMode = value);
    // Add theme-switching logic here if desired (e.g., using Provider)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dark mode ${_darkMode ? 'enabled' : 'disabled'}')),
    );
  }
} 