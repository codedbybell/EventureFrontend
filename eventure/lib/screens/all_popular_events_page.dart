// lib/screens/all_popular_events_page.dart (YENİ DOSYA)

import 'package:flutter/material.dart';
import 'package:eventure/screens/home_page.dart';
import 'package:eventure/screens/event_detail_page.dart';

class AllPopularEventsPage extends StatelessWidget {
  const AllPopularEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // YENİ: Renk kodunu kullanabilmek için mevcut temayı alıyoruz.
    final theme = Theme.of(context);

    return Scaffold(
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
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: popularEvents.length,
        itemBuilder: (context, index) {
          final event = popularEvents[index];
          // Diğer sayfalardaki kart tasarımını yeniden kullanıyoruz
          return _buildEventPreviewCard(context, event);
        },
      ),
    );
  }

  Widget _buildEventPreviewCard(
    BuildContext context,
    Map<String, dynamic> event,
  ) {
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
            Image.network(
              event['image'],
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['location'],
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
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
