import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_services.dart';
import 'event_detail_page.dart';

class AllPopularEventsPage extends StatefulWidget {
  const AllPopularEventsPage({super.key});

  @override
  State<AllPopularEventsPage> createState() => _AllPopularEventsPageState();
}

class _AllPopularEventsPageState extends State<AllPopularEventsPage> {
  late Future<List<Event>> _popularEventsFuture;

  @override
  void initState() {
    super.initState();
    _popularEventsFuture = EventService().fetchPopularEvents();
  }

  @override
  Widget build(BuildContext context) {
    // YENİ: Renk kodunu kullanabilmek için mevcut temayı alıyoruz.
    final theme = Theme.of(context);

    return Scaffold(

      
      body: FutureBuilder<List<Event>>(
        future: _popularEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No popular events found.'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(context, event);
            },
          );

      appBar: AppBar(
        // 1. Arka planı şeffaf yapıp gölgeyi kaldırıyoruz.
        backgroundColor: Colors.transparent,
        elevation: 0,

        // 2. 'flexibleSpace' ile gradyan arka planı ekliyoruz.
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B9D), // Pembe tonu
                Color(0xFF4ECDC4), // Turkuaz tonu
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        // --- Orijinal AppBar içeriğiniz gradyan stile uyarlandı ---

        // 3. Geri butonunun rengi gradyan üzerinde okunması için beyaz yapıldı.
        leading: IconButton(
          onPressed: () {
            // Bir önceki sayfaya döner.
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı.
          ),
        ),

        // 4. Başlığın rengi de beyaz yapıldı.
        title: const Text(
          'Popular Events',
          style: TextStyle(
            color: Colors.white, // Değişiklik: Renk beyaz yapıldı.
          ),
        ),

        // Orijinal kodunuzdaki bu özellikler korunuyor.
        centerTitle:
            true, // Başlığı ortalamak estetik olarak daha iyi duracaktır.
        automaticallyImplyLeading: false,
      ),
          

        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Row(
          children: [
            Image.network(
              event.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.location,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
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
