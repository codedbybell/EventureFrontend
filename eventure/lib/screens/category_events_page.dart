import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için
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
  // API'den gelecek veriyi tutacak Future nesnesi
  late Future<List<Event>> _categoryEventsFuture;

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında ilgili kategoriye ait etkinlikleri çek
    _categoryEventsFuture = EventService().fetchEventsByCategory(
      widget.categoryName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Gradyanlı Tasarım) ---
      appBar: AppBar(
        // Arka planı şeffaf yapıp gölgeyi kaldırıyoruz
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Geri butonunun rengi gradyan üzerinde okunması için beyaz yapıldı
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // Başlık olarak kategori adını kullanıp rengini beyaz yapıyoruz
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        // 'flexibleSpace' ile gradyan arka planı ekliyoruz
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),

      // --- Sayfa Gövdesi ---
      body: FutureBuilder<List<Event>>(
        future: _categoryEventsFuture,
        builder: (context, snapshot) {
          // 1. Veri yüklenirken
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Hata durumunda
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Etkinlikler yüklenemedi.\nLütfen internet bağlantınızı kontrol edip tekrar deneyin.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }
          // 3. Veri yoksa veya boşsa
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Bu kategoride henüz etkinlik bulunmuyor.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          // 4. Veri başarıyla geldiyse
          else {
            final filteredEvents = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
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

  // Etkinlik önizleme kartını oluşturan yardımcı widget
  Widget _buildEventPreviewCard(BuildContext context, Event event) {
    String formattedDate = '';
    try {
      final date = DateTime.parse(event.date);
      formattedDate = DateFormat('d MMMM yyyy').format(date);
    } catch (e) {
      formattedDate = event.date;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(eventId: event.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Row(
          children: [
            // Resim
            Image.network(
              event.image,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 110,
                height: 110,
                color: Colors.grey.shade200,
                child: Icon(Icons.image_not_supported,
                    color: Colors.grey.shade400),
              ),
            ),
            // Detaylar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      formattedDate, // Formatlanmış tarihi kullan
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

  // Bilgi satırlarını oluşturan yardımcı widget (Değişiklik yok)
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
