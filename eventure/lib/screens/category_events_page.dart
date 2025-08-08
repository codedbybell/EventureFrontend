import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_services.dart';
import 'event_detail_page.dart';

class CategoryEventsPage extends StatefulWidget {
  final String categoryName;

  const CategoryEventsPage({super.key, required this.categoryName});

  @override
  State<CategoryEventsPage> createState() => _CategoryEventsPageState();
}

class _CategoryEventsPageState extends State<CategoryEventsPage> {
  late Future<List<Event>> _categoryEventsFuture;

  @override
  void initState() {
    super.initState();
    _categoryEventsFuture = EventService().fetchEventsByCategory(
      widget.categoryName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.categoryName),
        
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
        // Not: Orijinal kodunuzda açıkça bir geri butonu yoktu, ancak bu stil için
        // eklenmesi yaygın bir uygulamadır. İstemiyorsanız bu 'leading' kısmını silebilirsiniz.
        leading: IconButton(
          onPressed: () {
            // Bir önceki sayfaya döner.
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),

        // 4. Başlık olarak 'categoryName' değişkenini kullanıp rengini beyaz yapıyoruz.
        title: Text(
          categoryName, // Orijinal kodunuzdaki değişken burada kullanıldı.
          style: const TextStyle(
            color: Colors.white, // Stil uyarlaması: Renk beyaz yapıldı.
          ),
        ),

        // Başlığı ortalamak estetik olarak daha iyi duracaktır.
        centerTitle: true,

        // Kendi 'leading' widget'ımızı eklediğimiz için Flutter'ın
        // otomatik olarak bir tane eklemesini engelliyoruz.
        automaticallyImplyLeading: false,

      ),
      body: FutureBuilder<List<Event>>(
        future: _categoryEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Etkinlikler yüklenemedi. Lütfen tekrar deneyin.\nHata: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Bu kategoride etkinlik bulunamadı.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final filteredEvents = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventPreviewCard(context, event);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEventPreviewCard(BuildContext context, Event event) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            Image.network(
              event.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              ),
            ),
            // Detaylar
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
                    _buildInfoRow(
                      context,
                      Icons.calendar_today_outlined,
                      event.date,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      context,
                      Icons.location_on_outlined,
                      event.location,
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

  // Bu widget'ta değişiklik yok.
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
