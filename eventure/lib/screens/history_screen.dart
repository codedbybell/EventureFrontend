import 'package:eventure/theme/theme.dart';
import 'package:flutter/material.dart';
// Gerekli import'lar aynı kalıyor
import '../models/event_model.dart';
import '../services/event_services.dart';

// --- RENK PALETİ VE YARDIMCILAR ---

// Fallback (yedek) paletimiz hala burada duruyor.
final List<Color> cardColorPalette = [
  const Color(0xFF56C1C2).withOpacity(0.3), // tealPalette
  const Color(0xFFF67280).withOpacity(0.3), // salmonPalette
  const Color(0xFFFFE66D).withOpacity(0.6), // lightYellowPalette
  const Color(0xFFEB5E55).withOpacity(0.3), // darkCoralPalette
  const Color(0xFFC06C84).withOpacity(0.3),
  const Color(0xFF6C5B7B).withOpacity(0.3),
  const Color(0xFF355C7D).withOpacity(0.3),
];

// YENİ: Hex renk kodunu Flutter'ın Color nesnesine çeviren yardımcı fonksiyon.
Color _colorFromHex(String hexColor) {
  try {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor; // Opaklığı tam yaparak 8 haneye tamamla
    }
    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    // Hatalı bir format gelirse varsayılan bir renk döndür.
    return Colors.grey.withOpacity(0.3);
  }
}

// UI Modelimiz
class Etkinlik {
  final String title;
  final String description;
  final String location;
  final String time;
  final Widget categoryIcon;
  final Color cardColor;
  final List<String> attendeeImageUrls;

  Etkinlik({
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.categoryIcon,
    required this.cardColor,
    required this.attendeeImageUrls,
  });

  // DEĞİŞİKLİK: Bu factory, hibrit renk mantığını uygular.
  factory Etkinlik.fromEventModel(Event event) {
    final String displayTime =
        event.time.length > 5 ? event.time.substring(0, 5) : event.time;

    // HİBRİT RENK SEÇİMİ MANTIĞI
    Color finalCardColor;
    if (event.color != null && event.color!.isNotEmpty) {
      // 1. Öncelik: Backend'den gelen rengi kullan.
      finalCardColor =
          _colorFromHex(event.color!).withOpacity(0.4); // Opaklık ekleyelim
    } else {
      // 2. Öncelik (Fallback): Backend'den renk gelmezse, paletten ID'ye göre ata.
      finalCardColor = cardColorPalette[event.id % cardColorPalette.length];
    }

    return Etkinlik(
      title: event.title,
      description: event.description,
      location: event.location,
      time: displayTime,
      categoryIcon: _mapCategoryToIcon(event.categoryName),
      cardColor: finalCardColor, // Hesaplanan son rengi ata.
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/81.jpg',
        'https://randomuser.me/api/portraits/women/82.jpg',
      ],
    );
  }

  static Widget _mapCategoryToIcon(String category) {
    switch (category.toLowerCase()) {
      case 'teknoloji':
        return const Icon(Icons.code, color: Colors.green, size: 24);
      case 'spor':
        return const Icon(Icons.skateboarding, color: Colors.orange, size: 24);
      case 'e-spor':
        return const Icon(Icons.gamepad_outlined, color: Colors.red, size: 24);
      case 'müzik':
        return const Icon(Icons.music_note, color: Colors.blue, size: 24);
      case 'sanat':
      case 'bed cinema':
        return const Icon(Icons.palette, color: Colors.purple, size: 24);
      default:
        return const Icon(Icons.event, color: Colors.grey, size: 24);
    }
  }
}

// Geri kalan kodun TAMAMI AYNI kalabilir.
// main, MyApp, HistoryScreen, _CalendarHeader, _DateWidget, _EventCard, vb.
// widget'larda başka hiçbir değişiklik yapmanıza gerek yok.
// ...
// ... (Buraya bir önceki yanıttaki geri kalan tüm kodları yapıştırabilirsiniz)
// ...

