import 'package:flutter/material.dart';
import '../models/cafe.dart';

class ItemCafeLinear extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const ItemCafeLinear({
    super.key,
    required this.cafe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8), // Sesuai android:layout_margin="8dp"
      color: Colors.white, // app:cardBackgroundColor="#FFFFFF"
      elevation: 3, // app:cardElevation="3dp"
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // app:cardCornerRadius="16dp"
      ),
      clipBehavior: Clip.antiAlias, // Penting: memotong ujung gambar agar mengikuti lengkungan kartu
      child: InkWell(
        onTap: onTap, // Efek ripple saat diklik
        child: Row( // Sesuai LinearLayout horizontal
          children: [
            // 1. Gambar Kafe (Sesuai ImageView img_item_photo)
            Image.asset(
              cafe.imagePath,
              width: 100, // layout_width="100dp"
              height: 100, // layout_height="100dp"
              fit: BoxFit.cover, // scaleType="centerCrop"
            ),
            
            // 2. Kontainer Teks (Sesuai LinearLayout vertical)
            // Expanded digunakan agar teks mengambil sisa ruang di sebelah kanan gambar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0), // android:padding="12dp"
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // android:gravity="center_vertical"
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
                    
                    const SizedBox(height: 4), // layout_marginTop="4dp"
                    
                    // Rating Kafe (tv_item_rating)
                    Text(
                      cafe.rating, // Data model sudah memuat icon ⭐
                      style: const TextStyle(
                        color: Color(0xFFFF9800), // Warna oranye
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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