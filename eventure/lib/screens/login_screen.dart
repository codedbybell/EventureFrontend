// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form alanları için controller'lar
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // API servisi için bir örnek (instance)
  final AuthService _authService = AuthService();

  // UI durumları için değişkenler
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Giriş yapma fonksiyonu
  Future<void> _login() async {
    // Butona tekrar basılmasını engellemek için yüklenme durumunu başlat
    setState(() {
      _isLoading = true;
    });

    try {
      final requestModel = LoginRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final response = await _authService.login(requestModel);

      // Başarılı! Token'ları kaydet ve ana sayfaya yönlendir.
      // TODO: Token'ları SharedPreferences veya FlutterSecureStorage ile kaydet.
      print("Access Token: ${response.access}");
      print("Refresh Token: ${response.refresh}");

      // Ana sayfaya git ve geri dönme seçeneğini kaldır
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş yapılamadı: ${e.toString()}')),
        );
      }
    } finally {
      // İşlem bitince yüklenme durumunu sonlandır
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için controller'ları temizle
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/logo.png', height: 300),
              const SizedBox(height: 2),

              Text('Email', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              Text('Password', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Remember Me', style: textTheme.bodySmall),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Şifremi unuttum özelliği eklenecek
                    },
                    child: Text(
                      'Forgot Password?',
                      style: textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text('LOG IN', style: textTheme.labelLarge),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
