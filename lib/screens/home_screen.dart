import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'lecciones_screen.dart';
import 'quiz_screen.dart';
import 'ajustes_screen.dart';
import '../models/categoria.dart'; // Asegúrate de importar tu modelo Categoria

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

  // Lista de categorías que se puede modificar para habilitar nuevos temas
  final List<Categoria> categoriasIniciales = [
    Categoria(
      nombre: 'Hardware',
      iconoPath: 'assets/icons/1_icon.png',
      activo: true,
    ),
    Categoria(
      nombre: 'Software',
      iconoPath: 'assets/icons/2_icon.png',
      activo: false,
    ),
    Categoria(
      nombre: 'Sistemas Operativos',
      iconoPath: 'assets/icons/3_icon.png',
      activo: false,
    ),
    Categoria(
      nombre: 'Internet',
      iconoPath: 'assets/icons/4_icon.png',
      activo: false,
    ),
    Categoria(
      nombre: 'Actualizaciones de sistema',
      iconoPath: 'assets/icons/5_icon.png',
      activo: false,
    ),
  ];

  Widget _buildImageIconWithLine(String assetPath, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 157, 42, 219)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 6),
        Image.asset(
          assetPath,
          height: 24,
          color: isSelected
              ? const Color.fromARGB(255, 157, 42, 219)
              : const Color.fromARGB(255, 113, 111, 111),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      InicioScreen(onIniciarPressed: _goToLecciones),
      LeccionesScreen(categorias: categoriasIniciales),
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
        selectedItemColor: const Color.fromARGB(255, 157, 42, 219),
        unselectedItemColor: const Color.fromARGB(255, 113, 111, 111),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildImageIconWithLine(
              'assets/icons/home_icon.png',
              _currentIndex == 0,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: _buildImageIconWithLine(
              'assets/icons/lecciones_icon.png',
              _currentIndex == 1,
            ),
            label: 'Lecciones',
          ),
          BottomNavigationBarItem(
            icon: _buildImageIconWithLine(
              'assets/icons/quiz_icon.png',
              _currentIndex == 2,
            ),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: _buildImageIconWithLine(
              'assets/icons/ajustes_icon.png',
              _currentIndex == 3,
            ),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
