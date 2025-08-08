// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form alanları için controller'lar
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // API servisi
  final AuthService _authService = AuthService();

  // UI durumları
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Kayıt olma fonksiyonu
  Future<void> _register() async {
    // Önce şifrelerin uyuşup uyuşmadığını kontrol et
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Şifreler uyuşmuyor!')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final requestModel = RegisterRequestModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        password2: _confirmPasswordController.text.trim(),
      );

      final success = await _authService.register(requestModel);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı! Lütfen giriş yapın.')),
        );
        Navigator.pop(context); // Kayıt başarılı olunca giriş ekranına geri dön
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt oluşturulamadı: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için controller'ları temizle
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

              Text('First Name', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _firstNameController,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              Text('Last Name', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _lastNameController,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

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
              const SizedBox(height: 20),

              Text('Confirm Password', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true, // Şifre tekrarı her zaman gizli olmalı
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: '••••••••',
                ),
              ),
              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text('REGISTER', style: textTheme.labelLarge),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
