import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Logika Register dengan Early Return (Lebih rapi dan bebas error VS Code)
  Future<void> _register() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harap isi semua field")));
      return; // Langsung stop/keluar dari fungsi
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Format email tidak valid")));
      return;
    }

   
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return; 
    }


    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak cocok")));
      return; // Langsung stop
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (!mounted) return;

      final message = response.session == null
          ? 'Registrasi berhasil. Cek email untuk verifikasi akun.'
          : 'Registrasi berhasil.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } on AuthException catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registrasi gagal: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Sesuai android:background
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.only(
          left: 32,
          right: 32,
          top: 60,
          bottom: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
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
              style: TextStyle(fontSize: 14, color: Color(0xFF8D6E63)),
            ),
            const SizedBox(height: 40),

            // Email
            buildInputLabel("Email"),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: buildInputDecoration("Masukkan email"),
            ),
            const SizedBox(height: 20),

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
              decoration: buildInputDecoration(
                "Buat password minimal 6 karakter",
              ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _register,
                child: const Text(
                  "Buat Akun Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
