import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için gerekli (pubspec.yaml'a eklemeyi unutmayın)
import 'package:eventure/models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Tema renklerine kolay erişim için
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Tarihi daha okunaklı bir formata çevirelim
    String formattedDate = '';
    try {
      // Örnek: "2024-08-15" -> "15 August 2024"
      final date = DateTime.parse(event.date);
      formattedDate = DateFormat('d MMMM yyyy').format(date);
    } catch (e) {
      // Eğer formatlama başarısız olursa, ham veriyi göster
      formattedDate = event.date;
    }

    // Saati daha okunaklı bir formata çevirelim
    String formattedTime = '';
    try {
      // Örnek: "19:30:00" -> "07:30 PM"
      final time = TimeOfDay(
        hour: int.parse(event.time.split(':')[0]),
        minute: int.parse(event.time.split(':')[1]),
      );
      formattedTime = time.format(context);
    } catch (e) {
      // Eğer formatlama başarısız olursa, ham veriyi göster (saniyesiz)
      formattedTime = event.time.substring(0, 5);
    }

    return Scaffold(
      // Arka plan rengini tema ile uyumlu hale getirelim
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Geri butonu ve başlık içeren, kaydırıldığında küçülen AppBar
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                event.title,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Image.network(
                event.image,
                fit: BoxFit.cover,
                // Resim yüklenirken hata olursa gösterilecek fallback
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),
          // Sayfanın geri kalan kaydırılabilir içeriği
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve Açıklama
                  Text(
                    event.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Etiketler (Tags)
                  if (event.tags.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: event.tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: colorScheme.primaryContainer,
                              labelStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  if (event.tags.isNotEmpty) const SizedBox(height: 24),

                  // Detay Kutusu (Tarih, Saat, Lokasyon, Organizatör)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          icon: Icons.calendar_today_outlined,
                          text: formattedDate,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          icon: Icons.access_time_outlined,
                          text: formattedTime,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          icon: Icons.location_on_outlined,
                          text: event.location,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          icon: Icons.person_outline,
                          text: event.organizerUsername,
                        ),
                        if (event.capacity > 0) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            icon: Icons.people_outline,
                            text:
                                '${event.bookingCounts} / ${event.capacity} Booked',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      // Sayfanın en altında sabit duran buton
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Rezervasyon yapma fonksiyonunu buraya bağla
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking for ${event.title}...')),
            );
          },
          label: const Text("Book Now"),
          icon: const Icon(Icons.check_circle_outline),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  // Bilgi satırlarını oluşturan yardımcı widget
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
