// Temel Flutter ve uygulama ekranları importları
import 'package:eventure/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

import 'package:get/get.dart';
import 'package:eventure/localization/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String languageCode = prefs.getString('language_code') ?? 'en';

  runApp(MyApp(initialLanguageCode: languageCode));
}

class MyApp extends StatelessWidget {
  final String initialLanguageCode;

  const MyApp({
    Key? key,
    required this.initialLanguageCode, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalizationService(),
      locale: Locale(initialLanguageCode),
      fallbackLocale: LocalizationService.fallbackLocale,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Eventure',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/history': (context) => const HistoryScreen(),
        '/home': (context) => EcommerceHomePage(),
      },
    );
  }
}
