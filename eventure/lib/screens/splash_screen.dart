// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../services/token_service.dart'; // Token servisimizi import ediyoruz

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  /// Cihazda kayıtlı bir token olup olmadığını kontrol eder ve yönlendirme yapar.
  Future<void> _checkAuthAndNavigate() async {
    // Kısa bir bekleme süresi ekleyerek splash screen'in aniden kaybolmasını önleyebiliriz.
    await Future.delayed(const Duration(seconds: 2));

    // Cihazdan access token'ı okumayı deniyoruz.
    final String? accessToken = await _tokenService.getAccessToken();

    // Widget'ın hala ekranda olduğundan emin oluyoruz.
    // (Asenkron işlem sonrası widget ağacından kaldırılmış olabilir)
    if (!mounted) return;

    // Token varsa ana sayfaya, yoksa giriş ekranına yönlendir.
    if (accessToken != null) {
      // pushReplacementNamed kullanarak splash screen'i yığından kaldırıyoruz,
      // böylece kullanıcı geri tuşuyla bu ekrana dönemez.
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kontrol işlemi sırasında ekranda logonuzu veya bir yüklenme animasyonu gösterebilirsiniz.
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logonuzun `assets/logo.png` yolunda olduğundan emin olun.
            Image.asset('assets/logo.png', height: 350),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Yükleniyor animasyonu
          ],
        ),
      ),
    );
  }
}
