import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cafe.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  static const String _favoriteTable = 'favorite_cafe';

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Get all cafes from database
  Future<List<Cafe>> getAllCafes() async {
    try {
      print('🔍 Fetching cafes from Supabase...');
      final response = await client.from('cafe').select();
      print('📊 Supabase response: $response');

      if (response.isNotEmpty) {
        final cafeList = (response as List)
            .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
            .toList();
        print('✅ Parsed ${cafeList.length} cafes');
        return cafeList;
      }
      print('❌ No cafes found in database');
      return [];
    } catch (e) {
      print('❌ Error fetching cafes: $e');
      rethrow;
    }
  }

  // Get single cafe by id
  Future<Cafe?> getCafeById(int id) async {
    try {
      final response = await client.from('cafe').select().eq('id', id).single();

      return Cafe.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching cafe by id: $e');
      return null;
    }
  }

  // Search cafes by name
  Future<List<Cafe>> searchCafes(String query) async {
    try {
      final response = await client
          .from('cafe')
          .select()
          .ilike('nama', '%$query%');

      if (response.isNotEmpty) {
        final cafeList = (response as List)
            .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
            .toList();
        return cafeList;
      }
      return [];
    } catch (e) {
      print('Error searching cafes: $e');
      rethrow;
    }
  }

  // Get cafes with minimum rating
  Future<List<Cafe>> getCafesByRating(double minRating) async {
    try {
      final response = await client
          .from('cafe')
          .select()
          .gte('rating', minRating);

      if (response.isNotEmpty) {
        final cafeList = (response as List)
            .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
            .toList();
        return cafeList;
      }
      return [];
    } catch (e) {
      print('Error fetching cafes by rating: $e');
      rethrow;
    }
  }

  Future<bool> isCafeFavorited(int cafeId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      return false;
    }

    final response = await client
        .from(_favoriteTable)
        .select('id')
        .eq('user_id', userId)
        .eq('cafe_id', cafeId)
        .limit(1);

    return (response as List).isNotEmpty;
  }

  Future<void> addFavoriteCafe(int cafeId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User belum login.');
    }

    await client.from(_favoriteTable).insert({
      'user_id': userId,
      'cafe_id': cafeId,
    });
  }

  Future<void> removeFavoriteCafe(int cafeId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User belum login.');
    }

    await client
        .from(_favoriteTable)
        .delete()
        .eq('user_id', userId)
        .eq('cafe_id', cafeId);
  }

  Future<List<Cafe>> getMyFavoriteCafes() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }

    final response = await client
        .from(_favoriteTable)
        .select('cafe:cafe_id(id,nama,rating,lokasi,deskripsi,img_url)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final favoriteRows = response as List;
    return favoriteRows
        .map((row) => row['cafe'] as Map<String, dynamic>?)
        .whereType<Map<String, dynamic>>()
        .map(Cafe.fromJson)
        .toList();
  }
}
