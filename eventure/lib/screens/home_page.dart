// lib/screens/home_page.dart (İSTEKLERİNİZ EKLENMİŞ GÜNCEL HALİ)

import 'dart:async';
import 'package:flutter/material.dart';

// İSTEDİĞİNİZ YENİ SAYFALAR İÇİN IMPORT'LAR EKLENDİ
import 'package:eventure/screens/all_categories_page.dart';
import 'package:eventure/screens/all_popular_events_page.dart';

import 'package:eventure/screens/category_events_page.dart';
import 'package:eventure/screens/event_detail_page.dart';
import 'package:eventure/screens/history_screen.dart';
import 'package:eventure/screens/profil_edit_screen.dart';

// --- Veri Modelleri (Değişiklik yok) ---
final List<Map<String, dynamic>> allEvents = [
  // ... (Veri listesi olduğu gibi kalacak)
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
    'category': 'Concerts',
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
    'category': 'Concerts',
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
    'category': 'Conferences',
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
    'category': 'Concerts',
  },
  {
    'image': 'https://istanbulfestivali.com/home_concerts_2025.jpg',
    'title': 'Istanbul Festival',
    'subtitle': 'The rhythm of the city is here',
    'location': 'Festival Park, Yenikapi',
    'date': 'Aug 6-17, 2025',
    'time': '05:00 PM - 12:00 AM',
    'tags': ['Music', 'Festival', 'Istanbul'],
    'organizer': 'Ministry of Culture and Tourism',
    'category': 'Concerts',
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
    'category': 'Cinema',
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
    'category': 'Concerts',
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
    'category': 'Concerts',
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
    'category': 'Nature',
  },
];
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

// --- Ana Sayfa Widget'ı ---
class EcommerceHomePage extends StatefulWidget {
  const EcommerceHomePage({super.key});
  @override
  State<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends State<EcommerceHomePage> {
  // --- State Değişkenleri (Değişiklik yok) ---
  int _currentBottomNavIndex = 0;
  final PageController _pageController = PageController();
  int _currentBannerPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

  // --- Lifecycle Metotları (Değişiklik yok) ---
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
    _searchController.addListener(() {
      if (_searchController.text.isEmpty && _searchQuery.isNotEmpty) {
        _updateSearchResults('');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // --- Fonksiyonlar ve Metotlar (YENİ METOTLAR EKLENDİ) ---
  void _updateSearchResults(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _searchResults = allEvents.where((event) {
          final title = event['title'].toString().toLowerCase();
          final subtitle = event['subtitle'].toString().toLowerCase();
          final organizer = event['organizer'].toString().toLowerCase();
          final category = event['category'].toString().toLowerCase();
          return title.contains(lowerCaseQuery) ||
              subtitle.contains(lowerCaseQuery) ||
              organizer.contains(lowerCaseQuery) ||
              category.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
  }

  void _navigateToDetail(Map<String, dynamic> eventData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: eventData),
      ),
    );
  }

  void _navigateToCategoryPage(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEventsPage(categoryName: categoryName),
      ),
    );
  }

  // YENİ EKLENDİ: "TÜMÜNÜ GÖR" İÇİN NAVİGASYON FONKSİYONLARI
  void _navigateToAllCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllCategoriesPage()),
    );
  }

  void _navigateToAllPopularEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllPopularEventsPage()),
    );
  }

  // --- Build Metotları (Değişiklik yok) ---
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      const HistoryScreen(),
      ProfileEditScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_currentBottomNavIndex == 0 && _searchQuery.isNotEmpty) {
          _clearSearch();
          return false;
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onBackground.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(index: _currentBottomNavIndex, children: pages),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: _searchQuery.isEmpty
              ? _buildHomePageContent()
              : _buildSearchResultsList(),
        ),
      ],
    );
  }

  // _buildHomePageContent GÜNCELLENDİ
  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionHeader(context, title: "Upcoming Events"),
          _buildUpcomingEventsSlider(context),
          const SizedBox(height: 24),
          // "onSeeAllTapped" fonksiyonu eklendi
          _buildSectionHeader(
            context,
            title: "Events",
            showArrow: true,
            onSeeAllTapped: _navigateToAllCategories,
          ),
          const SizedBox(height: 16),
          _buildEventCategories(context),
          const SizedBox(height: 24),
          // "onSeeAllTapped" fonksiyonu eklendi
          _buildSectionHeader(
            context,
            title: "Popular Events",
            showArrow: true,
            onSeeAllTapped: _navigateToAllPopularEvents,
          ),
          const SizedBox(height: 16),
          _buildPopularEvents(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList() {
    if (_searchResults.isEmpty) {
      return Center(child: Text("No results found for '$_searchQuery'"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final event = _searchResults[index];
        return _buildEventPreviewCard(context, event);
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: TextField(
        controller: _searchController,
        onChanged: _updateSearchResults,
        decoration: InputDecoration(
          hintText: 'Search for events, artists...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEventPreviewCard(
    BuildContext context,
    Map<String, dynamic> event,
  ) {
    return GestureDetector(
      onTap: () => _navigateToDetail(event),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      event['location'],
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // _buildSectionHeader GÜNCELLENDİ
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    bool showArrow = false,
    VoidCallback? onSeeAllTapped,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (showArrow && onSeeAllTapped != null)
            InkWell(
              onTap: onSeeAllTapped,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          // Sadece ok gösterilmesi isteniyorsa (tıklama fonksiyonu yoksa)
          if (showArrow && onSeeAllTapped == null)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward_ios, size: 16),
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
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

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
