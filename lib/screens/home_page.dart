import 'package:flutter/material.dart';
import '../models/cafe.dart';
import 'detail_screen.dart'; // File ini harus ada agar navigasi tidak error

class HomePage extends StatefulWidget {
  final String username;

  // Constructor untuk menerima data username dari LoginActivity/LoginScreen
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Logika toggle tampilan (isGridView = false)
  bool _isGridView = false;

  // Data List (Pindahan dari prepareData() di Java)
  final List<Cafe> _cafeList = [
    Cafe(
      name: "Sin Coffee 3",
      rating: "⭐ 4.2",
      location: "Tondo, Kota Palu",
      description: "Tempat favorit mahasiswa buat ngerjain tugas. Suasananya tenang, kopinya enak.",
      imagePath: "assets/cafe1.jpg",
    ),
    Cafe(
      name: "Ruang Dualapan",
      rating: "⭐ 4.5",
      location: "Besusu, Kota Palu",
      description: "Konsep industrial yang kece. Cocok buat nongkrong sore sambil nugas santai.",
      imagePath: "assets/cafe2.jpg",
    ),
    Cafe(
      name: "Kafi Coffee Palu",
      rating: "⭐ 4.8",
      location: "Polem, Kota Palu",
      description: "Salah satu cafe dengan rating tertinggi di Palu. Sangat nyaman untuk meeting.",
      imagePath: "assets/cafe3.jpg",
    ),
    Cafe(
      name: "GIS Coffee",
      rating: "⭐ 4.8",
      location: "Jl. Bali, Kota Palu",
      description: "Tempatnya luas, parkiran aman, dan kopinya juara.",
      imagePath: "assets/cafe4.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Column(
        children: [
          // HEADER: Pindahan dari @id/header_container di XML
          Container(
            width: double.infinity,
            height: 190,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF4E342E),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Halo, ${widget.username}!", // Menampilkan Username (widget. untuk akses constructor)
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Mau nugas di mana hari ini?",
                  style: TextStyle(color: Color(0xFFD7CCC8), fontSize: 14),
                ),
              ],
            ),
          ),

          // BODY: Area scroll (Pengganti NestedScrollView)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Judul & Tombol Toggle (Pengganti btn_switch_view)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rekomendasi Utama",
                          style: TextStyle(
                            color: Color(0xFF4E342E),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isGridView ? Icons.view_list : Icons.grid_view,
                            color: const Color(0xFF4E342E),
                          ),
                          onPressed: () {
                            setState(() {
                              _isGridView = !_isGridView; // Update tampilan
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // LIST/GRID CAFE (Pengganti rv_home)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _isGridView ? _buildGrid() : _buildList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan List (Pengganti item_cafe_linear.xml)
  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true, // Wajib jika di dalam ScrollView
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cafeList.length,
      itemBuilder: (context, index) {
        final cafe = _cafeList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(cafe.imagePath, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(cafe.location, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(cafe.rating, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            onTap: () => _goToDetail(cafe),
          ),
        );
      },
    );
  }

  // Tampilan Grid (Pengganti item_cafe_grid.xml)
  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cafeList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final cafe = _cafeList[index];
        return GestureDetector(
          onTap: () => _goToDetail(cafe),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    child: Image.asset(cafe.imagePath, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cafe.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                      Text(cafe.rating, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi Navigasi (Pengganti Intent)
  void _goToDetail(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(cafe: cafe), // Kirim data cafe utuh
      ),
    );
  }
}