import 'package:flutter/material.dart';

class AjustesScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const AjustesScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Global',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('Modo nocturno'),
            value: isDarkMode,
            onChanged: toggleTheme,
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Tamaño de la letra'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.format_align_left),
            title: const Text('Alineación de texto'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Sugerencias'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Soporte'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text('Sugerir temas'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
