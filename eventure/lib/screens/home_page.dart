import 'dart:async';
import 'package:flutter/material.dart';

import 'package:eventure/screens/all_categories_page.dart';
import 'package:eventure/screens/all_popular_events_page.dart';
import 'package:eventure/screens/category_events_page.dart';
import 'package:eventure/screens/event_detail_page.dart';
import 'package:eventure/screens/history_screen.dart';
import 'package:eventure/screens/profil_edit_screen.dart';
import '../models/event_model.dart';
import '../services/event_services.dart';
import '../models/category_model.dart';

// --- Ana Sayfa Widget'ı ---
class EcommerceHomePage extends StatefulWidget {
  const EcommerceHomePage({super.key});
  @override
  State<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends State<EcommerceHomePage> {
  // --- State Değişkenleri ---
  int _currentBottomNavIndex = 0;
  final PageController _pageController = PageController();
  int _currentBannerPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Event> _allFetchedEvents = [];
  List<Map<String, dynamic>> _searchResults = [];

  // --- Future Değişkenleri (API'den veri beklemek için) ---
  late Future<List<Event>> _futureEvents;
  late Future<List<Event>> _futurePopularEvents;
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();

    // Servis çağrılarını başlatıyoruz
    final eventService = EventService();
    _futureEvents = eventService.fetchEvents();
    _futurePopularEvents = eventService.fetchPopularEvents();
    _categoriesFuture = eventService.fetchCategories();

    // Banner zamanlayıcısını başlatıyoruz (güvenli ve dinamik)
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted || !_pageController.hasClients || _allFetchedEvents.isEmpty)
        return;
      int newPage = (_currentBannerPage + 1) % _allFetchedEvents.length;
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });

    // Arama kutusu dinleyicisi
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

  // --- Fonksiyonlar ve Metotlar ---
  void _updateSearchResults(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _searchResults = _allFetchedEvents
            .where(
              (event) =>
                  event.title.toLowerCase().contains(lowerCaseQuery) ||
                  event.description.toLowerCase().contains(lowerCaseQuery) ||
                  event.organizerUsername.toLowerCase().contains(
                    lowerCaseQuery,
                  ) ||
                  event.categoryId.toString().toLowerCase().contains(
                    lowerCaseQuery,
                  ),
            )
            .map((event) => event.toJson())
            .toList();
      }
    });
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    _updateSearchResults('');
  }

  void _navigateToDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
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

  // --- Build Metotları ---
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
          onTap: (index) => setState(() => _currentBottomNavIndex = index),
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

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionHeader(context, title: "Upcoming Events"),
          _buildUpcomingEventsSlider(context),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            title: "Categories",
            showArrow: true,
            onSeeAllTapped: _navigateToAllCategories,
          ),
          const SizedBox(height: 16),
          _buildEventCategories(context),
          const SizedBox(height: 24),
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
        // <<< DÜZELTME 5: Arama sonuçları için de Event nesnesi kullan
        final event = Event.fromJson(_searchResults[index]);
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
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEventPreviewCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () => _navigateToDetail(event),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0, left: 4, right: 4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Row(
          children: [
            Image.network(
              event.image,
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
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.location,
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
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSlider(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No upcoming events found.")),
          );
        }

        final events = snapshot.data!;
        if (_allFetchedEvents.isEmpty) {
          _allFetchedEvents = events;
        }

        return Column(
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: events.length,
                onPageChanged: (index) =>
                    setState(() => _currentBannerPage = index),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetail(event),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(event.image),
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
              children: List.generate(events.length, (index) {
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
      },
    );
  }

  Widget _buildEventCategories(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 100,
            child: Center(child: Text("Categories could not be loaded.")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("No categories found.")),
          );
        } else {
          final categories = snapshot.data!;
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => _navigateToCategoryPage(category.name),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: NetworkImage(category.image),
                          onBackgroundImageError:
                              (_, __) {}, // Hata durumunda boş bırak
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
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
      },
    );
  }

  Widget _buildPopularEvents(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _futurePopularEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 220,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text("No popular events found.")),
          );
        }

        final events = snapshot.data!;
        // Popüler etkinlikleri de tüm etkinlikler listesine ekleyelim ki arama sonuçlarında çıksın
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              for (var event in events) {
                if (!_allFetchedEvents.any((e) => e.title == event.title)) {
                  _allFetchedEvents.add(event);
                }
              }
            });
          }
        });

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
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
                          event.image,
                          height: 180,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.title,
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
      },
    );
  }
}
