import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // YENİ: Bu satırı ekleyin
import 'en_US.dart';
import 'tr_TR.dart';

class LocalizationService extends Translations {
  // SİLİNDİ: Bu satır kaldırıldı, çünkü başlangıç dili artık main.dart dosyasında,
  // cihaz hafızasından okunarak belirleniyor. Static olması dinamikliği engelliyordu.
  // static final locale = _getLocaleFromLanguage();

  // Bu ayarlar olduğu gibi kalabilir.
  static const fallbackLocale = Locale(
    'en',
    'US',
  ); // Fallback olarak İngilizce daha mantıklı olabilir.
  static final locales = [const Locale('en', 'US'), const Locale('tr', 'TR')];

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'tr_TR': tr};

  static Future<void> changeLocale(String langCode) async {
    final newLocale = _getLocaleFromLanguage(langCode);

    Get.updateLocale(newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
  }

  static Locale _getLocaleFromLanguage(String langCode) {
    switch (langCode) {
      case 'en':
        return locales[0]; 
      case 'tr':
        return locales[1]; 
      default:
        return fallbackLocale;
    }
  }
}
