import 'package:flutter/material.dart';

// Pantalla para que el usuario sugiera un nuevo tema para la aplicación
class SugerirTemaScreen extends StatefulWidget {
  const SugerirTemaScreen({super.key});

  @override
  State<SugerirTemaScreen> createState() => _SugerirTemaScreenState();
}

class _SugerirTemaScreenState extends State<SugerirTemaScreen> {
  // Controlador para manejar el texto ingresado en el campo "Título del tema"
  final TextEditingController tituloController = TextEditingController();

  // Variable para almacenar la categoría seleccionada en el dropdown
  String? categoriaSeleccionada;

  // Key para identificar y controlar el estado del formulario, necesario para validaciones
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Lista de categorías disponibles para que el usuario seleccione
  final List<String> categorias = [
    'Programación',
    'Desarrollo web',
    'Redes',
    'Seguridad',
    'Bases de datos',
  ];

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema de la app es oscuro para adaptar estilos visuales
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Barra superior con el título de la pantalla
      appBar: AppBar(title: const Text('Sugerir tema')),

      // Contenido principal de la pantalla
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ), // Espaciado interno en toda la pantalla
        child: Form(
          key: _formKey, // Asocia el formulario a la key para validar
          child: Column(
            children: [
              const SizedBox(height: 10), // Espacio vertical pequeño
              const Text(
                '¿Te gustaría que incluyéramos algún tema en nuestra aplicación? ¡No esperes más y cuéntanos cuál es!',
                textAlign: TextAlign.center, // Texto centrado
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 24,
              ), // Espacio vertical entre texto y formulario

              Container(
                padding: const EdgeInsets.all(
                  16,
                ), // Padding interno del contenedor
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100, // Fondo según tema
                  borderRadius: BorderRadius.circular(16), // Bordes redondeados
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ), // Borde gris claro
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinear al inicio (izquierda)
                  children: [
                    // Etiqueta para el campo título
                    const Text(
                      'Título del tema',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Campo para ingresar el título del tema sugerido
                    TextFormField(
                      controller:
                          tituloController, // Controlador para obtener el texto
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black, // Color según tema
                      ),
                      decoration: _inputDecoration(isDark).copyWith(
                        hintText:
                            'Ej. Almacenamiento de archivos', // Texto placeholder
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        ),
                      ),
                      // Validador para asegurar que no esté vacío
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un título'; // Mensaje de error
                        }
                        return null; // Campo válido
                      },
                    ),
                    const SizedBox(height: 16),

                    // Etiqueta para el dropdown de categoría
                    const Text(
                      'Categoría',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown para seleccionar la categoría del tema
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        isDark,
                      ), // Estilo del dropdown
                      value: categoriaSeleccionada, // Valor seleccionado actual
                      hint: const Text(
                        'Seleccione una categoría',
                      ), // Placeholder
                      dropdownColor: isDark
                          ? Colors.grey.shade800
                          : Colors.white,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black, // Color del texto
                      ),
                      items: categorias
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat, // Valor que se guarda
                              child: Text(cat), // Texto visible
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        // Actualiza el estado con la categoría seleccionada
                        setState(() {
                          categoriaSeleccionada = value;
                        });
                      },
                      // Validador para asegurarse que se seleccione una categoría
                      validator: (value) => value == null
                          ? 'Por favor selecciona una categoría'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botón para enviar la sugerencia
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  onPressed: () {
                    // Al presionar, valida el formulario completo
                    if (_formKey.currentState!.validate()) {
                      // Si es válido, muestra un diálogo de confirmación accesible
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Para obligar a usar el botón OK y asegurar confirmación
                        builder: (context) {
                          return AlertDialog(
                            title: Semantics(
                              // Etiqueta para lector de pantalla en el título
                              header: true,
                              child: const Text('Confirmación'),
                            ),
                            content: Semantics(
                              liveRegion:
                                  true, // Hace que lectores detecten el cambio inmediatamente
                              child: const Text('¡Tema sugerido con éxito!'),
                            ),
                            actions: [
                              FocusScope(
                                autofocus: true, // Pone foco en el botón OK
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Cierra el diálogo
                                    // Limpia campos después de cerrar el diálogo
                                    tituloController.clear();
                                    setState(() {
                                      categoriaSeleccionada = null;
                                    });
                                  },
                                  child: const Text('OK'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
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
      ),
    );
  }

  // Método que devuelve la decoración para los campos de texto y dropdown
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true, // Rellenar fondo
      fillColor: isDark
          ? Colors.grey.shade700
          : Colors.white, // Color fondo según tema
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Padding interno
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        borderSide: BorderSide(color: Colors.grey.shade300), // Color del borde
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ), // Bordes para estado habilitado
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
