import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../services/supabase_service.dart';
import '../widgets/item_cafe_grid.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Cafe>> _futureCafes;

  List<Cafe> _allCafes = [];
  List<Cafe> _filteredCafes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCafes = _supabaseService.getAllCafes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List<Cafe> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCafes;
    } else {
      results = _allCafes
          .where(
            (cafe) =>
                cafe.name.toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
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
      body: FutureBuilder<List<Cafe>>(
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

          _allCafes = snapshot.data!;
          if (_filteredCafes.isEmpty) {
            _filteredCafes = _allCafes;
          }

          return Column(
            children: [
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: _searchController,
                      onChanged: (value) => _runFilter(value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF4E342E),
                        ),
                        hintText: "Cari nama cafe...",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _filteredCafes.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  builder: (context) =>
                                      DetailScreen(cafe: _filteredCafes[index]),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Cafe tidak ditemukan...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
