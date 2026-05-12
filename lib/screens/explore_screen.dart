import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../widgets/item_cafe_grid.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 1. Data asli dari ExploreFragment.java kamu
  final List<Cafe> _allCafes = [
    Cafe(name: "Sin Coffee 3", rating: " 5.0", location: "Tondo, Kota Palu", description: "Coffee shop dengan konsep open space yang sangat nyaman. Cocok untuk nongkrong malam atau nugas pagi hari.", imagePath: "assets/cafe1.jpg"),
    Cafe(name: "Ngopipes", rating: " 5.0", location: "Besusu Tengah, Kota Palu", description: "Tempatnya asik dan tenang. Sangat direkomendasikan untuk Anda yang mencari ketenangan saat bekerja.", imagePath: "assets/cafe2.jpg"),
    Cafe(name: "Tanaris Coffee", rating: "4.3", location: "Jl. Juanda, Lolu Utara", description: "Salah satu cafe legendaris di Palu dengan area yang sangat luas dan pilihan menu yang beragam.", imagePath: "assets/cafe3.jpg"),
    Cafe(name: "Uncle Han", rating: "4.9", location: "Besusu Tengah, Kota Palu", description: "Kopitiam modern dengan suasana yang hangat. Sangat cocok untuk sarapan atau sekadar menikmati kopi susu.", imagePath: "assets/cafe8.jpg"),
    Cafe(name: "BRKH Coffee", rating: "4.6", location: "Tondo, Kota Palu", description: "Tempat favorit mahasiswa Tondo. Harga terjangkau dan suasana sangat mendukung untuk belajar bersama.", imagePath: "assets/cafe5.jpg"),
    Cafe(name: "KOPTE SOETTA", rating: "4.6", location: "Jl. Soekarno Hatta, Tondo", description: "Lokasi strategis di pinggir jalan utama. Nyaman untuk istirahat sejenak sambil menikmati kopi.", imagePath: "assets/cafe6.jpg"),
    Cafe(name: "See You Latte", rating: "4.4", location: "Jl. Wolter Monginsidi", description: "Desain interior yang estetik dan instagramable. Kopinya pun tak kalah enak dengan suasananya.", imagePath: "assets/cafe7.jpg"),
    Cafe(name: "A’ROBI PRIME", rating: "3.4", location: "Tanamodindi", description: "Area yang luas dengan konsep semi-outdoor. Pas untuk berkumpul dengan teman-teman.", imagePath: "assets/cafe8.jpg"),
    Cafe(name: "Kopitaro", rating: "4.6", location: "Tanamodindi", description: "Tempat yang tenang dan nyaman untuk fokus. Pilihan tepat bagi yang ingin nugas tanpa gangguan.", imagePath: "assets/cafe9.jpg"),
    Cafe(name: "TECO", rating: "4.2", location: "Palu Selatan", description: "Teknik Coffee (TECO) menawarkan suasana santai dengan kopi berkualitas. Favorit bagi penikmat kopi sejati.", imagePath: "assets/cafe10.jpg"),
  ];

  // 2. Variabel untuk menampung hasil filter pencarian
  List<Cafe> _filteredCafes = [];

  @override
  void initState() {
    super.initState();
    _filteredCafes = _allCafes; // Awalnya tampilkan semua
  }

  // 3. Fungsi logika pencarian (Search Logic)
  void _runFilter(String enteredKeyword) {
    List<Cafe> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCafes;
    } else {
      // Filter berdasarkan nama kafe (case insensitive)
      results = _allCafes
          .where((cafe) =>
              cafe.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredCafes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Column(
        children: [
          // HEADER + SEARCH BAR (Pindah dari XML ke Widget)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4E342E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jelajahi Cafe",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                
                // INI NAVBAR SEARCH-NYA
                TextField(
                  onChanged: (value) => _runFilter(value), // Filter saat mengetik
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF4E342E)),
                    hintText: "Cari nama cafe...",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // GRID HASIL PENCARIAN
          Expanded(
            child: _filteredCafes.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filteredCafes.length,
                    itemBuilder: (context, index) {
                      return ItemCafeGrid(
                        cafe: _filteredCafes[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(cafe: _filteredCafes[index]),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text("Cafe tidak ditemukan...", style: TextStyle(color: Colors.grey)),
                  ),
          ),
        ],
      ),
    );
  }
}