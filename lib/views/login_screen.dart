//filepath: lib/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:prosperai/utils/constants.dart';

import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final AuthViewModel authViewModel;

  const LoginScreen({super.key, required this.authViewModel});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for login form
  final _registerFormKey = GlobalKey<FormState>(); // Key for registration form
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ProsperAI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
          child: _buildLoginPanel(),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Placeholder for forgot password logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forgot password feature coming soon!')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
          ),
          child: const Text(
            "I forgot my password",
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPanel() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            color: AppConstants.secondaryColor,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey, // Assign form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    // Uncomment and add asset if available
                    // backgroundImage: AssetImage('assets/app-logo.png'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please enter your credentials below to Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Enter your Email/Username",
                      hintText: 'e.g., someone@something.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Email/Username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          // Add "Remember me" logic if needed
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  _buildSignInButton(),
                  const SizedBox(height: 20),
                  _buildRegisterLink(),
                  const SizedBox(height: 10),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _register,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: _login,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authViewModel.login(_usernameController.text, _passwordController.text);
      if (success) {
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        setState(() => _errorMessage = widget.authViewModel.errorMessage);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  void _register() {
    final registerUsernameController = TextEditingController();
    final registerPasswordController = TextEditingController();
    final registerConfirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register'),
        content: Form(
          key: _registerFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Please enter your details to register',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: registerUsernameController,
                  decoration: const InputDecoration(
                    labelText: "Enter your Email/Username",
                    hintText: 'e.g., someone@something.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Email/Username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: registerPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: registerConfirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != registerPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_registerFormKey.currentState!.validate()) {
                try {
                  await widget.authViewModel.register(
                    registerUsernameController.text,
                    registerPasswordController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User registered successfully! Please log in.')),
                  );
                  // Clear login fields after successful registration
                  _usernameController.clear();
                  _passwordController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(widget.authViewModel.errorMessage ?? 'Error registering new user')),
                  );
                  setState(() => _errorMessage = widget.authViewModel.errorMessage);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all required fields correctly')),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}