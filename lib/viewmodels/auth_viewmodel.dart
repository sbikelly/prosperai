//filepath: lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/database_service.dart';

class AuthViewModel with ChangeNotifier {
  final DatabaseService _dbService;
  User? _currentUser;
  String? _errorMessage;

  AuthViewModel(this._dbService);

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    try {
      
      final user = _dbService.getUser(username);
      if (user != null && user.password == password) {
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid username or password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login error: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> register(String username, String password) async {
    try {
      final user = User(username: username, password: password);
      await _dbService.saveUser(user);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
      rethrow; // Rethrow to handle in UI
    }
  }
}