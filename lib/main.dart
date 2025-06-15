/*import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BitySoftApp());
}

class BitySoftApp extends StatelessWidget {
  const BitySoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitySoft',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BitySoftApp());
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
    return MaterialApp(
      title: 'BitySoft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BitySoftApp());
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
    return MaterialApp(
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
    );
  }
}
