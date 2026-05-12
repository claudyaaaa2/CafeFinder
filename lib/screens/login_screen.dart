import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'main_screen.dart'; // <--- Pastikan file ini ada di folder yang sama

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Gambar Header (Pastikan nama file dan folder assets benar)
          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cafe_header.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Form Login (Kartu Putih)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    const Text(
                      "CafeFinder",
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF4E342E)
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Temukan tempat nugas ternyaman di Palu",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF8D6E63)),
                    ),
                    const SizedBox(height: 40),

                    // Field Username
                    _buildLabel("Username"),
                    const SizedBox(height: 10),
                    _buildTextField(
                      hint: "Masukkan username kamu", 
                      icon: Icons.person_outline, 
                      controller: _usernameController
                    ),
                    
                    const SizedBox(height: 25),

                    // Field Password
                    _buildLabel("Password"),
                    const SizedBox(height: 10),
                    _buildTextField(
                      hint: "Masukkan password", 
                      icon: Icons.lock_outline, 
                      isPassword: true
                    ),
                    
                    const SizedBox(height: 40),

                    // TOMBOL MASUK SEKARANG
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4E342E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {

                        String namaUser = _usernameController.text;

                        // 2. Kirim nama tersebut ke MainScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            // HAPUS 'const' karena datanya sekarang dinamis dari inputan
                            builder: (context) => MainScreen(username: namaUser), 
                          ),
                        );
                      },
                        child: const Text(
                          "Masuk Sekarang",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Link ke Daftar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen()
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar di sini",
                            style: TextStyle(
                              color: Color(0xFF4E342E), 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 16, 
          color: Color(0xFF4E342E)
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    required IconData icon, 
    bool isPassword = false, 
    TextEditingController? controller 
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF4E342E), width: 2),
        ),
      ),
    );
  }
}