// ... KODUN GERİ KALANI ...
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HistoryScreen(),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, List<Etkinlik>> _etkinlikVeriTabani = {};
  String _selectedDate = DateTime.now().day.toString();
  final int _selectedMonth = DateTime.now().month;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndProcessEvents();
  }

  Future<void> _fetchAndProcessEvents() async {
    try {
      final eventService = EventService();
      final List<Event> allEvents = await eventService.fetchEvents();
      final Map<String, List<Etkinlik>> processedEvents = {};

      for (final event in allEvents) {
        DateTime eventDate;
        try {
          eventDate = DateTime.parse(event.date);
        } catch (e) {
          debugPrint(
              "Hatalı tarih formatı: ${event.date} - Etkinlik atlandı: ${event.title}");
          continue;
        }
        if (eventDate.month == _selectedMonth) {
          final day = eventDate.day.toString();
          final uiEvent = Etkinlik.fromEventModel(event);
          if (processedEvents.containsKey(day)) {
            processedEvents[day]!.add(uiEvent);
          } else {
            processedEvents[day] = [uiEvent];
          }
        }
      }

      if (mounted) {
        setState(() {
          _etkinlikVeriTabani = processedEvents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint("Etkinlikler getirilirken hata oluştu: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Etkinlikler yüklenemedi: $e')),
        );
      }
    }
  }

  void _onDateSelected(String date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _etkinlikVeriTabani[_selectedDate] ?? [];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _CalendarHeader(
              selectedDate: _selectedDate,
              selectedMonth: _selectedMonth,
              onDateSelected: _onDateSelected,
              eventsData: _etkinlikVeriTabani,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: darkCoralPalette))
                  : eventsForSelectedDay.isEmpty
                      ? const Center(
                          child: Text(
                            'Seçili günde etkinlik bulunmuyor.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: eventsForSelectedDay.length,
                          itemBuilder: (context, index) {
                            final event = eventsForSelectedDay[index];
                            return _EventCard(event: event);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatefulWidget {
  final String selectedDate;
  final int selectedMonth;
  final Function(String) onDateSelected;
  final Map<String, List<Etkinlik>> eventsData;
  const _CalendarHeader(
      {Key? key,
      required this.selectedDate,
      required this.selectedMonth,
      required this.onDateSelected,
      required this.eventsData})
      : super(key: key);
  @override
  _CalendarHeaderState createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<_CalendarHeader> {
  bool _isExpanded = false;
  final List<String> _dayNames = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  void _toggleCalendarView() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  String _getMonthName(int month) {
    const monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month];
  }

  int _getNumberOfDaysInMonth(int month, int year) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) return 29;
      return 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  List<String> get _datesForCurrentMonth {
    final year = DateTime.now().year;
    final month = widget.selectedMonth;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = _getNumberOfDaysInMonth(month, year);
    final List<String> dates = [];
    final firstWeekdayOffset = firstDayOfMonth.weekday % 7;
    for (int i = 0; i < firstWeekdayOffset; i++) {
      dates.add('');
    }
    for (int i = 1; i <= daysInMonth; i++) {
      dates.add(i.toString());
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${_getMonthName(widget.selectedMonth)} ${DateTime.now().year}',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              IconButton(
                  icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onSurface),
                  onPressed: _toggleCalendarView),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? screenHeight * 0.35 : screenHeight * 0.12,
            child: _isExpanded
                ? _buildCalendarGrid(_datesForCurrentMonth)
                : _buildWeeklyCalendar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<String> dates) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: _dayNames
                .map((day) => Expanded(
                      child: Center(
                        child: Text(day,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500)),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              if (date.isEmpty) return Container();
              return _DateWidget(
                date: date,
                dots: widget.eventsData[date]?.length ?? 0,
                isSelected: widget.selectedDate == date,
                onDateSelected: widget.onDateSelected,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar() {
    final allDates = _datesForCurrentMonth;
    int selectedIndex = allDates.indexOf(widget.selectedDate);
    if (selectedIndex == -1) {
      selectedIndex = allDates.indexOf(DateTime.now().day.toString());
    }
    if (selectedIndex == -1) selectedIndex = 0;
    final startOfWeekIndex = (selectedIndex ~/ 7) * 7;
    final endOfWeekIndex = startOfWeekIndex + 7;
    List<String> currentWeekDates = allDates.sublist(startOfWeekIndex,
        endOfWeekIndex > allDates.length ? allDates.length : endOfWeekIndex);
    while (currentWeekDates.length < 7) {
      currentWeekDates.add('');
    }
    return _buildCalendarGrid(currentWeekDates);
  }
}

class _DateWidget extends StatelessWidget {
  final String date;
  final bool isSelected;
  final int dots;
  final Function(String) onDateSelected;
  const _DateWidget(
      {Key? key,
      required this.date,
      required this.isSelected,
      required this.onDateSelected,
      this.dots = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const Color darkCoralPalette = Color(0xFFEB5E55);
    const Color orangePalette = Color(0xFFFF9F1C);
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? darkCoralPalette : Colors.transparent,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            SizedBox(
              height: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  dots > 0 ? 1 : 0,
                  (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : orangePalette,
                          shape: BoxShape.circle)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Etkinlik event;
  const _EventCard({Key? key, required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: event.cardColor, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(event.description,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle),
                  child: Center(child: event.categoryIcon)),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on_outlined, text: event.location),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoRow(icon: Icons.access_time_outlined, text: event.time),
              _Attendees(attendeeUrls: event.attendeeImageUrls),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({Key? key, required this.icon, required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const Color tealPalette = Color(0xFF56C1C2);
    return Row(
      children: [
        Icon(icon, color: tealPalette, size: 20),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }
}

class _Attendees extends StatelessWidget {
  final List<String> attendeeUrls;
  const _Attendees({Key? key, required this.attendeeUrls}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final avatars = List.generate(
      attendeeUrls.length,
      (index) => Positioned(
        left: (index * 22.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: CircleAvatar(
              radius: 13, backgroundImage: NetworkImage(attendeeUrls[index])),
        ),
      ),
    );
    return SizedBox(
        height: 30,
        width: (attendeeUrls.length * 22.0) + 8,
        child: Stack(children: avatars));
  }
}
