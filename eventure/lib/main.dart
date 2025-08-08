import 'package:eventure/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;
import 'package:eventure/theme/theme_notifier.dart'; // Tema yönetimi için
import 'package:get/get.dart'; // Çoklu dil desteği için
import 'package:eventure/localization/localization_service.dart'; // Dil servisi için
import 'package:shared_preferences/shared_preferences.dart'; // Dil tercihini kaydetmek için

import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// UYGULAMA GENELİNDE KULLANILACAK GLOBAL TEMA YÖNETİCİSİ
final themeNotifier = ThemeNotifier();

void main() async {
  // Flutter binding'lerinin hazır olduğundan emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Kayıtlı tema modunu yükle (Aydınlık/Karanlık)
  await themeNotifier.loadTheme();

  // 2. Kayıtlı dil tercihini yükle
  final prefs = await SharedPreferences.getInstance();
  final String languageCode = prefs.getString('language_code') ?? 'en'; // Varsayılan dil 'en'

  // Uygulamayı, başlangıç diliyle birlikte çalıştır
  runApp(MyApp(initialLanguageCode: languageCode));
}

class MyApp extends StatelessWidget {
  final String initialLanguageCode;

  const MyApp({
    super.key,
    required this.initialLanguageCode,
  });

  @override
  Widget build(BuildContext context) {
    // MaterialApp'ı, tema değişikliklerini dinleyebilmesi için
    // ValueListenableBuilder ile sarıyoruz.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier.themeMode,
      builder: (_, currentMode, __) {
        
        // ValueListenableBuilder'ın içine GetMaterialApp'ı yerleştiriyoruz.
        // Böylece hem tema yönetimi hem de dil yönetimi birlikte çalışır.
        return GetMaterialApp(
          // --- Çoklu Dil Desteği Ayarları (GetX) ---
          translations: LocalizationService(), // Dil çevirilerini yükle
          locale: Locale(initialLanguageCode), // Başlangıç dilini ayarla
          fallbackLocale: LocalizationService.fallbackLocale, // Hata durumunda varsayılan dil

          // --- Tema Yönetimi Ayarları ---
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // themeMode artık sabit değil, notifier'dan gelen dinamik bir değer.
          themeMode: currentMode,

          // --- Genel Uygulama Ayarları ---
          title: 'Eventure',
          debugShowCheckedModeBanner: false,
          
          // --- Rota (Sayfa Yönlendirme) Ayarları ---
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