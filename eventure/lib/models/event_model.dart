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
  final int organizerId;
  final String organizerUsername;
  final int categoryId;
  final String categoryName;
  final int bookingCounts;
  final List<String> tags;
  // YENİ: Backend'den gelebilecek renk kodu için nullable bir alan.
  final String? color;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.date,
    required this.time,
    required this.capacity,
    required this.organizerId,
    required this.organizerUsername,
    required this.categoryId,
    required this.categoryName,
    required this.bookingCounts,
    required this.tags,
    this.color, // Constructor'a ekledik.
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
      organizerId: json['organizer'] ?? 0,
      organizerUsername: json['organizer_username'] ?? 'Unknown',
      categoryId: json['category'] ?? 0,
      categoryName: json['category_name'] ?? 'Uncategorized',
      bookingCounts: json['bookings_count'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      // YENİ: JSON'dan 'color' alanını okuyoruz. Yoksa null olacak.
      color: json['color'],
    );
  }

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
    // Eğer renk null değilse, JSON'a ekle.
    if (color != null) {
      data['color'] = color;
    }
    return data;
  }
}
