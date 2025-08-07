// lib/main.dart (GÜNCELLENMİŞ HALİ)

import 'package:eventure/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;
import 'package:eventure/theme/theme_notifier.dart'; // YENİ IMPORT

import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// UYGULAMA GENELİNDE KULLANILACAK GLOBAL TEMA YÖNETİCİSİ
final themeNotifier = ThemeNotifier();

void main() async {
  // main fonksiyonunu async yaparak await kullanabilir hale getiriyoruz.
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulama başlamadan önce kayıtlı temayı yüklüyoruz.
  await themeNotifier.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp'ı, tema değişikliklerini dinleyebilmesi için
    // ValueListenableBuilder ile sarıyoruz.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier.themeMode,
      builder: (_, currentMode, __) {
        // Mevcut MaterialApp yapınız burada korunuyor.
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // themeMode artık sabit değil, notifier'dan gelen dinamik bir değer.
          themeMode: currentMode,
          title: 'Eventure',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/history': (context) => const HistoryScreen(),
            '/home': (context) => const EcommerceHomePage(),
          },
        );
      },
    );
  }
}
