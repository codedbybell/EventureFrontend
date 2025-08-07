// lib/screens/home_page.dart (UPDATED)

import 'package:eventure/screens/category_events_page.dart'; // YENİ EKLENDİ
import 'package:eventure/screens/event_detail_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// --- DATA MODIFIED WITH 'category' KEY ---
// This master list will be used by the category page.
final List<Map<String, dynamic>> allEvents = [
  // Upcoming Events
  {
    'image':
        'https://upload.wikimedia.org/wikipedia/en/7/79/Music_of_the_Spheres_World_Tour_Poster.png',
    'title': 'Coldplay Concert',
    'subtitle': 'Music of the Spheres World Tour',
    'location': 'Olympic Stadium, Athens',
    'date': 'June 8-9, 2024',
    'time': '08:00 PM - 11:00 PM',
    'tags': ['Music', 'Pop', 'World Tour'],
    'organizer': 'Live Nation',
    'category': 'Concerts', // EKLENDİ
  },
  {
    'image':
        'https://i.milliyet.com.tr/MilliyetSanat640x412/2019/02/26/fft243_mf32581301.Jpeg',
    'title': 'Summer Fest',
    'subtitle': 'The hottest festival of the year',
    'location': 'Life Park, Istanbul',
    'date': 'Aug 15-17, 2025',
    'time': '04:00 PM - 02:00 AM',
    'tags': ['Music', 'Festival', 'Summer'],
    'organizer': 'Eventure Org.',
    'category': 'Concerts', // EKLENDİ
  },
  {
    'image':
        'https://ce.yildiz.edu.tr:8080/news-images/62bc056f2cf4630012f603d0/teknofest2025-d22ec2cc-2612-4c47-897e-7d5024233431.jpg',
    'title': 'Teknofest',
    'subtitle': 'National Technology Initiative',
    'location': 'Ataturk Airport, Istanbul',
    'date': 'Apr 27 - May 1, 2025',
    'time': '10:00 AM - 06:00 PM',
    'tags': ['Technology', 'Festival', 'Aviation', 'Free'],
    'organizer': 'T3 Foundation',
    'category': 'Conferences', // EKLENDİ
  },
  {
    'image':
        'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800',
    'title': 'Indie Night',
    'subtitle': 'Independent voices on stage',
    'location': 'Zorlu PSM, Istanbul',
    'date': 'Sep 25, 2025',
    'time': '09:00 PM - 12:00 AM',
    'tags': ['Music', 'Indie', 'Concert'],
    'organizer': 'PSM Music',
    'category': 'Concerts', // EKLENDİ
  },
  // Popular Events
  {
    'image': 'https://istanbulfestivali.com/home_concerts_2025.jpg',
    'title': 'Istanbul Festival',
    'subtitle': 'The rhythm of the city is here',
    'location': 'Festival Park, Yenikapi',
    'date': 'Aug 6-17, 2025',
    'time': '05:00 PM - 12:00 AM',
    'tags': ['Music', 'Festival', 'Istanbul'],
    'organizer': 'Ministry of Culture and Tourism',
    'category': 'Concerts', // EKLENDİ
  },
  {
    'image': 'https://iksv.org/i/content/21854_1_fm1366.jpg',
    'title': 'Filmekimi',
    'subtitle': 'The best films of autumn',
    'location': 'Atlas 1948 & Kadikoy Cinema',
    'date': 'Oct 4-13, 2025',
    'time': '11:00 AM - 11:30 PM',
    'tags': ['Cinema', 'Festival', 'Art'],
    'organizer': 'IKSV',
    'category': 'Cinema', // EKLENDİ
  },
  {
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLa-aGhiXWoqCrWCmFKZvODoURZBjU1ageLA&s',
    'title': 'Zeytinli Rock Fest',
    'subtitle': 'Turkey\'s biggest rock festival',
    'location': 'Burhaniye, Balikesir',
    'date': 'Sep 2-6, 2025',
    'time': '03:00 PM - 03:00 AM',
    'tags': ['Music', 'Rock', 'Festival'],
    'organizer': 'Milyon Production',
    'category': 'Concerts', // EKLENDİ
  },
  {
    'image':
        'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
    'title': 'Jazz Nights',
    'subtitle': 'The magical notes of jazz',
    'location': 'Nardis Jazz Club, Galata',
    'date': 'Every Friday',
    'time': '09:30 PM - 12:00 AM',
    'tags': ['Music', 'Jazz', 'Live'],
    'organizer': 'Nardis',
    'category': 'Concerts', // EKLENDİ
  },
  {
    'image':
        'https://s1.wklcdn.com/image_165/4952886/68860315/45329743Master.jpg',
    'title': 'Hiking Adventure',
    'subtitle': 'Explore the Belgrad Forest',
    'location': 'Belgrad Forest, Istanbul',
    'date': 'Every Weekend',
    'time': '09:00 AM - 04:00 PM',
    'tags': ['Nature', 'Hiking', 'Outdoor'],
    'organizer': 'Nature Lovers Club',
    'category': 'Nature', // EKLENDİ
  },
];

