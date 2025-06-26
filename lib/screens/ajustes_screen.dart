import 'package:flutter/material.dart';
import 'soporte_screen.dart';
import 'sugerencias_screen.dart';
import 'sugerir_tema_screen.dart'; // Importa la nueva pantalla

class AjustesScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const AjustesScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool mostrarSlider = false;
  double tamanioLetra = 16.0;

  bool mostrarAlineacion =
      false; // Controla si se muestra la alineación expandible

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
            const Text(
              'Global',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Modo nocturno
            _buildOptionBox(
              SwitchListTile(
                title: const Text('Modo nocturno'),
                value: widget.isDarkMode,
                onChanged: widget.toggleTheme,
                secondary: const Icon(Icons.dark_mode),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            // Tamaño de letra (expandible)
            _buildOptionBox(
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.text_fields),
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
                          const Text('Tamaño de la letra'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('A'),
                              Expanded(child: SizedBox()),
                              Text('A', style: TextStyle(fontSize: 24)),
                            ],
                          ),
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

            // Alineación de texto (expandible con iconos)
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
                          const Text('Alineación de texto'),
                          const SizedBox(height: 8),
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

            // Sugerencias
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

            //Soporte
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

            // Sugerir temas
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
