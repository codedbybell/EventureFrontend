import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için
import 'package:eventure/models/event_model.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Tema ve renk şemalarına kolay erişim
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Tarih ve saati kullanıcı dostu formata çevirme
    String formattedDate = _formatDate(event.date);
    String formattedTime = _formatTime(context, event.time);

    return Scaffold(
      // Arka plan rengini temadan alıyoruz
      backgroundColor: theme.scaffoldBackgroundColor,

      // Gövde içeriğinin AppBar'ın arkasına geçmesini sağlıyoruz
      extendBodyBehindAppBar: true,

      // AppBar (Şeffaf ve Gradyanlı)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Event Detail',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      // Sayfa Gövdesi
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim ve Başlık Bölümü (Gradyanlı Arka Plan)
            _buildHeaderSection(context, event, textTheme),

            // İçerik Bölümü (Detaylar, Etiketler vb.)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Etiketler (Tags)
                  if (event.tags.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: event.tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: colorScheme.primaryContainer
                                    .withOpacity(0.5),
                                labelStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ))
                          .toList(),
                    ),
                  if (event.tags.isNotEmpty) const SizedBox(height: 24),

                  // Açıklama
                  Text(
                    'About this event',
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bilgi Kutusu (Tarih, Saat, Lokasyon, Organizatör)
                  _buildInfoBox(context, formattedDate, formattedTime, event,
                      colorScheme),

                  // Buton ile içerik arasına boşluk bırakmak için
                  const SizedBox(
                      height: 100), // Butonun içeriğin üzerine gelmemesi için
                ],
              ),
            ),
          ],
        ),
      ),

      // --- EKLENEN KISIM: EKRANIN ALTINA SABİTLENMİŞ BUTON ---
      bottomNavigationBar: Padding(
        // Kenar boşlukları ile butonu daha estetik hale getiriyoruz
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: _buildGradientButton(context),
      ),
    );
  }

  // --- Yardımcı Widget'lar ---

  Widget _buildHeaderSection(
      BuildContext context, Event event, TextTheme textTheme) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                event.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      event.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.image_not_supported,
                            color: Colors.white.withOpacity(0.7), size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              blurRadius: 5.0,
                              color: Colors.black.withOpacity(0.5))
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String formattedDate,
      String formattedTime, Event event, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(context,
              icon: Icons.calendar_today_outlined, text: formattedDate),
          const Divider(height: 24),
          _buildInfoRow(context,
              icon: Icons.access_time_outlined, text: formattedTime),
          const Divider(height: 24),
          _buildInfoRow(context,
              icon: Icons.location_on_outlined, text: event.location),
          const Divider(height: 24),
          _buildInfoRow(context,
              icon: Icons.person_outline,
              text: "by ${event.organizerUsername}"),
          if (event.capacity > 0) ...[
            const Divider(height: 24),
            _buildInfoRow(
              context,
              icon: Icons.people_outline,
              text: '${event.bookingCounts} / ${event.capacity} Booked',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking for ${event.title}...')),
        );
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
          shadowColor: const Color(0xFFFF6B9D).withOpacity(0.5)),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: const Text(
            "Book Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

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

  // --- Yardımcı Fonksiyonlar ---
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(BuildContext context, String timeString) {
    try {
      final time = TimeOfDay(
        hour: int.parse(timeString.split(':')[0]),
        minute: int.parse(timeString.split(':')[1]),
      );
      return time.format(context);
    } catch (e) {
      return timeString.length > 5 ? timeString.substring(0, 5) : timeString;
    }
  }
}
