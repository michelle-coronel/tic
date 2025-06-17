import 'package:flutter/material.dart';

class AjustesScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const AjustesScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  Widget _buildOptionBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // espacio abajo
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Global',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOptionBox(
              SwitchListTile(
                title: const Text('Modo nocturno'),
                value: isDarkMode,
                onChanged: toggleTheme,
                secondary: const Icon(Icons.dark_mode),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            _buildOptionBox(
              Semantics(
                label: 'Cambiar tamaño de la letra',
                excludeSemantics: true,
                child: ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: const Text('Tamaño de la letra'),
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.format_align_left),
                title: const Text('Alineación de texto'),
                onTap: () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Sugerencias'),
                onTap: () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.support),
                title: const Text('Soporte'),
                onTap: () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            _buildOptionBox(
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Sugerir temas'),
                onTap: () {},
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
