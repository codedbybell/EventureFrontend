import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;

void main() {
  runApp(const KampusEtkinlikApp());
}

class KampusEtkinlikApp extends StatelessWidget {
  const KampusEtkinlikApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kampüs Etkinlik Platformu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(), // Splash ilk açılan ekran
    );
  }
}
