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
    // Beri jeda 3 detik lalu pindah ke Login
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
      // Pakai warna cokelat tema CafeFinder
      backgroundColor: const Color(0xFF4E342E), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. ICON/LOGO (Pakai icon bawaan dulu biar aman)
            const Icon(
              Icons.coffee_maker_rounded,
              size: 90,
              color: Color(0xFFFFF8F0),
            ),
            const SizedBox(height: 16),

            // 2. NAMA APLIKASI
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

            // 3. TAGLINE KECIL
            const Text(
              "Temukan Tempat Nugas Ternyaman di Palu",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFD7CCC8),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 40),

            // 4. LOADING INDICATOR (Biar user tahu aplikasi lagi kerja)
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