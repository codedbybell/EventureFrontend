import 'package:flutter/material.dart';

// Renk Paleti Tanımları
const Color paletTuruncu = Color(0xFFFF9F1C);
const Color paletCamGobegi = Color(0xFF56C1C2);
const Color paletSomon = Color(0xFFF67280);
const Color paletKoyuMercan = Color(0xFFEB5E55);
const Color paletAcikSari = Color(0xFFFFE66D);

// Siyah Yerine Kullanılacak Renkler
const Color koyuMetinRengi = Color(0xFF4E342E); // Koyu kahve (Siyah yerine)
const Color acikArkaPlan = Color(0xFFFFFBF5); // Çok hafif kırık beyaz
const Color koyuArkaPlan = Color(0xFF2c3e50); // Koyu lacivert/gri
const Color koyuYuzey = Color(0xFF34495e); // Bir ton açık lacivert/gri

// --- AÇIK TEMA ---
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: paletTuruncu,
  scaffoldBackgroundColor: acikArkaPlan,

  colorScheme: const ColorScheme.light(
    primary: paletTuruncu,
    onPrimary: Colors.white,
    secondary: paletCamGobegi,
    onSecondary: Colors.white,
    tertiary: paletSomon, // Üçüncül renk olarak somon eklendi
    onTertiary: Colors.white,
    error: paletKoyuMercan,
    onError: Colors.white,
    background: acikArkaPlan,
    onBackground: koyuMetinRengi, // Arka plan üstü metin
    surface: Colors.white,
    onSurface: koyuMetinRengi, // Kart gibi yüzeylerin üstündeki metin
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: paletTuruncu,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: paletTuruncu,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: paletTuruncu,
      foregroundColor: Colors.white,
    ),
  ),

  cardTheme: const CardThemeData(color: Colors.white, elevation: 1),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: koyuMetinRengi),
    displayMedium: TextStyle(color: koyuMetinRengi),
    displaySmall: TextStyle(color: koyuMetinRengi),
    headlineMedium: TextStyle(color: koyuMetinRengi),
    headlineSmall: TextStyle(color: koyuMetinRengi),
    titleLarge: TextStyle(color: koyuMetinRengi),
    bodyLarge: TextStyle(color: koyuMetinRengi),
    bodyMedium: TextStyle(color: koyuMetinRengi),
    labelLarge: TextStyle(color: Colors.white), // Buton içi metinler
  ),
);

// --- KOYU TEMA ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: paletTuruncu,
  scaffoldBackgroundColor: koyuArkaPlan,

  colorScheme: const ColorScheme.dark(
    primary: paletTuruncu,
    onPrimary: koyuMetinRengi, // Turuncu üstündeki metin
    secondary: paletSomon,
    onSecondary: Colors.white,
    tertiary: paletCamGobegi,
    onTertiary: Colors.white,
    error: paletKoyuMercan,
    onError: Colors.white,
    background: koyuArkaPlan,
    onBackground: acikArkaPlan, // Koyu arka plan üstü metin
    surface: koyuYuzey,
    onSurface: acikArkaPlan, // Kart gibi yüzeylerin üstündeki metin
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: koyuYuzey,
    foregroundColor: paletTuruncu, // AppBar başlığı turuncu
    elevation: 0,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: paletTuruncu,
    foregroundColor: koyuMetinRengi,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: paletTuruncu,
      foregroundColor: koyuMetinRengi,
    ),
  ),

  cardTheme: const CardThemeData(color: koyuYuzey),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: acikArkaPlan),
    displayMedium: TextStyle(color: acikArkaPlan),
    displaySmall: TextStyle(color: acikArkaPlan),
    headlineMedium: TextStyle(color: acikArkaPlan),
    headlineSmall: TextStyle(color: acikArkaPlan),
    titleLarge: TextStyle(color: acikArkaPlan),
    bodyLarge: TextStyle(color: acikArkaPlan),
    bodyMedium: TextStyle(color: acikArkaPlan),
    labelLarge: TextStyle(color: koyuMetinRengi), // Buton içi metinler
  ),
);
