// lib/screens/event_detail_page.dart (TASARIM KORUNARAK GÜNCELLENDİ)

import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Sabit beyaz renk tanımı artık kullanılmayacak.
    // const Color customBackgroundColor = Color.fromARGB(255, 255, 255, 255);

    final theme = Theme.of(context);
    return Scaffold(
      // --- TEK DEĞİŞİKLİK BURADA ---
      // Arka plan rengi, sabit beyaz yerine artık temadan dinamik olarak alınıyor.
      backgroundColor: theme.scaffoldBackgroundColor,

      // Gradyanlı AppBar'ınızın yapısı olduğu gibi korunuyor.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B9D),
                Color(0xFF4ECDC4),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          event['title'] ?? 'Event Detail',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  event['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (event['tags'] != null)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: (event['tags'] as List<dynamic>)
                      .map(
                        (tag) => Chip(
                          label: Text(tag.toString()),
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: theme.textTheme.bodyMedium,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                icon: Icons.info_outline,
                text: event['organizer'] ?? 'Not specified',
                // Bu metnin rengini tema arka planına göre ayarlayalım
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                event['title'],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event['subtitle'],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              // Detay kutusunun rengi de artık temadan alınacak.
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // Temadan alınıyor
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: event['location'] ?? 'Location not specified',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      text: '${event['date'] ?? ''}  ${event['time'] ?? ''}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Gradyanlı butonunuzun yapısı olduğu gibi korunuyor.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
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
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? theme.colorScheme.onBackground),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color ?? theme.colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
