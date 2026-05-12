import 'package:flutter/material.dart';
import '../models/cafe.dart';

class ItemCafeLinear extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const ItemCafeLinear({super.key, required this.cafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8), // Sesuai android:layout_margin="8dp"
      color: Colors.white, // app:cardBackgroundColor="#FFFFFF"
      elevation: 3, // app:cardElevation="3dp"
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // app:cardCornerRadius="16dp"
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          // Sesuai LinearLayout horizontal
          children: [
            Image.network(
              cafe.imageUrl,
              width: 100, // layout_width="100dp"
              height: 100, // layout_height="100dp"
              fit: BoxFit.cover, // scaleType="centerCrop"
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0), // android:padding="12dp"
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // android:gravity="center_vertical"
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Kafe (tv_item_name)
                    Text(
                      cafe.name,
                      style: const TextStyle(
                        color: Color(0xFF4E342E),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Lokasi Kafe (tv_item_address)
                    Text(
                      cafe.location,
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFF9800),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cafe.rating,
                          style: const TextStyle(
                            color: Color(0xFFFF9800), // Warna oranye
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
