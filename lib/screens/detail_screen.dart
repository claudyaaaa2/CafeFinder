import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../services/supabase_service.dart';

class DetailScreen extends StatefulWidget {
  final Cafe cafe;

  const DetailScreen({super.key, required this.cafe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  bool isFavorite = false;
  bool _isFavoriteLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    if (widget.cafe.id == null) {
      if (!mounted) return;
      setState(() {
        _isFavoriteLoading = false;
      });
      return;
    }

    try {
      final saved = await _supabaseService.isCafeFavorited(widget.cafe.id!);
      if (!mounted) return;
      setState(() {
        isFavorite = saved;
      });
    } catch (_) {
      // Keep default state if check fails.
    } finally {
      if (!mounted) return;
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (widget.cafe.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data cafe tidak valid.')));
      return;
    }
    if (_isFavoriteLoading) return;

    setState(() {
      _isFavoriteLoading = true;
    });

    try {
      if (isFavorite) {
        await _supabaseService.removeFavoriteCafe(widget.cafe.id!);
      } else {
        await _supabaseService.addFavoriteCafe(widget.cafe.id!);
      }
      if (!mounted) return;
      setState(() {
        isFavorite = !isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengubah favorit: $error')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // Header Image
          Image.network(
            widget.cafe.imageUrl,
            width: double.infinity,
            height: 420,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                width: double.infinity,
                height: 420,
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              );
            },
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 360),
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
                      // Nama & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.cafe.name,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFB300), size: 24),
                              const SizedBox(width: 4),
                              Text(
                                widget.cafe.rating,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFB300)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      
                      // Alamat/Lokasi Text
                      Text(
                        widget.cafe.location,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF8D6E63)),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFEEEEEE), thickness: 1.5),
                      const SizedBox(height: 20),

                      // Deskripsi
                      const Text(
                        "Tentang Cafe",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.cafe.description,
                        style: const TextStyle(fontSize: 15, color: Color(0xFF5D4037), height: 1.6),
                      ),
                      const SizedBox(height: 25),

                      // Fasilitas
                      const Text(
                        "Fasilitas",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
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

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Favorite Button
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 28,
                ),
              ),
            ),
          ),

          // Loading Indicator for Favorite
          if (_isFavoriteLoading)
            const Positioned(
              top: 58,
              right: 66,
              child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
    );
  }

  Widget _buildFasilitasChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF5EBE0), borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF4E342E), fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}
