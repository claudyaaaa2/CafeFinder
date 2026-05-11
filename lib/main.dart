import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Pastikan sudah di-import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CafeFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      // UBAH BAGIAN INI:
      // Pastikan home mengarah ke LoginScreen()
      home: const LoginScreen(), 
    );
  }
}