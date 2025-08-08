import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- RENK VE VERİ MODELLERİ ---

const Color orangePalette = Color(0xFFFF9F1C);
const Color tealPalette = Color(0xFF56C1C2);
const Color salmonPalette = Color(0xFFF67280);
const Color darkCoralPalette = Color(0xFFEB5E55);
const Color lightYellowPalette = Color(0xFFFFE66D);

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

  factory Etkinlik.fromJson(Map<String, dynamic> json) {
    return Etkinlik(
      title: json['title'],
      description: json['description'],
      location: json['location'],
      time: json['time'],
      categoryIcon: const Icon(Icons.event, color: Colors.grey, size: 24),
      cardColor: _mapColor(json['cardColor']),
      attendeeImageUrls: List<String>.from(json['attendeeImageUrls']),
    );
  }

  static Color _mapColor(String colorName) {
    switch (colorName) {
      case 'salmonPalette':
        return salmonPalette.withOpacity(0.3);
      case 'tealPalette':
        return tealPalette.withOpacity(0.3);
      case 'lightYellowPalette':
        return lightYellowPalette.withOpacity(0.5);
      case 'darkCoralPalette':
        return darkCoralPalette.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }
}

// --- GÜNLERE GÖRE AYRILMIŞ MANUEL ETKİNLİK VERİSİ ---
final Map<String, List<Etkinlik>> _manuelEtkinlikVerisi = {
  '1': [
    Etkinlik(
      title: 'Kodlama Maratonu',
      description: '24 saat sürecek hackathon. Yaratıcı projeler geliştir!',
      location: 'Teknoloji Merkezi',
      time: '09:00 AM - 09:00 AM (Ertesi Gün)',
      categoryIcon: const Icon(Icons.code, color: Colors.green, size: 24),
      cardColor: tealPalette.withOpacity(0.15),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/81.jpg',
        'https://randomuser.me/api/portraits/women/82.jpg',
        'https://randomuser.me/api/portraits/men/83.jpg',
      ],
    ),
  ],
  '3': [
    Etkinlik(
      title: 'Kaykay Buluşması',
      description: 'Tüm seviyeler için serbest stil ve sokak parkuru.',
      location: 'Merkez Skatepark',
      time: '02:00 PM - 05:00 PM',
      categoryIcon: const Icon(
        Icons.skateboarding,
        color: Colors.orange,
        size: 24,
      ),
      cardColor: lightYellowPalette.withOpacity(0.7),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/50.jpg',
        'https://randomuser.me/api/portraits/women/51.jpg',
      ],
    ),
  ],
  '5': [
    Etkinlik(
      title: 'E-Spor Turnuvası',
      description: 'Valorant 5v5 turnuvası. Büyük ödüller sizi bekliyor!',
      location: 'Nexus Arena',
      time: '12:30 PM - 08:00 PM',
      categoryIcon: const Icon(
        Icons.gamepad_outlined,
        color: Colors.red,
        size: 24,
      ),
      cardColor: salmonPalette.withOpacity(0.3),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/32.jpg',
        'https://randomuser.me/api/portraits/women/12.jpg',
        'https://randomuser.me/api/portraits/men/33.jpg',
        'https://randomuser.me/api/portraits/women/13.jpg',
      ],
    ),
    Etkinlik(
      title: 'Indie Müzik Gecesi',
      description: 'Yerel gruplardan canlı performanslar ve akustik setler.',
      location: 'Sahne Kafe',
      time: '09:00 PM - 11:45 PM',
      categoryIcon: const Icon(Icons.music_note, color: Colors.blue, size: 24),
      cardColor: tealPalette.withOpacity(0.3),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/women/44.jpg',
        'https://randomuser.me/api/portraits/men/45.jpg',
      ],
    ),
  ],
  '6': [],
  '10': [
    Etkinlik(
      title: 'Film Gecesi',
      description: 'Klasik filmlerden oluşan özel gösterim.',
      location: 'Sinema Salonu',
      time: '08:00 PM - 10:00 PM',
      categoryIcon: const Icon(
        Icons.local_movies,
        color: Colors.purple,
        size: 24,
      ),
      cardColor: darkCoralPalette.withOpacity(0.3),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/women/2.jpg',
      ],
    ),
  ],
  '15': [
    Etkinlik(
      title: 'Doğa Yürüyüşü',
      description: 'Şehir dışı orman parkurunda sabah yürüyüşü.',
      location: 'Çamlıca Ormanı',
      time: '08:00 AM - 12:00 PM',
      categoryIcon: const Icon(Icons.hiking, color: Colors.brown, size: 24),
      cardColor: lightYellowPalette.withOpacity(0.5),
      attendeeImageUrls: ['https://randomuser.me/api/portraits/women/10.jpg'],
    ),
  ],
  '20': [
    Etkinlik(
      title: 'Flutter Konferansı',
      description: 'Flutter geliştiricileri için seminer ve atölyeler.',
      location: 'Kongre Merkezi',
      time: '09:00 AM - 05:00 PM',
      categoryIcon: const Icon(
        Icons.laptop_chromebook,
        color: Colors.blue,
        size: 24,
      ),
      cardColor: tealPalette.withOpacity(0.5),
      attendeeImageUrls: [
        'https://randomuser.me/api/portraits/men/21.jpg',
        'https://randomuser.me/api/portraits/women/22.jpg',
        'https://randomuser.me/api/portraits/men/23.jpg',
        'https://randomuser.me/api/portraits/women/24.jpg',
        'https://randomuser.me/api/portraits/men/25.jpg',
      ],
    ),
  ],
};

