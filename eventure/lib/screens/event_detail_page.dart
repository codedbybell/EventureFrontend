// lib/screens/event_detail_page.dart (UPDATED IN ENGLISH)

import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.colorScheme.onBackground,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  event['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
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
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 16),

                  // Organizer Info
                  _buildInfoRow(
                    context,
                    icon: Icons.info_outline,
                    text: event['organizer'] ?? 'Not specified',
                    color: theme.colorScheme.onBackground.withOpacity(0.8),
                  ),
                  const SizedBox(height: 16),

                  // Title and Subtitle
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

                  // Details Box
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
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
                          text:
                              '${event['date'] ?? ''}  ${event['time'] ?? ''}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // UPDATED BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      // The 'label' is the main text, 'icon' is the icon.
                      label: const Text("Apply"),
                      icon: const Icon(Icons.arrow_forward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF6A4DBA,
                        ), // Purple color
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
