import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'lecciones_screen.dart';
import 'quiz_screen.dart';
import 'ajustes_screen.dart';
import '../models/categoria.dart'; // Importa el modelo Categoria para usarlo en esta pantalla

// Widget principal de la app con estado, que controla la navegación y tema
class HomeScreen extends StatefulWidget {
  // Función para cambiar el modo de tema (claro/oscuro)
  final Function(bool) toggleTheme;

  // Modo de tema actual (claro, oscuro o sistema)
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Estado interno del HomeScreen para controlar la barra de navegación
class _HomeScreenState extends State<HomeScreen> {
  // Índice actual de la pantalla visible en la barra inferior
  int _currentIndex = 0;

  // Función para cambiar a la pestaña de Lecciones (índice 1)
  void _goToLecciones() {
    setState(() {
      _currentIndex = 1;
    });
  }

  // Lista inicial de categorías con su nombre, icono y si están activas o no
  final List<Categoria> categoriasIniciales = [
    Categoria(
      nombre: 'Hardware',
      iconoPath: 'assets/icons/1_icon.png',
      activo: true, // Activa desde el inicio
    ),
    Categoria(
      nombre: 'Software',
      iconoPath: 'assets/icons/2_icon.png',
      activo: false, // Desactivada inicialmente
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

  // Método auxiliar para construir el icono con una línea arriba para la barra inferior
  Widget _buildImageIconWithLine(String assetPath, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ocupa mínimo espacio vertical
      children: [
        // Línea arriba que indica si el ícono está seleccionado
        Container(
          height: 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(
                    255,
                    157,
                    42,
                    219,
                  ) // Morado si está activo
                : Colors.transparent, // Invisible si no está activo
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 6), // Espacio vertical entre línea e icono
        // Icono de la barra inferior con color que depende de selección
        Image.asset(
          assetPath,
          height: 24,
          color: isSelected
              ? const Color.fromARGB(255, 157, 42, 219) // Morado para activo
              : const Color.fromARGB(255, 113, 111, 111), // Gris para inactivo
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas para cada pestaña de la barra inferior
    final List<Widget> screens = [
      InicioScreen(
        onIniciarPressed: _goToLecciones,
      ), // Pantalla Inicio con callback para ir a Lecciones
      LeccionesScreen(
        categorias: categoriasIniciales,
      ), // Pantalla Lecciones con categorías
      const QuizScreen(), // Pantalla Quiz
      AjustesScreen(
        toggleTheme: widget.toggleTheme, // Pasamos función para cambiar tema
        isDarkMode:
            widget.themeMode == ThemeMode.dark, // Estado actual del tema
      ),
    ];

    return Scaffold(
      // Muestra la pantalla correspondiente al índice actual
      body: screens[_currentIndex],

      // Barra inferior de navegación con iconos personalizados
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 157, 42, 219),
        unselectedItemColor: const Color.fromARGB(255, 113, 111, 111),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
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
