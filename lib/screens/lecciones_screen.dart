import 'package:flutter/material.dart';
import 'detalle_categoria_screen.dart';

class LeccionesScreen extends StatelessWidget {
  const LeccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;

    final categorias = [
      Categoria(nombre: 'Hardware', icono: Icons.devices, activo: true),
      Categoria(
        nombre: 'Software',
        icono: Icons.desktop_windows,
        activo: false,
      ),
      Categoria(
        nombre: 'Sistemas Operativos',
        icono: Icons.memory,
        activo: false,
      ),
      Categoria(nombre: 'Internet', icono: Icons.wifi, activo: false),
      Categoria(
        nombre: 'Actualizaciones de sistema',
        icono: Icons.system_update,
        activo: false,
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Temas de Informática',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 20, 15),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Continúa los patrones',
              // ignore: deprecated_member_use
              style: TextStyle(fontSize: 20, color: textColor.withOpacity(0.6)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return ListTile(
                  onTap: () {
                    if (categoria.activo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleCategoriaScreen(categoria: categoria),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Atención'),
                          content: const Text(
                            'Completa el nivel anterior para habilitar este nivel.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  title: Row(
                    children: [
                      Icon(
                        categoria.icono,
                        size: 90,
                        color: categoria.activo ? textColor : Colors.grey,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        categoria.nombre,
                        style: TextStyle(
                          fontSize: 18,
                          color: categoria.activo ? textColor : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Categoria {
  final String nombre;
  final IconData icono;
  final bool activo;

  Categoria({required this.nombre, required this.icono, required this.activo});
}
