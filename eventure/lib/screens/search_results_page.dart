// lib/screens/search_results_page.dart (YENİ DOSYA)

import 'package:eventure/screens/event_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/home_page.dart'; // `allEvents` listesine erişmek için

class SearchResultsPage extends StatelessWidget {
  final String searchQuery;

  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Arama terimini küçük harfe çevirerek case-sensitive olmasını engelle
    final lowerCaseQuery = searchQuery.toLowerCase();

    // Ana listede arama yap (başlık, altbaşlık veya organizatör içinde)
    final List<Map<String, dynamic>> searchResults = allEvents.where((event) {
      final title = event['title'].toString().toLowerCase();
      final subtitle = event['subtitle'].toString().toLowerCase();
      final organizer = event['organizer'].toString().toLowerCase();

      return title.contains(lowerCaseQuery) ||
          subtitle.contains(lowerCaseQuery) ||
          organizer.contains(lowerCaseQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Results for '$searchQuery'")),
      body: searchResults.isEmpty
          ? Center(
              child: Text(
                "No results found for '$searchQuery'.\nTry a different keyword.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final event = searchResults[index];
                // Kategori sayfasındaki kart tasarımını yeniden kullanalım
                return _buildEventPreviewCard(context, event);
              },
            ),
    );
  }

  // Bu kart widget'ı category_events_page.dart dosyasındaki ile aynı
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
