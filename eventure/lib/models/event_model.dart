// lib/models/event_model.dart

class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final String image;
  final String date;
  final String time;
  final int capacity;
  final int categoryId;
  final String categoryName;
  final int bookingCounts;
  final List<String> tags;
  final String? color;

  // <<< YENİ EKLENEN ALAN >>>
  // Kullanıcının bu etkinliğe kayıtlı olup olmadığını tutar.
  final bool isBooked;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.date,
    required this.time,
    required this.capacity,
    required this.categoryId,
    required this.categoryName,
    required this.bookingCounts,
    required this.tags,
    this.color,

    // <<< YENİ EKLENEN ALAN >>>
    // Constructor'a ekledik ve varsayılan değer olarak 'false' verdik.
    // Bu, backend'den bu bilgi gelmezse bile uygulamanın çökmemesini sağlar.
    required this.isBooked,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      location: json['location'] ?? 'Unknown',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      capacity: json['capacity'] ?? 0,
      categoryId: json['category'] ?? 0,
      categoryName: json['category_name'] ?? 'Uncategorized',
      bookingCounts: json['bookings_count'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      color: json['color'],

      // <<< YENİ EKLENEN ALAN >>>
      // Backend'den gelen 'is_booked' alanını okuyoruz.
      // Eğer bu alan JSON'da yoksa veya null ise, varsayılan olarak 'false' kabul ediyoruz.
      isBooked: json['is_booked'] ?? false,
    );
  }

  // toJson metodunun bu özellik için değiştirilmesine gerek yok,
  // çünkü 'is_booked' durumunu frontend'den backend'e göndermiyoruz.
  // Bu, sadece backend'den okuduğumuz bir bilgidir.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'location': location,
      'image': image,
      'date': date,
      'time': time,
      'capacity': capacity,
      'category': categoryId,
      'tags': tags.join(','),
    };
    if (color != null) {
      data['color'] = color;
    }
    return data;
  }
}
