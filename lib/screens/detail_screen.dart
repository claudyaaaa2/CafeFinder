import 'package:flutter/material.dart';
import '../models/cafe.dart';

class DetailScreen extends StatelessWidget {
  final Cafe cafe; // Menerima objek cafe dari halaman sebelumnya

  const DetailScreen({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      // Di Flutter, kita ganti CoordinatorLayout dengan CustomScrollView
      body: CustomScrollView(
        slivers: [
          // Ini adalah padanan dari CollapsingToolbarLayout
          SliverAppBar(
            expandedHeight: 320.0,
            pinned: true, // Toolbar tetap menempel di atas saat di-scroll
            backgroundColor: const Color(0xFF4E342E), // Warna saat collapsed
            iconTheme: const IconThemeData(color: Colors.black), // navigationIconTint
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                cafe.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Ini adalah padanan dari NestedScrollView
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -40), // layout_marginTop="-40dp"
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  // Padanan dari MaterialCardView
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padanan RelativeLayout (Nama Kafe & Rating)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              cafe.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4E342E),
                              ),
                            ),
                          ),
                          Text(
                            cafe.rating, // Sudah ada icon bintangnya dari model
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Lokasi
                      Text(
                        cafe.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8D6E63),
                        ),
                      ),

                      // Garis Pembatas (Padanan View tinggi 1dp)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(
                          color: Color(0xFFEEEEEE),
                          thickness: 1,
                        ),
                      ),

                      // Tentang Cafe
                      const Text(
                        "Tentang Cafe",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cafe.description,
                        style: const TextStyle(
                          color: Color(0xFF5D4037),
                          height: 1.5, // LineSpacingExtra
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Fasilitas
                      const Text(
                        "Fasilitas",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Padanan LinearLayout Horizontal untuk Fasilitas
                      Wrap(
                        spacing: 8, // Jarak antar item (layout_marginEnd)
                        runSpacing: 8, // Jarak jika turun ke baris baru
                        children: [
                          _buildFasilitasChip("WiFi"),
                          _buildFasilitasChip("Indoor AC"),
                          _buildFasilitasChip("Stopkontak"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat tag fasilitas agar kode tidak menumpuk
  Widget _buildFasilitasChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBE0),
        borderRadius: BorderRadius.circular(4), // Kasih sedikit lengkungan agar rapi
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4E342E),
          fontSize: 12,
        ),
      ),
    );
  }
}