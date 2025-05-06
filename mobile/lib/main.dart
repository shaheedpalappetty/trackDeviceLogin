import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final String apiUrl = 'http://10.0.2.2:8080/auth/login';

  LoginScreen({super.key});

  Future<void> login(BuildContext context) async {
    if (username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final body = jsonEncode({
        'username': "admin",
        'password': "admin",
        'device_id': '1234567890',
        'is_logged_in': true,
      });
      debugPrint(body);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(username: username.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (s, e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection error. Please check your internet.'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Error: $e');
      debugPrint('Stacktrace: $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.laptop_mac,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Laptop Track',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String apiUrl = 'http://localhost:8080/logout';
  final String username;

  const HomePage({super.key, required this.username});

  Future<void> logout(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'device_id': 'MOBILE_001',
          'is_logged_in': false,
        }),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection error. Please check your internet.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laptop Track'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, $username!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => logout(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
