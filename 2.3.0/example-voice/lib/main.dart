import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.system);

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Voice Example',
          themeMode: mode,
          darkTheme: ThemeData(
            brightness: Brightness.dark
          ),
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF0099af),
            fontFamily: 'CircularStdBold',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Voice Example', notifier: _notifier, mode: mode),
        );
      }
    );
  }
}