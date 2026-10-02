import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/utils/logger.dart';

// Default entry point maps to Development for easy `flutter run`
import 'main_dev.dart' as dev;

void main() {
  dev.main();
}

class SafeRideApp extends ConsumerWidget {
  const SafeRideApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Honda SafeRide',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or whatever preference user has
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
