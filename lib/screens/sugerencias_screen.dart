import 'package:flutter/material.dart';

// Pantalla Stateful para recibir sugerencias del usuario
class SugerenciasScreen extends StatefulWidget {
  const SugerenciasScreen({super.key});

  @override
  State<SugerenciasScreen> createState() => _SugerenciasScreenState();
}

class _SugerenciasScreenState extends State<SugerenciasScreen> {
  // Variables para almacenar las opciones seleccionadas en los dropdowns
  String? categoriaSeleccionada;
  String? asuntoSeleccionado;

  // Controlador para el campo de texto del mensaje
  final TextEditingController mensajeController = TextEditingController();

  // Listas con las opciones de categorías y asuntos para los dropdowns
  final List<String> categorias = ['Accesibilidad', 'Contenido', 'Otro'];
  final List<String> asuntos = ['Error', 'Mejora', 'Consulta'];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema es oscuro para adaptar colores
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias'),
      ), // Barra superior con título
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Padding general
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Escríbenos si tienes algún comentario o sugerencia para poder mejorar BitySoft',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ), // Mensaje introductorio
            const SizedBox(height: 24),

            // Contenedor principal con bordes y fondo adaptado a tema
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiqueta categoría
                  const Text(
                    'Categoría',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown para seleccionar categoría
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration(isDark),
                    value: categoriaSeleccionada,
                    hint: const Text('Seleccione una categoría'),
                    dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: categorias
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        categoriaSeleccionada =
                            value; // Actualiza estado al seleccionar
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Etiqueta asunto
                  const Text(
                    'Asunto',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown para seleccionar asunto
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration(isDark),
                    value: asuntoSeleccionado,
                    hint: const Text('Asunto'),
                    dropdownColor: isDark ? Colors.grey.shade800 : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: asuntos
                        .map(
                          (asu) =>
                              DropdownMenuItem(value: asu, child: Text(asu)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        asuntoSeleccionado =
                            value; // Actualiza estado al seleccionar
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Etiqueta mensaje
                  const Text(
                    'Mensaje',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Campo de texto para escribir el mensaje
                  TextFormField(
                    controller: mensajeController,
                    maxLines: 5, // Varias líneas
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: _inputDecoration(isDark).copyWith(
                      hintText: 'Escribe lo que deseas transmitirnos',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botón para enviar la sugerencia
            SizedBox(
              width: double.infinity, // Ancho completo
              child: ElevatedButton(
                onPressed: () {
                  // Muestra un mensaje temporal cuando se presiona el botón
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Mensaje enviado!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Fondo amarillo
                  foregroundColor: Colors.black, // Texto negro
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Enviar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para decoración común de inputs, adapta colores para modo oscuro
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? Colors.grey.shade700 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
