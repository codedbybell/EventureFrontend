// lib/screens/category_events_page.dart (YENİ DOSYA)

import 'package:eventure/screens/event_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/home_page.dart'; // `allEvents` listesine erişmek için import ediyoruz

class CategoryEventsPage extends StatelessWidget {
  final String categoryName;

  const CategoryEventsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Ana 'allEvents' listesinden bu kategoriye ait olanları filtrele
    final List<Map<String, dynamic>> filteredEvents = allEvents
        .where((event) => event['category'] == categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
      ),
      body: filteredEvents.isEmpty
          ? const Center(
              child: Text(
                'No events found in this category.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventPreviewCard(context, event);
              },
            ),
    );
  }

  // Etkinlik önizleme kartını oluşturan widget
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
        clipBehavior:
            Clip.antiAlias, // Resmin kartın köşelerinden taşmasını engeller
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            Image.network(
              event['image'],
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
            // Detaylar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    _buildInfoRow(
                      context,
                      Icons.calendar_today_outlined,
                      event['date'],
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      context,
                      Icons.location_on_outlined,
                      event['location'],
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
