import 'dart:async';
import 'package:flutter/material.dart';
// home_page.dart dosyasını doğru şekilde import ediyoruz.
import 'package:eventure/screens/home_page.dart';
import 'package:eventure/theme/theme.dart' as AppTheme;
// login_screen.dart'a artık ihtiyacımız olmadığı için bu satırı silebilirsiniz.
// import 'package:eventure/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 2 saniye sonra AnaEkran'a geç
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // HATA BURADAYDI: HomePage() yerine EcommerceHomePage() kullanıyoruz.
          builder: (context) => const EcommerceHomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 226, 203),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/logo.png', height: 500),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.salmonPalette),
            ),
          ],
        ),
      ),
    );
  }
}
