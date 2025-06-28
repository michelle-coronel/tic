import 'package:flutter/material.dart';
import 'soporte_screen.dart';
import 'sugerencias_screen.dart';
import 'sugerir_tema_screen.dart';

// Pantalla principal de ajustes
class AjustesScreen extends StatefulWidget {
  final Function(bool)
  toggleTheme; // Función para cambiar entre modo claro/oscuro
  final bool isDarkMode; // Indica si el modo oscuro está activo

  const AjustesScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  // Controla la visibilidad del slider de tamaño de letra
  bool mostrarSlider = false;

  // Valor actual del tamaño de letra
  double tamanioLetra = 16.0;

  // Controla la visibilidad de las opciones de alineación de texto
  bool mostrarAlineacion = false;

  // Método que devuelve un contenedor con estilo para envolver cada opción
  Widget _buildOptionBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de sección
            const Text(
              'Global',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Opción: Modo nocturno (switch)
            _buildOptionBox(
              SwitchListTile(
                title: const Text('Modo nocturno'),
                value: widget.isDarkMode,
                onChanged: widget.toggleTheme,
                secondary: const Icon(Icons.dark_mode),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Opción: Tamaño de letra (expandible con slider)
            _buildOptionBox(
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.format_size),
                    title: const Text('Tamaño de la letra'),
                    onTap: () {
                      setState(() {
                        mostrarSlider = !mostrarSlider;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  if (mostrarSlider)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Escoja el tamaño'),
                          const SizedBox(height: 8),

                          // Letras pequeñas y grandes para referencia visual
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              ExcludeSemantics(child: Text('A')),
                              Expanded(child: SizedBox()),
                              ExcludeSemantics(
                                child: Text(
                                  'A',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                          // Slider para cambiar tamaño de letra
                          Slider(
                            value: tamanioLetra,
                            min: 12,
                            max: 24,
                            divisions: 6,
                            label: tamanioLetra.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                tamanioLetra = value;
                              });
                            },
                            activeColor: Colors.purple,
                          ),

                          const SizedBox(height: 8),

                          // Botón para cerrar el slider
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

            // Opción: Alineación de texto (expandible con iconos)
            _buildOptionBox(
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.format_align_left),
                    title: const Text('Alineación de texto'),
                    onTap: () {
                      setState(() {
                        mostrarAlineacion = !mostrarAlineacion;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
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

                          // Iconos de las distintas alineaciones
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

                          // Botón para cerrar el menú de alineación
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SoporteScreen()),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Opción: Navegar a pantalla de sugerir temas
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Sugerir temas'),
                onTap: () {
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
