import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.system);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'SdkMobile Example',
          themeMode: mode,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          home: MyHomePage(title: 'Onboarding', notifier: _notifier),
        );
      },
    );
  }
}

ThemeData _theme(Brightness brightness) {
  final ColorScheme scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF0099AF), brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'CircularStdBold',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}
