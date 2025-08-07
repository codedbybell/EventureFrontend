import 'package:flutter/material.dart';
import 'dart:async';

// 🎨 Color Palette Definitions
const Color orangePalette = Color(0xFFFF9F1C);
const Color tealPalette = Color(0xFF56C1C2);
const Color salmonPalette = Color(0xFFF67280);
const Color darkCoralPalette = Color(0xFFEB5E55);
const Color lightYellowPalette = Color(0xFFFFE66D);

// 🖤 Alternatives for Black
const Color darkTextColor = Color(0xFF4E342E);
const Color lightBackground = Color(0xFFFFFBF5);
const Color darkBackground = Color(0xFF2c3e50);
const Color darkSurface = Color(0xFF34495e);

// --- LIGHT THEME ---
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: salmonPalette, // 🔁 Primary = Somon
  scaffoldBackgroundColor: lightBackground,

  colorScheme: const ColorScheme.light(
    primary: salmonPalette,
    onPrimary: Colors.white,
    secondary: tealPalette,
    onSecondary: Colors.white,
    tertiary: orangePalette, // 🔁 Tertiary = Turuncu
    onTertiary: Colors.white,
    error: darkCoralPalette,
    onError: Colors.white,
    background: lightBackground,
    onBackground: darkTextColor,
    surface: Colors.white,
    onSurface: darkTextColor,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: salmonPalette,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: salmonPalette,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: salmonPalette,
      foregroundColor: Colors.white,
    ),
  ),

  cardTheme: const CardThemeData(color: Colors.white, elevation: 1),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: darkTextColor),
    displayMedium: TextStyle(color: darkTextColor),
    displaySmall: TextStyle(color: darkTextColor),
    headlineMedium: TextStyle(color: darkTextColor),
    headlineSmall: TextStyle(color: darkTextColor),
    titleLarge: TextStyle(color: darkTextColor),
    bodyLarge: TextStyle(color: darkTextColor),
    bodyMedium: TextStyle(color: darkTextColor),
    labelLarge: TextStyle(color: Colors.white),
  ),
);

// --- DARK THEME ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: salmonPalette,
  scaffoldBackgroundColor: darkBackground,

  colorScheme: const ColorScheme.dark(
    primary: salmonPalette,
    onPrimary: darkTextColor,
    secondary: orangePalette,
    onSecondary: Colors.white,
    tertiary: tealPalette,
    onTertiary: Colors.white,
    error: darkCoralPalette,
    onError: Colors.white,
    background: darkBackground,
    onBackground: lightBackground,
    surface: darkSurface,
    onSurface: lightBackground,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurface,
    foregroundColor: salmonPalette,
    elevation: 0,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: salmonPalette,
    foregroundColor: darkTextColor,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: salmonPalette,
      foregroundColor: darkTextColor,
    ),
  ),

  cardTheme: const CardThemeData(color: darkSurface),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: lightBackground),
    displayMedium: TextStyle(color: lightBackground),
    displaySmall: TextStyle(color: lightBackground),
    headlineMedium: TextStyle(color: lightBackground),
    headlineSmall: TextStyle(color: lightBackground),
    titleLarge: TextStyle(color: lightBackground, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: lightBackground),
    bodyMedium: TextStyle(color: lightBackground),
    labelLarge: TextStyle(color: darkTextColor),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce Events App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // Görseldeki gibi koyu temayı zorunlu kıl
      home: const EcommerceHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// DUMMY DATA
final List<Map<String, String>> upcomingEvents = [
  {
    'image':
        'https://upload.wikimedia.org/wikipedia/en/7/79/Music_of_the_Spheres_World_Tour_Poster.png',
    'title': 'Coldplay Concert',
  },
  {
    'image':
        'https://i.milliyet.com.tr/MilliyetSanat640x412/2019/02/26/fft243_mf32581301.Jpeg',
    'title': 'Summer Fest',
  },
  {
    'image':
        'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800',
    'title': 'Indie Night',
  },
];

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

final List<Map<String, String>> popularEvents = [
  {
    'image': 'https://istanbulfestivali.com/home_concerts_2025.jpg',
    'title': 'Istanbul Festival',
  },
  {
    'image': 'https://iksv.org/i/content/21854_1_fm1366.jpg',
    'title': 'Filmekimi',
  },
  {
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLa-aGhiXWoqCrWCmFKZvODoURZBjU1ageLA&s',
    'title': 'Zeytinli Festival',
  },
  {
    'image':
        'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
    'title': 'Jazz Nights',
  },
];

class EcommerceHomePage extends StatefulWidget {
  const EcommerceHomePage({super.key});

  @override
  State<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends State<EcommerceHomePage> {
  int _currentBottomNavIndex = 0;
  final PageController _pageController = PageController();
  int _currentBannerPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Banner'ın otomatik kaymasını sağlayan zamanlayıcı
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentBannerPage < upcomingEvents.length - 1) {
        _currentBannerPage++;
      } else {
        _currentBannerPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentBannerPage,
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

  @override
  Widget build(BuildContext context) {
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
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(upcomingEvents[index]['image']!),
                    fit: BoxFit.cover,
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

  Widget _buildEventCategories(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: eventCategories.length,
        itemBuilder: (context, index) {
          final category = eventCategories[index];
          return Container(
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
          return Container(
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
          );
        },
      ),
    );
  }
}
