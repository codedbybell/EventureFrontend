import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // We'll use a consistent color for the background and container
    const Color customBackgroundColor = Color(0xFFF3F0F4);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: customBackgroundColor,
      appBar: AppBar(
        backgroundColor: customBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          event['title'] ?? 'Event Detail',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
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
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  event['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                  // We'll use the same consistent color here
                  color: customBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // Make the shadow more subtle
                      color: Colors.grey.withOpacity(0.1),
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
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Apply"),
                  icon: const Icon(Icons.arrow_forward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A4DBA),
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
