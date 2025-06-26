import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importa la pantalla principal (Home)
import 'screens/splash_screen.dart'; // Importa la pantalla de presentación (Splash)

// Función principal que arranca la aplicación
void main() {
  runApp(const BitySoftApp());
}

// Widget principal de la aplicación que maneja el estado general
class BitySoftApp extends StatefulWidget {
  const BitySoftApp({super.key});

  @override
  State<BitySoftApp> createState() => _BitySoftAppState();
}

class _BitySoftAppState extends State<BitySoftApp> {
  // Variable para controlar el modo de tema (claro u oscuro)
  ThemeMode _themeMode = ThemeMode.light;

  // Función para cambiar el tema según el valor booleano recibido
  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitySoft', // Título de la app
      debugShowCheckedModeBanner: false, // Oculta el banner DEBUG en desarrollo
      theme: ThemeData.light(), // Tema claro predeterminado
      darkTheme: ThemeData.dark(), // Tema oscuro definido
      themeMode: _themeMode, // Usa el tema seleccionado (claro u oscuro)
      initialRoute: '/', // Ruta inicial (SplashScreen)
      routes: {
        // Ruta principal que carga el splash screen
        '/': (context) => const SplashScreen(),

        // Ruta para la pantalla principal, pasando funciones y estado de tema
        '/home': (context) =>
            HomeScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
      },
    );
  }
}
