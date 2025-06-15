/*import 'package:bitysoft/screens/ajustes_screen.dart';
import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'lecciones_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _goToLecciones() {
    setState(() {
      _currentIndex = 1; // índice de Lecciones
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      InicioScreen(onIniciarPressed: _goToLecciones),
      const LeccionesScreen(),
      const QuizScreen(),
      const AjustesScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson),
            label: 'Lecciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'lecciones_screen.dart';
import 'quiz_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _goToLecciones() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      InicioScreen(onIniciarPressed: _goToLecciones),
      const LeccionesScreen(),
      const QuizScreen(),
      AjustesScreen(
        toggleTheme: widget.toggleTheme,
        isDarkMode: widget.themeMode == ThemeMode.dark,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson),
            label: 'Lecciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
