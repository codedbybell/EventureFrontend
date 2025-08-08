// models/category_model.dart

class Category {
  final int id; // ID'yi de almak her zaman iyi bir pratiktir.
  final String name; // API'den gelen 'name' alanına karşılık gelir.
  final String image;

  Category({required this.id, required this.name, required this.image});

  // fromJson metodunu API'nin anahtarlarına göre güncelliyoruz.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      // Null gelme ihtimaline karşı varsayılan değerler atıyoruz.
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Category',
      image: json['image'] ?? '', // Varsayılan boş resim
    );
  }
}
