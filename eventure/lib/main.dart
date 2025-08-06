import 'package:flutter/material.dart';
import 'package:eventure/screens/splash_screen.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'theme/theme.dart'; 

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
      home: const SplashScreen(), // Splash ilk açılan ekran
      title: 'Eventure',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
