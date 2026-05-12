class Cafe {
  final int? id;
  final String name;
  final String rating;
  final String location;
  final String description;
  final String imageUrl;

  Cafe({
    this.id,
    required this.name,
    required this.rating,
    required this.location,
    required this.description,
    required this.imageUrl,
  });

  // Convert Cafe object to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'rating': rating,
      'lokasi': location,
      'deskripsi': description,
      'img_url': imageUrl,
    };
  }

  // Create Cafe object from JSON (Supabase response)
  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'] as int?,
      name: json['nama'] as String,
      rating: json['rating'].toString(), // Convert to String
      location: json['lokasi'] as String,
      description: json['deskripsi'] as String,
      imageUrl: json['img_url'] as String,
    );
  }
}
