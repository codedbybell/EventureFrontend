// lib/screens/change_password.dart (TAM VE SON HALİ)

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth_models.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Servisimizi ve yüklenme durumunu ekliyoruz
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Backend'e istek gönderecek fonksiyon
  Future<void> _saveNewPassword() async {
    // Formun boş olup olmadığını kontrol et
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lütfen tüm alanları doldurun.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    // Yeni şifrelerin eşleşip eşleşmediğini kontrol et
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Yeni şifreler uyuşmuyor.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final requestModel = ChangePasswordRequestModel(
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirm: _confirmPasswordController.text,
      );

      final success = await _authService.changePassword(requestModel);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Şifre başarıyla değiştirildi!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Başarılı olursa bir önceki ekrana dön
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              context: context,
              labelText: 'Current Password',
              controller: _currentPasswordController,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              context: context,
              labelText: 'New Password',
              controller: _newPasswordController,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              context: context,
              labelText: 'Confirm New Password',
              controller: _confirmPasswordController,
            ),
            const SizedBox(height: 40),
            _buildGradientSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String labelText,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);
    final fillColor = theme.colorScheme.secondary.withOpacity(0.1);

    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildGradientSaveButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : _saveNewPassword, // Fonksiyonu ve yüklenme durumunu bağla
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)))
                : const Text(
                    'SAVE', // Buton metnini İngilizce'ye çevirdim
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
