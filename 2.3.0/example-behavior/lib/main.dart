import 'package:example/dashboard.dart';
import 'package:example/home.dart';
import 'package:example/login.dart';
import 'package:flutter/material.dart';

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
          title: '360 Behavior',
          themeMode: mode,
          darkTheme: ThemeData(brightness: Brightness.dark),
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF0099af),
            fontFamily: 'CircularStdBold',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (_) => LoginPage(notifier: _notifier, mode: mode),
            '/home': (_) => HomePage(notifier: _notifier, mode: mode),
            '/dashboard': (_) => DashboardPage(notifier: _notifier, mode: mode),
          },
        );
      },
    );
  }
}
