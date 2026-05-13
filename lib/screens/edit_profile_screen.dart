import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabaseService = SupabaseService();
  bool _isLoading = false;

  Future<void> _handleUpdate() async {
    // Ambil data user yang sedang login
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sesi berakhir, silakan login ulang")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Update Username (Tabel Profiles)
      if (_usernameController.text.isNotEmpty) {
        await _supabaseService.updateProfile(user.id, _usernameController.text);
      }

      // 2. Update Password (Auth Supabase)
      if (_passwordController.text.isNotEmpty) {
        if (_passwordController.text.length < 6) {
          throw "Password minimal harus 6 karakter";
        }
        await _supabaseService.updateUserPassword(_passwordController.text);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal update: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Warna krem khas CafeFinder
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4E342E), // Cokelat gelap
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Icon(Icons.person_pin, size: 80, color: Color(0xFF4E342E)),
            const SizedBox(height: 30),
            
            // Input Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username Baru",
                prefixIcon: const Icon(Icons.edit, color: Color(0xFF4E342E)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Input Password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password Baru",
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4E342E)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
                helperText: "Kosongkan jika tidak ingin mengubah password",
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 55,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF4E342E)))
                  : ElevatedButton(
                      onPressed: _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E342E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}