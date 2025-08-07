import 'package:flutter/material.dart';

// Bu ekran stateful olmalı çünkü TextField'lar için controller'lara ihtiyacı var.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controller'ları burada tanımlıyoruz.
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Controller'ları temizlemeyi unutmuyoruz.
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveNewPassword() {
    if (_newPasswordController.text == _confirmPasswordController.text &&
        _newPasswordController.text.isNotEmpty) {
      print('Password changed successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Başarılı olursa bir önceki ekrana dön.
      Navigator.pop(context);
    } else {
      print('Passwords do not match or the field is empty!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Passwords do not match or fields are empty.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar, otomatik olarak bir "geri" butonu ekler.
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Elemanları yatayda genişlet
          children: [
            // Bir önceki cevaptaki şifre alanı oluşturma metodunu burada kullanabiliriz.
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
            // Kaydet Butonu
            _buildGradientSaveButton(),
          ],
        ),
      ),
    );
  }

  // Şifre alanı oluşturmak için yardımcı metot (önceki cevaptan)
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
        // ÖNEMLİ: onPressed, _saveProfile yerine bu ekrana ait olan _saveNewPassword'a bağlanmalı.
        onPressed: _saveNewPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Butonun kendi rengini şeffaf yap
          shadowColor: Colors.transparent, // ve gölgesini kaldır
          padding: EdgeInsets.zero, // İç boşluğu sıfırla ki Ink tam otursun
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            // Gradyan renklerini burada tanımla
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B9D),
                Color(0xFF4ECDC4),
              ], // Örnekteki gradyan renkleri
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(
              25,
            ), // Dekorasyonun kenarlarını da yuvarla
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Text(
              'KAYDET', // Buton metnini değiştir
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
