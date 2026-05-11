import 'package:flutter/material.dart';
import 'register_screen.dart'; // 1. PASTIKAN SUDAH ADA IMPORT INI
import 'main_screen.dart';    

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.length >= 6) {
      // Navigasi ke MainScreen (Home)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(username: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username/Password salah atau kurang dari 6 karakter")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header (Gambar)
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cafe_header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Bagian Form Input
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Text("Selamat Datang!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4E342E))),
                  const SizedBox(height: 30),
                  
                  // EditText Username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // EditText Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Button Login
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4E342E)),
                      onPressed: _login,
                      child: const Text("Masuk", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // --- INI BAGIAN YANG KAMU TANYAKAN ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun? "),
                      GestureDetector(
                        onTap: () {
                          // Pindah ke RegisterScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "Daftar di sini",
                          style: TextStyle(
                            color: Color(0xFF4E342E),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}