import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventure/models/event_model.dart';
import 'package:eventure/services/event_services.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late Future<Event> _eventFuture;
  final EventService _eventService = EventService();
  bool _isProcessing =
      false; // Butona tekrar tekrar basılmasını engellemek için

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  void _fetchEventDetails() {
    if (!mounted) return;
    setState(() {
      _eventFuture = _eventService.fetchEventById(widget.eventId);
    });
  }

  void _toggleBooking(Event currentEvent) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final action = currentEvent.isBooked ? "Cancelling" : "Booking";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action for ${currentEvent.title}...')),
    );

    try {
      if (currentEvent.isBooked) {
        await _eventService.unbookEvent(currentEvent.id);
      } else {
        await _eventService.bookEvent(currentEvent.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$action successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _fetchEventDetails();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event>(
      future: _eventFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isProcessing) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError && !_isProcessing) {
          return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(
                  child: Text('Failed to load event: ${snapshot.error}')));
        }

        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final event = snapshot.data!;

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        String formattedDate = _formatDate(event.date);
        String formattedTime = _formatTime(context, event.time);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Event Detail',
                style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, event, textTheme),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
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
                                      color: colorScheme.onPrimaryContainer)))
                              .toList(),
                        ),
                      if (event.tags.isNotEmpty) const SizedBox(height: 24),
                      Text('About this event',
                          style: textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(event.description,
                          style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.7),
                              height: 1.5)),
                      const SizedBox(height: 24),
                      _buildInfoBox(context, formattedDate, formattedTime,
                          event, colorScheme),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: _buildDynamicBookingButton(context, event),
          ),
        );
      },
    );
  }

  // --- Yardımcı Widget'lar ---

  Widget _buildDynamicBookingButton(BuildContext context, Event event) {
    final bool isBooked = event.isBooked;
    final String buttonText = isBooked ? "Cancel Booking" : "Book Now";
    final Gradient buttonGradient = isBooked
        ? const LinearGradient(colors: [
            Color.fromARGB(255, 244, 91, 80),
            Color.fromARGB(255, 222, 63, 52)
          ])
        : const LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)]);

    return ElevatedButton(
      onPressed: _isProcessing ? null : () => _toggleBooking(event),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
          maximumSize: const Size(double.infinity, 60),
          shadowColor: (isBooked ? Colors.red : const Color(0xFFFF6B9D))
              .withOpacity(0.5)),
      child: Ink(
        decoration: BoxDecoration(
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
              : Text(
                  buttonText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

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
          if (event.capacity > 0) ...[
            const Divider(height: 24),
            _buildInfoRow(context,
                icon: Icons.people_outline,
                text: '${event.bookingCounts} / ${event.capacity} Booked'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String text}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