// These lists are now filtered from the master list for the home page UI
final List<Map<String, dynamic>> upcomingEvents = allEvents
    .where(
      (e) => [
        'Coldplay Concert',
        'Summer Fest',
        'Teknofest',
        'Indie Night',
      ].contains(e['title']),
    )
    .toList();
final List<Map<String, dynamic>> popularEvents = allEvents
    .where(
      (e) => [
        'Istanbul Festival',
        'Filmekimi',
        'Zeytinli Rock Fest',
        'Jazz Nights',
      ].contains(e['title']),
    )
    .toList();

final List<Map<String, String>> eventCategories = [
  {
    'image':
        'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=800&auto=format&fit=crop',
    'label': 'Concerts',
  },
  {
    'image':
        'https://images.unsplash.com/photo-1574267432553-4b4628081c31?w=800&auto=format&fit=crop',
    'label': 'Cinema',
  },
  {
    'image':
        'https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=800&auto=format&fit=crop',
    'label': 'Nature',
  },
  {
    'image':
        'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=800&auto=format&fit=crop',
    'label': 'Conferences',
  },
];

class EcommerceHomePage extends StatefulWidget {
  const EcommerceHomePage({super.key});

  @override
  State<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends State<EcommerceHomePage> {
  // ... (initState, dispose, and other methods remain the same)
  int _currentBottomNavIndex = 0;
  final PageController _pageController = PageController();
  int _currentBannerPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted) return;
      int newPage = (_currentBannerPage + 1) % upcomingEvents.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          newPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDetail(Map<String, dynamic> eventData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: eventData),
      ),
    );
  }

  // YENİ EKLENDİ
  void _navigateToCategoryPage(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEventsPage(categoryName: categoryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (Scaffold and other widgets remain the same)
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onBackground.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 24),
              _buildSectionHeader(context, title: "Upcoming Events"),
              _buildUpcomingEventsSlider(context),
              const SizedBox(height: 24),
              _buildSectionHeader(context, title: "Events", showArrow: true),
              const SizedBox(height: 16),
              _buildEventCategories(context),
              const SizedBox(height: 24),
              _buildSectionHeader(
                context,
                title: "Popular Events",
                showArrow: true,
              ),
              const SizedBox(height: 16),
              _buildPopularEvents(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // GÜNCELLENDİ: Kategori ikonları artık tıklanabilir
  Widget _buildEventCategories(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: eventCategories.length,
        itemBuilder: (context, index) {
          final category = eventCategories[index];
          return GestureDetector(
            onTap: () => _navigateToCategoryPage(category['label']!),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(category['image']!),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['label']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Diğer build metotları (_buildSearchBar, _buildSectionHeader, etc.) değişmeden kalır ---
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    bool showArrow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSlider(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: upcomingEvents.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerPage = index;
              });
            },
            itemBuilder: (context, index) {
              final event = upcomingEvents[index];
              return GestureDetector(
                onTap: () => _navigateToDetail(event),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(event['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(upcomingEvents.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentBannerPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentBannerPage == index
                    ? Theme.of(context).colorScheme.onBackground
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPopularEvents(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: popularEvents.length,
        itemBuilder: (context, index) {
          final event = popularEvents[index];
          return GestureDetector(
            onTap: () => _navigateToDetail(event),
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      event['image']!,
                      height: 180,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: 150,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['title']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
