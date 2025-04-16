//filepath: lib/views/user_management_screen.dart

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/database_service.dart';

class UserManagementScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const UserManagementScreen({super.key, required this.databaseService});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late List<User> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.username),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _editUser(user)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteUser(user.username)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _deleteUser(String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await widget.databaseService.deleteUser(username);
                _refreshUsers();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting user: ${e.toString().replaceAll('DatabaseException: ', '')}')),
                );
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
        ],
      ),
    );
  }

  void _editUser(User user) {
    String newUsername = user.username;
    String newPassword = user.password;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => newUsername = value,
              controller: TextEditingController(text: user.username),
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              onChanged: (value) => newPassword = value,
              controller: TextEditingController(text: user.password),
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await widget.databaseService.saveUser(User(username: newUsername, password: newPassword));
                _refreshUsers();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving user: ${e.toString().replaceAll('DatabaseException: ', '')}')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _refreshUsers() {
    try {
      users = widget.databaseService.getAllUsers();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: ${e.toString().replaceAll('DatabaseException: ', '')}')),
      );
    }
  }
}