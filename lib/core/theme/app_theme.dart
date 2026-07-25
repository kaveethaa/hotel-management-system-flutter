import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const navy = Color(0xFF1A2B4A);
  static const navyDark = Color(0xFF0F1B33);
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFE8C86A);
  static const cream = Color(0xFFFAF6ED);
  static const charcoal = Color(0xFF2C2C2C);
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) { _load(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString('theme') ?? 'light';
    state = v == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final p = await SharedPreferences.getInstance();
    await p.setString('theme', state == ThemeMode.dark ? 'dark' : 'light');
  }
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: const ColorScheme.light(
        primary: AppColors.navy, secondary: AppColors.gold,
        surface: Colors.white, onPrimary: Colors.white, onSecondary: AppColors.navy),
    textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
        bodyMedium: GoogleFonts.poppins(),
        bodyLarge: GoogleFonts.poppins(),
        bodySmall: GoogleFonts.poppins()),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.navy, foregroundColor: Colors.white, elevation: 0),
    cardTheme: CardThemeData(elevation: 2, color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.navy),
    chipTheme: ChipThemeData(
        selectedColor: AppColors.navy, secondarySelectedColor: AppColors.navy,
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.navyDark,
    colorScheme: const ColorScheme.dark(
        primary: AppColors.gold, secondary: AppColors.goldLight,
        surface: AppColors.navy, onPrimary: AppColors.navyDark),
    textTheme: GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: GoogleFonts.poppins(color: Colors.white),
        bodyLarge: GoogleFonts.poppins(color: Colors.white)),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.navyDark, foregroundColor: AppColors.gold),
    cardTheme: CardThemeData(elevation: 2, color: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.navyDark)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.navyDark),
  );
}