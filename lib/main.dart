import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/database_helper.dart';
import 'seed/dummy_data.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper.instance.database;
  await DummyDataSeeder.seedIfEmpty(db);

  runApp(const ProviderScope(child: HotelApp()));
}

class HotelApp extends ConsumerWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

   // final router = ref.watch(routerProvider);
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Hotel Manager', debugShowCheckedModeBanner: false,
      theme: AppTheme.light, darkTheme: AppTheme.dark, themeMode: mode,
      routerConfig: router,
    );
  }
}