// Ana uygulama başlatma noktası
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

// --- ANA EKRAN WIDGET'I ---
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, List<Etkinlik>> _etkinlikVeriTabani = _manuelEtkinlikVerisi;

  String _selectedDate = DateTime.now().day.toString();
  int _selectedMonth = DateTime.now().month;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
            ),
            if (eventsForSelectedDay.isEmpty && !_isLoading)
              const Expanded(
                child: Center(
                  child: Text(
                    'There are no events on the selected day.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: darkCoralPalette,
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

// --- YARDIMCI WIDGET'LAR ---

class _CalendarHeader extends StatefulWidget {
  final String selectedDate;
  final int selectedMonth;
  final Function(String) onDateSelected;

  const _CalendarHeader({
    Key? key,
    required this.selectedDate,
    required this.selectedMonth,
    required this.onDateSelected,
  }) : super(key: key);

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
    'Sat',
  ];

  void _toggleCalendarView() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: _toggleCalendarView,
              ),
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
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
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
              mainAxisSpacing: 5,
            ),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              if (date.isEmpty) {
                return Container();
              }
              return _DateWidget(
                date: date,
                dots: _manuelEtkinlikVerisi[date]?.length ?? 0,
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
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    final startOfWeekIndex = (selectedIndex ~/ 7) * 7;
    final endOfWeekIndex = startOfWeekIndex + 7;

    List<String> currentWeekDates = allDates.sublist(
      startOfWeekIndex,
      endOfWeekIndex > allDates.length ? allDates.length : endOfWeekIndex,
    );

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

  const _DateWidget({
    Key? key,
    required this.date,
    required this.isSelected,
    required this.onDateSelected,
    this.dots = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (date.isEmpty) {
      return Container();
    }
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? darkCoralPalette : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tarih Numarası
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            // Noktalar için sabit yükseklikte bir alan.
            // Bu sayede etkinlik olmasa bile boşluk kalır ve hizalama bozulmaz.
            SizedBox(
              height: 5, // Bir noktanın yüksekliği kadar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  // YENİ MANTIK: Etkinlik sayısı (dots) 0'dan büyükse 1, değilse 0 döndür.
                  // Bu sayede her zaman en fazla bir nokta gösterilir...
                  dots > 0 ? 1 : 0,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : orangePalette,
                      shape: BoxShape.circle,
                    ),
                  ),
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
        color: event.cardColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
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
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(child: event.categoryIcon),
              ),
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
    return Row(
      children: [
        Icon(icon, color: tealPalette, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
            radius: 13,
            backgroundImage: NetworkImage(attendeeUrls[index]),
          ),
        ),
      ),
    );
    return SizedBox(
      height: 30,
      width: (attendeeUrls.length * 22.0) + 8,
      child: Stack(children: avatars),
    );
  }
}
