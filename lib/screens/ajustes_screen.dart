import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para manejar el estado global (SettingsProvider)

import 'settings_provider.dart'; // Proveedor de ajustes (como tamaño de letra)
import 'soporte_screen.dart'; // Pantalla de soporte
import 'sugerencias_screen.dart'; // Pantalla de sugerencias
import 'sugerir_tema_screen.dart'; // Pantalla para sugerir un nuevo tema

// Pantalla de ajustes (configuraciones)
class AjustesScreen extends StatefulWidget {
  final Function(bool)
  toggleTheme; // Función que permite cambiar entre modo claro/oscuro
  final bool isDarkMode; // Indica si el modo oscuro está activado actualmente

  const AjustesScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

// Estado de la pantalla de ajustes
class _AjustesScreenState extends State<AjustesScreen> {
  // Variables para mostrar u ocultar los menús desplegables
  bool mostrarSlider =
      false; // Muestra el slider para cambiar el tamaño de letra
  bool mostrarAlineacion = false; // Muestra las opciones de alineación de texto

  // Widget reutilizable para dar estilo a cada opción (con borde y espaciado)
  Widget _buildOptionBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400), // Borde gris claro
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de fuente global desde el SettingsProvider
    double tamanioLetra = context.watch<SettingsProvider>().fontSize;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')), // Título de la app bar
      // Hace que el contenido de la pantalla sea desplazable
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding alrededor del contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección "Global"
            const Text(
              'Global',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Opción: Modo nocturno (switch)
            _buildOptionBox(
              SwitchListTile(
                title: const Text('Modo nocturno'),
                value: widget.isDarkMode, // Estado actual del switch
                onChanged:
                    widget.toggleTheme, // Llama a la función para cambiar tema
                secondary: const Icon(Icons.dark_mode), // Ícono a la izquierda
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Opción: Tamaño de letra
            _buildOptionBox(
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.format_size),
                    title: const Text('Tamaño de la letra'),
                    onTap: () {
                      // Alterna mostrar/ocultar el slider
                      setState(() {
                        mostrarSlider = !mostrarSlider;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // Si se activa mostrarSlider, se despliega el control
                  if (mostrarSlider)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Escoja el tamaño'), // Etiqueta

                          const SizedBox(height: 8),

                          // Íconos A pequeño y A grande como referencia visual
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              ExcludeSemantics(
                                child: Text('A'),
                              ), // Letra pequeña
                              Expanded(child: SizedBox()), // Espaciador
                              ExcludeSemantics(
                                child: Text(
                                  'A',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ), // Letra grande
                            ],
                          ),

                          // Slider para cambiar el tamaño
                          Slider(
                            value: tamanioLetra, // Valor actual
                            min: 12, // Valor mínimo
                            max: 24, // Valor máximo
                            divisions: 6, // Número de divisiones
                            label: tamanioLetra
                                .round()
                                .toString(), // Etiqueta del valor
                            onChanged: (value) {
                              // Actualiza el tamaño de letra global
                              context.read<SettingsProvider>().updateFontSize(
                                value,
                              );
                            },
                            activeColor: Colors.purple,
                          ),

                          const SizedBox(height: 8),

                          // Botón para cerrar el menú desplegable
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  mostrarSlider = false;
                                });
                              },
                              child: const Text('Cerrar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Opción: Alineación de texto
            _buildOptionBox(
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.format_align_left),
                    title: const Text('Alineación de texto'),
                    onTap: () {
                      // Alterna mostrar/ocultar las opciones de alineación
                      setState(() {
                        mostrarAlineacion = !mostrarAlineacion;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // Si mostrarAlineacion es true, muestra las opciones de alineación
                  if (mostrarAlineacion)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Escoja la alineación'),
                          const SizedBox(height: 8),

                          // Muestra íconos de alineación (visual únicamente)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Icon(Icons.format_align_left, size: 32),
                              Icon(Icons.format_align_center, size: 32),
                              Icon(Icons.format_align_right, size: 32),
                              Icon(Icons.format_align_justify, size: 32),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Botón para cerrar el menú
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  mostrarAlineacion = false;
                                });
                              },
                              child: const Text('Cerrar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Opción: Navegar a pantalla de sugerencias
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Sugerencias'),
                onTap: () {
                  // Navega a la pantalla SugerenciasScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SugerenciasScreen(),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Opción: Navegar a pantalla de soporte
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.support),
                title: const Text('Soporte'),
                onTap: () {
                  // Navega a la pantalla SoporteScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SoporteScreen()),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Opción: Navegar a pantalla para sugerir nuevos temas
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Sugerir temas'),
                onTap: () {
                  // Navega a la pantalla SugerirTemaScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SugerirTemaScreen(),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
