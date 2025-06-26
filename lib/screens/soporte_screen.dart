import 'package:flutter/material.dart';

// Widget principal de la pantalla Soporte, que mantiene estado (stateful)
class SoporteScreen extends StatefulWidget {
  const SoporteScreen({super.key});

  @override
  State<SoporteScreen> createState() => _SoporteScreenState();
}

// Estado de la pantalla Soporte
class _SoporteScreenState extends State<SoporteScreen> {
  // Controladores para los campos de texto, precargados con nombre y correo
  final TextEditingController nombreController = TextEditingController(
    text: 'Michelle Coronel', // Valor inicial para el nombre
  );
  final TextEditingController correoController = TextEditingController(
    text: 'adril14mishy@gmail.com', // Valor inicial para el correo
  );
  final TextEditingController mensajeController =
      TextEditingController(); // Para el mensaje a enviar

  // Variables para guardar la categoría y asunto seleccionados en los dropdowns
  String? categoriaSeleccionada;
  String? asuntoSeleccionado;

  // Listas con opciones para categorías y asuntos
  final List<String> categorias = ['Accesibilidad', 'Errores técnicos', 'Otro'];
  final List<String> asuntos = ['Bug', 'Sugerencia', 'Consulta'];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema actual es oscuro para adaptar colores
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Soporte')), // Barra superior con título
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ), // Padding general en toda la pantalla
        child: Column(
          children: [
            const SizedBox(height: 10), // Espacio vertical
            const Text(
              'Por favor, no dudes en reportar cualquier problema que notes\n'
              'para que podamos ayudarte y/o ayudar a los demás',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Mensaje inicial informativo
            const SizedBox(height: 24), // Espacio vertical
            // Sección para mostrar nombre y correo en campos deshabilitados
            _buildCard(
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinea texto a la izquierda
                children: [
                  const Text(
                    'Nombre de usuario',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Etiqueta para el campo nombre
                  const SizedBox(height: 8),
                  TextFormField(
                    controller:
                        nombreController, // Controlador para el texto del nombre
                    enabled: false, // Campo deshabilitado para no editar
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black, // Color según tema
                    ),
                    decoration: _inputDecoration(
                      isDark,
                    ), // Estilos personalizados para el input
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Correo electrónico',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Etiqueta para el campo correo
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: correoController, // Controlador para el correo
                    enabled: false, // Campo deshabilitado para no editar
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: _inputDecoration(isDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sección para seleccionar categoría, asunto y escribir mensaje
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categoría',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Etiqueta para categoría
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration(
                      isDark,
                    ), // Decoración del dropdown
                    value:
                        categoriaSeleccionada, // Valor seleccionado actualmente
                    hint: const Text('Seleccione una categoría'), // Texto guía
                    dropdownColor: isDark
                        ? Colors.grey.shade800
                        : Colors.white, // Fondo del dropdown
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ), // Color del texto
                    items: categorias
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(), // Lista de opciones convertida en widgets
                    onChanged: (value) {
                      setState(() {
                        categoriaSeleccionada =
                            value; // Actualiza categoría seleccionada
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Asunto',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Etiqueta para asunto
                  const SizedBox(height: 8),
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
                        .toList(), // Opciones para asunto
                    onChanged: (value) {
                      setState(() {
                        asuntoSeleccionado =
                            value; // Actualiza asunto seleccionado
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mensaje',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Etiqueta para mensaje
                  const SizedBox(height: 8),
                  TextFormField(
                    controller:
                        mensajeController, // Controlador del campo de mensaje
                    maxLines: 5, // Permite que el campo tenga varias líneas
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: _inputDecoration(isDark).copyWith(
                      hintText:
                          'Escribe lo que deseas transmitirnos', // Texto guía
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

            // Botón para enviar soporte
            SizedBox(
              width: double.infinity, // Ocupa todo el ancho posible
              child: ElevatedButton(
                onPressed: () {
                  // Al presionar muestra un mensaje tipo SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Soporte enviado!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Fondo amarillo
                  foregroundColor: Colors.black, // Texto negro
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Padding vertical
                ),
                child: const Text('Enviar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método privado para construir una "card" con estilos comunes
  Widget _buildCard(Widget child) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // Detecta tema
    return Container(
      padding: const EdgeInsets.all(16), // Padding interno
      margin: const EdgeInsets.only(bottom: 16), // Margen inferior
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade800
            : Colors.grey.shade100, // Fondo según tema
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        border: Border.all(color: Colors.grey.shade400), // Borde gris claro
      ),
      child: child, // Contenido pasado por parámetro
    );
  }

  // Método privado para construir la decoración de campos de texto y dropdowns
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true, // Campo relleno
      fillColor: isDark ? Colors.grey.shade700 : Colors.white, // Color de fondo
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Padding interno
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        borderSide: BorderSide(color: Colors.grey.shade300), // Color borde
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ), // Mismo estilo para borde habilitado
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
