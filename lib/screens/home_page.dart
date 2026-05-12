import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../services/supabase_service.dart';
import '../widgets/weather_card.dart';
import 'detail_screen.dart'; // File ini harus ada agar navigasi tidak error

class HomePage extends StatefulWidget {
  final String username;

  // Constructor untuk menerima data username dari LoginActivity/LoginScreen
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Cafe>> _futureCafes;
  static const int _maxRecommendedCafe = 4;

  // Logika toggle tampilan (isGridView = false)
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _futureCafes = _supabaseService.getAllCafes();
  }

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
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
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
            child: FutureBuilder<List<Cafe>>(
              future: _futureCafes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 64),
                        SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data cafe'));
                }

                final cafeList = snapshot.data!;
                final recommendedCafes = cafeList
                    .take(_maxRecommendedCafe)
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Weather Card Component
                      WeatherCard(),

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
                        child: _isGridView
                            ? _buildGrid(recommendedCafes)
                            : _buildList(recommendedCafes),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan List (Pengganti item_cafe_linear.xml)
  Widget _buildList(List<Cafe> cafeList) {
    return ListView.builder(
      shrinkWrap: true, // Wajib jika di dalam ScrollView
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cafeList.length,
      itemBuilder: (context, index) {
        final cafe = cafeList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
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
            subtitle: Text(
              cafe.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  cafe.rating,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () => _goToDetail(cafe),
          ),
        );
      },
    );
  }

  // Tampilan Grid (Pengganti item_cafe_grid.xml)
  Widget _buildGrid(List<Cafe> cafeList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cafeList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final cafe = cafeList[index];
        return GestureDetector(
          onTap: () => _goToDetail(cafe),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: Image.network(
                      cafe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cafe.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            cafe.rating,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
