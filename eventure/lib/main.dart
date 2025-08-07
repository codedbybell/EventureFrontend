import 'package:eventure/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;

// Yeni ekranımızı import edelim
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
// theme.dart zaten yukarıda AppTheme olarak import edilmiş, tekrar gerek yok.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Eventure',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // YENİ ROUTE'U BURAYA EKLEYİN
        '/history': (context) => const HistoryScreen(),
        '/home': (context) => EcommerceHomePage(),
      },
    );
  }
}
