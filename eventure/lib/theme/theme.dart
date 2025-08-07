// lib/theme/theme.dart (TEK VE DOĞRU TEMA DOSYASI)

import 'package:flutter/material.dart';

// 🎨 Color Palette Definitions
const Color orangePalette = Color(0xFFFF9F1C);
const Color tealPalette = Color(0xFF56C1C2);
const Color salmonPalette = Color(0xFFF67280);
const Color darkCoralPalette = Color(0xFFEB5E55);
const Color lightYellowPalette = Color(0xFFFFE66D);
// *** İHTİYACIMIZ OLAN RENK BURAYA EKLENDİ ***
const Color neutralGray = Color(0xFF9E9E9E);

// 🖤 Alternatives for Black
const Color darkTextColor = Color(0xFF4E342E);
const Color lightBackground = Color(0xFFFFFBF5);
const Color darkBackground = Color(0xFF2c3e50);
const Color darkSurface = Color(0xFF34495e);

// --- LIGHT THEME ---
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: salmonPalette, // 🔁 Primary = Somon
  scaffoldBackgroundColor: lightBackground,

  colorScheme: const ColorScheme.light(
    primary: salmonPalette,
    onPrimary: Colors.white,
    secondary: tealPalette,
    onSecondary: Colors.white,
    tertiary: orangePalette, // 🔁 Tertiary = Turuncu
    onTertiary: Colors.white,
    error: darkCoralPalette,
    onError: Colors.white,
    background: lightBackground,
    onBackground: darkTextColor,
    surface: Colors.white,
    onSurface: darkTextColor,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: salmonPalette,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: salmonPalette,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: salmonPalette,
      foregroundColor: Colors.white,
    ),
  ),

  cardTheme: const CardThemeData(color: Colors.white, elevation: 1),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: darkTextColor),
    displayMedium: TextStyle(color: darkTextColor),
    displaySmall: TextStyle(color: darkTextColor),
    headlineMedium: TextStyle(color: darkTextColor),
    headlineSmall: TextStyle(color: darkTextColor),
    titleLarge: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: darkTextColor),
    bodyMedium: TextStyle(color: darkTextColor),
    labelLarge: TextStyle(color: Colors.white),
  ),
);

// --- DARK THEME ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: salmonPalette,
  scaffoldBackgroundColor: darkBackground,

  colorScheme: const ColorScheme.dark(
    primary: salmonPalette,
    onPrimary: darkTextColor,
    secondary: orangePalette,
    onSecondary: Colors.white,
    tertiary: tealPalette,
    onTertiary: Colors.white,
    error: darkCoralPalette,
    onError: Colors.white,
    background: darkBackground,
    onBackground: lightBackground,
    surface: darkSurface,
    onSurface: lightBackground,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurface,
    foregroundColor: salmonPalette,
    elevation: 0,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: salmonPalette,
    foregroundColor: darkTextColor,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: salmonPalette,
      foregroundColor: darkTextColor,
    ),
  ),

  cardTheme: const CardThemeData(color: darkSurface),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: lightBackground),
    displayMedium: TextStyle(color: lightBackground),
    displaySmall: TextStyle(color: lightBackground),
    headlineMedium: TextStyle(color: lightBackground),
    headlineSmall: TextStyle(color: lightBackground),
    titleLarge: TextStyle(color: lightBackground, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: lightBackground),
    bodyMedium: TextStyle(color: lightBackground),
    labelLarge: TextStyle(color: darkTextColor),
  ),
);
