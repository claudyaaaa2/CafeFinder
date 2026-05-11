class Cafe {
  final String name;
  final String rating;
  final String location;
  final String description;
  final String imagePath; // Di Flutter kita pakai String untuk path gambar (misal: 'assets/cafe1.jpg')

 
  Cafe({
    required this.name,
    required this.rating,
    required this.location,
    required this.description,
    required this.imagePath,
  });
}