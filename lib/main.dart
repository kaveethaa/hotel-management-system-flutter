import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/database_helper.dart';
import 'seed/dummy_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint("Step 1");

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }/* else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }*/

    debugPrint("Step 2");

    final db = await DatabaseHelper.instance.database;

    debugPrint("Step 3");

    await DummyDataSeeder.seedIfEmpty(db);

    debugPrint("Step 4");
  } catch (e, stack) {
    debugPrint("ERROR: $e");
    debugPrintStack(stackTrace: stack);
  }

  debugPrint("Step 5");

  runApp(
    const ProviderScope(
      child: HotelApp(),
    ),
  );
}

class HotelApp extends ConsumerWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Elite',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      routerConfig: router,
    );
  }
}