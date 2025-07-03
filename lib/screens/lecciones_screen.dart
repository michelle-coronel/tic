import 'package:flutter/material.dart';
import '../models/categoria.dart'; // Importa el modelo Categoria
import 'detalle_categoria_screen.dart'; // Pantalla de detalle para categorías generales
import 'detalle_software_screen.dart'; // Pantalla de detalle específica para Software

// Pantalla que muestra la lista de lecciones o temas disponibles
class LeccionesScreen extends StatelessWidget {
  final List<Categoria>
  categorias; // Lista de categorías recibida como parámetro

  const LeccionesScreen({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtiene el tema actual (claro u oscuro)
    final textColor =
        theme.textTheme.bodyLarge?.color ??
        Colors.black; // Color de texto adaptativo
    final backgroundColor = theme.scaffoldBackgroundColor; // Fondo adaptativo

    // CONTRASTE ADAPTATIVO MEJORADO

    // Color para ítems activos: negro en claro, ámbar en oscuro
    final Color colorActivo = theme.brightness == Brightness.dark
        ? Colors.amberAccent
        : Colors.black;

    // Color para ítems inactivos:
    // ANTES: era fijo (como Colors.grey), lo que causaba bajo contraste en modo oscuro
    // AHORA: se adapta al tema — blanco translúcido en oscuro y negro translúcido en claro
    final Color colorInactivo = theme.brightness == Brightness.dark
        ? Colors
              .white54 // íconos claros sobre fondo oscuro
        : Colors.black54; // íconos oscuros sobre fondo claro

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          // Título principal
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
          // Subtítulo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Continúa los patrones',
              style: TextStyle(
                fontSize: 20,
                color: textColor.withAlpha((0.6 * 255).round()), // 60% opacidad
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final bool esActivo = categoria.activo;
                final bool estaCompletado = categoria.completado;

                // Color del ícono: activo o inactivo
                Color iconColor = esActivo ? colorActivo : colorInactivo;

                // Color del borde: verde si completado, si no el color del ícono
                Color bordeColor = estaCompletado
                    ? const Color(0xFF2E7D32) // verde más fuerte
                    : iconColor;

                // CAMBIO CLAVE PARA MEJOR CONTRASTE DE FONDO
                // Fondo donde se coloca el ícono:
                // ANTES: era muy claro (#FEF7FF), con bajo contraste frente al ícono gris
                // AHORA: gris claro (#ECECEC) en modo claro, gris oscuro en modo oscuro
                Color fondoColor = theme.brightness == Brightness.dark
                    ? Colors.grey[800]! // fondo oscuro en modo oscuro
                    : const Color(0xFFECECEC); // fondo gris claro mejorado

                return ListTile(
                  onTap: () {
                    // Categoría completada: muestra felicitación
                    if (categoria.completado) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¡Felicidades!'),
                          content: Text(
                            'El nivel "${categoria.nombre}" ya está completado.',
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
                    // Categoría activa: navega a su detalle
                    else if (categoria.activo) {
                      if (categoria.nombre == 'Software') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleSoftwareScreen(categoria: categoria),
                          ),
                        );
                      } else if (categoria.nombre == 'Sistemas Operativos') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('¡Muy amable!'),
                            content: const Text('Gracias por usar la app'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleCategoriaScreen(categoria: categoria),
                          ),
                        );
                      }
                    }
                    // Categoría inactiva: muestra advertencia
                    else {
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
                      // Contenedor del ícono con fondo y borde
                      Container(
                        width: 85,
                        height: 85,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              fondoColor, // color de fondo mejorado para contraste
                          border: Border.all(color: bordeColor, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset(
                          categoria.iconoPath,
                          color:
                              iconColor, // color adaptativo para accesibilidad
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Información textual
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoria.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (categoria.completado)
                              const Text(
                                '¡Completado!',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32), // verde fuerte
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              Text(
                                categoria.activo
                                    ? '¡Habilitado!'
                                    : 'Deshabilitado',
                                style: TextStyle(
                                  color: categoria.activo
                                      ? Colors.purple
                                      : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
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
