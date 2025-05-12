import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/endpoints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laptop Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OtpScreen(),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? generatedOtp;
  bool isTimerRunning = false;
  int timeLeft = 60; // 1 minute in seconds

  @override
  void dispose() {
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      isTimerRunning = true;
      timeLeft = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        }
      });
      if (timeLeft == 0) {
        setState(() {
          isTimerRunning = false;
        });
        return false;
      }
      return true;
    });
  }

  void _generateOtp() async {
    final response = await http.get(
      Uri.parse(apiUrlGenerateOtp),
      headers: {'Content-Type': 'application/json'},
    );
    setState(() {
      if (response.statusCode == 200) {
        generatedOtp = jsonDecode(response.body)['otp'];
      } else {
        generatedOtp = 'Error generating OTP';
      }
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laptop Track'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.security,
                        size: 80,
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(height: 20),
                      if (generatedOtp != null) ...[
                        Text(
                          'Generated OTP:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          generatedOtp!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade600,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      ElevatedButton.icon(
                        onPressed: isTimerRunning ? null : _generateOtp,
                        icon:
                            Icon(isTimerRunning ? Icons.timer : Icons.refresh),
                        label: Text(
                          isTimerRunning ? 'Wait ${timeLeft}s' : 'Generate OTP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBackgroundColor:
                              Colors.green.withOpacity(0.6),
                          disabledForegroundColor: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
