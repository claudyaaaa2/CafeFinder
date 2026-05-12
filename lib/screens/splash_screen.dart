import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan import ke LoginScreen sudah benar

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFF4E342E), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            const Icon(
              Icons.coffee_maker_rounded,
              size: 90,
              color: Color(0xFFFFF8F0),
            ),
            const SizedBox(height: 16),

          
            const Text(
              "CafeFinder",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF8F0),
                letterSpacing: 1.5,
              ),
            ),
            
            const SizedBox(height: 8),

            
            const Text(
              "Temukan Tempat Nugas Ternyaman di Palu",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFD7CCC8),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 40),

            
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFFFFF8F0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}