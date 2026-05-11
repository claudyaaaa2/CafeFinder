import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import agar fungsi Logout bisa kembali ke Login
// import 'edit_profile_screen.dart'; // Ini akan kita aktifkan nanti setelah filenya dibuat

class ProfileScreen extends StatelessWidget {
  final String username;

  // Constructor untuk menangkap data username dari MainScreen
  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Column(
        children: [
          // 1. HEADER (Sesuai header_container di XML)
          Container(
            width: double.infinity,
            height: 210,
            decoration: const BoxDecoration(
              color: Color(0xFF4E342E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // 2. FOTO PROFIL BUNDAR (Sesuai ShapeableImageView)
                Container(
                  width: 84, // Ukuran luar
                  height: 84,
                  padding: const EdgeInsets.all(2), // Padanan dari android:padding="2dp"
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2), // Garis pinggir putih
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    // Karena ic_profile mungkin belum ada, kita pakai Icon bawaan dulu
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 3. NAMA USER (Sesuai tv_profile_name)
                Text(
                  username, // Menampilkan nama dari variabel
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 4. KONTEN BAWAH (Sesuai ScrollView)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pengaturan Akun",
                    style: TextStyle(
                      color: Color(0xFF4E342E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 5. KARTU UBAH PASSWORD (Sesuai MaterialCardView)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: InkWell( // InkWell agar kartunya punya efek ripple saat diklik
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Buka halaman EditProfileScreen
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: username)));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Color(0xFF4E342E)),
                            SizedBox(width: 16), // Jarak antara icon dan teks
                            Text(
                              "Ubah Password", // Padanan dari @string/ubah_password
                              style: TextStyle(color: Color(0xFF4E342E)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6. TOMBOL LOGOUT (Sesuai btn_logout)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C), // Merah gelap
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Logika Logout (Menutup semua halaman dan kembali ke Login)
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false, // false = Hapus riwayat navigasi sebelumnya
                        );
                      },
                      child: const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}