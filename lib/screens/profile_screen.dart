import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cafe.dart';
import '../services/supabase_service.dart';
import 'detail_screen.dart';
import 'login_screen.dart'; // Import agar fungsi Logout bisa kembali ke Login
// import 'edit_profile_screen.dart'; // Ini akan kita aktifkan nanti setelah filenya dibuat

class ProfileScreen extends StatefulWidget {
  final String username;

  // Constructor untuk menangkap data username dari MainScreen
  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  // 1. Tempat nyimpan data dari API Amar nanti
  List<Cafe> favoriteCafes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // 2. Fungsi buat ambil data favorit
  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    try {
      final favorites = await _supabaseService.getMyFavoriteCafes();
      if (!mounted) return;
      setState(() {
        favoriteCafes = favorites;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat favorit: $error')));
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Cafe cafe) async {
    if (cafe.id == null) return;

    try {
      await _supabaseService.removeFavoriteCafe(cafe.id!);
      if (!mounted) return;
      setState(() {
        favoriteCafes.removeWhere((item) => item.id == cafe.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${cafe.name} dihapus dari favorit')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus favorit: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Column(
        children: [
          // ==========================================
          // 1. HEADER PROFIL (Asli buatanmu)
          // ==========================================
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
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // FOTO PROFIL BUNDAR
                Container(
                  width: 84,
                  height: 84,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 12),

                // NAMA USER
                Text(
                  widget
                      .username, // Berubah jadi widget.username karena StateFul
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. KONTEN SCROLL BAWAH
          // ==========================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BAGIAN FAVORIT KAFE ---
                  const Text(
                    "Kafe Favorit Saya",
                    style: TextStyle(
                      color: Color(0xFF4E342E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Menampilkan Loading, Empty State, atau List Favorit
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : favoriteCafes.isEmpty
                      ? _buildEmptyState()
                      : _buildFavoriteList(),

                  const SizedBox(
                    height: 35,
                  ), // Jarak antara Favorit dan Pengaturan
                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 20),

                  // --- BAGIAN PENGATURAN (Asli buatanmu) ---
                  const Text(
                    "Pengaturan Akun",
                    style: TextStyle(
                      color: Color(0xFF4E342E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // KARTU UBAH PASSWORD
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Buka halaman EditProfileScreen
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Color(0xFF4E342E)),
                            SizedBox(width: 16),
                            Text(
                              "Ubah Password",
                              style: TextStyle(color: Color(0xFF4E342E)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TOMBOL LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Supabase.instance.client.auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ), // Tambahan ruang kosong di bawah agar tidak mentok
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Tampilan kalau favorit masih kosong
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.favorite_border, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text(
            "Belum ada kafe favorit.\nYuk, cari tempat nugas!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Tampilan List Favorit
  Widget _buildFavoriteList() {
    return ListView.builder(
      shrinkWrap:
          true, // WAJIB ADA: Agar ListView tidak error di dalam SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // WAJIB ADA: Agar scrollnya menyatu dengan halaman
      itemCount: favoriteCafes.length, // Nanti ikut jumlah data API
      itemBuilder: (context, index) {
        final cafe = favoriteCafes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cafe.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            title: Text(
              cafe.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(cafe.location),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                _removeFavorite(cafe);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(cafe: cafe),
                ),
              ).then((_) => _loadFavorites());
            },
          ),
        );
      },
    );
  }
}
