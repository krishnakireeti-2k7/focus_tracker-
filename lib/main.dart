import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/screens/focus_screen.dart';
import 'package:focus_tracker/screens/history_screen.dart';
import 'package:focus_tracker/theme/app_theme.dart';
import 'package:focus_tracker/providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Focus Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, 
      initialRoute: '/',
      routes: {
        '/': (context) => const FocusScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}