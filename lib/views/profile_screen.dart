//filepath: lib/views/profile_screen.dart

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  final AuthViewModel authViewModel;

  const ProfileScreen({super.key, required this.authViewModel});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      enabled: _isEditing,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isEditing ? _saveProfile : _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_isEditing ? 'Save' : 'Edit Profile'),
                ),
                if (_isEditing)
                  TextButton(
                    onPressed: _toggleEdit,
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.authViewModel.currentUser!.username;
    _passwordController.text = widget.authViewModel.currentUser!.password;
  }

  void _saveProfile() async {
    try {
      await widget.authViewModel.register(_usernameController.text, _passwordController.text);
      _toggleEdit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(widget.authViewModel.errorMessage ?? 'Failed to update profile')),
      // );
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }
}