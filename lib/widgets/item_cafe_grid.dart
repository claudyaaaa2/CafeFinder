import 'package:flutter/material.dart';
import '../models/cafe.dart';

class ItemCafeGrid extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const ItemCafeGrid({super.key, required this.cafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8), // layout_margin="8dp"
      color: Colors.white, // app:cardBackgroundColor="#FFFFFF"
      elevation: 3, // app:cardElevation="3dp"
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // app:cardCornerRadius="16dp"
      ),
      clipBehavior: Clip
          .antiAlias, // Memotong gambar agar sudut atas mengikuti lengkungan 16dp
      child: InkWell(
        onTap: onTap,
        child: Column(
          // LinearLayout vertical
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Kafe
            // Menggunakan Expanded agar proporsional di dalam GridView tanpa menyebabkan overflow
            Expanded(
              child: Image.network(
                cafe.imageUrl,
                width: double.infinity, // layout_width="match_parent"
                fit: BoxFit.cover, // scaleType="centerCrop"
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),

            // 2. Kontainer Info
            Padding(
              padding: const EdgeInsets.all(12.0), // padding="12dp"
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kafe
                  Text(
                    cafe.name,
                    style: const TextStyle(
                      color: Color(0xFF4E342E),
                      fontSize: 14, // textSize="14sp"
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // ellipsize="end"
                  ),

                  const SizedBox(height: 2), // layout_marginTop="2dp"
                  // Lokasi Kafe
                  Text(
                    cafe.location,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 11, // textSize="11sp"
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4), // layout_marginTop="4dp"
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cafe.rating,
                        style: const TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 11, // textSize="11sp"
                          fontWeight: FontWeight.bold,
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
  }
}
