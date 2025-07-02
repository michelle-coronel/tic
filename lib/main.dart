import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const BitySoftApp(),
    ),
  );
}

class BitySoftApp extends StatefulWidget {
  const BitySoftApp({super.key});

  @override
  State<BitySoftApp> createState() => _BitySoftAppState();
}

class _BitySoftAppState extends State<BitySoftApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final settings = Provider.of<SettingsProvider>(context);

        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaleFactor: settings.fontSize / 16.0),
          child: MaterialApp(
            title: 'BitySoft',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: _themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) =>
                  HomeScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
            },
          ),
        );
      },
    );
  }
}
