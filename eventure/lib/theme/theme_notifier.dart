// lib/theme/theme_notifier.dart (YENİ DOSYA)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier {
  // ThemeMode değişikliklerini dinlemek için bir ValueNotifier kullanıyoruz.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  // Kayıtlı temayı yükleyen fonksiyon.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Kayıtlı tema var mı diye kontrol et, yoksa aydınlık modu varsay.
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Tema seçimini cihaza kaydeden fonksiyon.
  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Aydınlık moda geçiş.
  void setLightMode() {
    themeMode.value = ThemeMode.light;
    _saveTheme(false);
  }

  // Karanlık moda geçiş.
  void setDarkMode() {
    themeMode.value = ThemeMode.dark;
    _saveTheme(true);
  }
}
