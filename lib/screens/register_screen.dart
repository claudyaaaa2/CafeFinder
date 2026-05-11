import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Logika 100% sama dengan RegisterActivity.java kamu
  void _register() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua field")),
      );
    } else {
      if (password == confirmPassword) {
        if (password.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password minimal 6 karakter")),
          );
          return;
        }

        // --- AREA DATABASE DUMMY ---
        bool checkUsername = false; 

        if (!checkUsername) {
          bool insert = true; 

          if (insert) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registrasi Berhasil")),
            );
            Navigator.pop(context); // Kembali ke LoginActivity
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registrasi Gagal")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Username sudah digunakan")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password tidak cocok")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Sesuai android:background
      body: SingleChildScrollView(
        // Pengganti LinearLayout dengan padding 32dp (horizontal), 60dp (top), 30dp (bottom)
        padding: const EdgeInsets.only(left: 32, right: 32, top: 60, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Agar teks rata kiri
          children: [
            const Text(
              "Daftar Akun",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan isi data di bawah ini untuk bergabung dengan CafeFinder",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 40),

            // Username
            buildInputLabel("Username"),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.black),
              decoration: buildInputDecoration("Masukkan username"),
            ),
            const SizedBox(height: 20),

            // Password
            buildInputLabel("Password"),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: buildInputDecoration("Buat password minimal 6 karakter"),
            ),
            const SizedBox(height: 20),

            // Konfirmasi Password
            buildInputLabel("Konfirmasi Password"),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: buildInputDecoration("Ulangi password kamu"),
            ),
            const SizedBox(height: 40),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              height: 60, // Sesuai layout_height="60dp" di XML
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E342E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _register,
                child: const Text(
                  "Buat Akun Sekarang",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Kembali ke Login
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Sama dengan onClick -> finish()
                },
                child: const Text(
                  "Sudah punya akun? Login di sini",
                  style: TextStyle(
                    color: Color(0xFF4E342E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget
  Widget buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF4E342E),
      ),
    );
  }

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F5F5), // Padanan untuk @drawable/bg_input
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}