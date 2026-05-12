import 'package:flutter/material.dart';
import '../models/cafe.dart';

class DetailScreen extends StatefulWidget {
  final Cafe cafe;

  const DetailScreen({super.key, required this.cafe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Variabel untuk nyimpan status warna tombol hati
  bool isFavorite = false;

  // Fungsi yang nanti akan dikerjakan Amar
  Future<void> _toggleFavorite() async {
    // TODO: AMAR - Masukkan logika http.post ke API Laravel/MongoDB di sini!
    // Kamu bisa kirim 'widget.cafe.name' atau ID kafenya ke backend.
    
    // UI Flutter akan langsung merubah warna hatinya
    setState(() {
      isFavorite = !isFavorite;
    });

    // Munculkan notifikasi pop-up kecil di bawah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? "Ditambahkan ke Favorit" : "Dihapus dari Favorit"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // 1. GAMBAR BACKGROUND (Header)
          Image.asset(
            widget.cafe.imagePath, // Berubah jadi widget.cafe
            width: double.infinity,
            height: 420,
            fit: BoxFit.cover,
          ),

          // 2. KONTEN SCROLLABLE
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 360),

                // 3. KARTU PUTIH (THE FLOATING CARD)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.cafe.name, // Berubah jadi widget.cafe
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFB300), size: 24),
                              const SizedBox(width: 4),
                              Text(
                                widget.cafe.rating, // Berubah jadi widget.cafe
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFB300),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.cafe.location, // Berubah jadi widget.cafe
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Color(0xFF8D6E63),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFEEEEEE), thickness: 1.5),
                      const SizedBox(height: 20),

                      const Text(
                        "Tentang Cafe",
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.cafe.description, // Berubah jadi widget.cafe
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5D4037),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 25),
                      
                      const Text(
                        "Fasilitas",
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildFasilitasChip("WiFi"),
                          _buildFasilitasChip("Indoor AC"),
                          _buildFasilitasChip("Stopkontak"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // 4. TOMBOL BACK (Di pojok kiri atas)
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
            ),
          ),

          // 5. TOMBOL FAVORIT BARU (Di pojok kanan atas)
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: _toggleFavorite, // Memanggil fungsi di atas
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Warna background putih cerah
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ]
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey, // Merah kalau aktif, abu-abu kalau belum
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper tetap sama
  Widget _buildFasilitasChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBE0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4E342E),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}