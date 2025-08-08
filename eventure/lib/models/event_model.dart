// event_model.dart

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
  });

  // fromJson metodu artık tertemiz!
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      // ?? operatörü ile null gelme ihtimaline karşı koruma
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      location: json['location'] ?? 'Unknown',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      capacity: json['capacity'] ?? 0,

      // Backend'den gelen yeni, temiz alanları doğrudan atıyoruz.
      organizerId: json['organizer'] ?? 0,
      organizerUsername: json['organizer_username'] ?? 'Unknown',
      categoryId: json['category'] ?? 0,
      categoryName: json['category_name'] ?? 'Uncategorized',
      bookingCounts: json['bookings_count'] ?? 0,

      // Backend artık her zaman bir liste göndereceği için bu atama çok güvenli.
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  // toJson metodu genellikle yeni bir veri oluştururken kullanılır
  // ve daha az alan içerir. Bu kısım projenizin ihtiyacına göre değişebilir.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'image': image,
      'date': date,
      'time': time,
      'capacity': capacity,
      'category': categoryId,
      // Backend'e etiket gönderirken virgülle birleştirilmiş string'e çeviririz.
      'tags': tags.join(','),
    };
  }
}
