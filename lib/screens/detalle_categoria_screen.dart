import 'package:flutter/material.dart';
import 'lecciones_screen.dart'; // aquí está la definición de Categoria
import 'quiz_screen.dart';

class DetalleCategoriaScreen extends StatelessWidget {
  final Categoria categoria;

  const DetalleCategoriaScreen({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoria.nombre,
          style:
              Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¿Qué es el hardware?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/images/hardware.jpeg'),
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                '\nEl hardware es todo lo que puedes tocar en una computadora o dispositivo. '
                                'Son las partes físicas como el teclado, la pantalla, el ratón, etc.\n\n'
                                'Ejemplos de hardware comunes:\n\n',
                          ),
                          TextSpan(
                            text: '1. Monitor:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Muestra información en pantalla (salida)\n\n',
                          ),
                          TextSpan(
                            text: '2. Teclado:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Se usa para escribir y tiene letras, números y símbolos (entrada)\n\n',
                          ),
                          TextSpan(
                            text: '3. Ratón:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Se usa para mover el cursor y hacer clic\n\n',
                          ),
                          TextSpan(
                            text: '4. CPU o torre:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Es el cerebro del computador, es decir, donde se procesan los datos (proceso)\n\n',
                          ),
                          TextSpan(
                            text: '5. Impresora:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Saca los documentos en papel\n\n'),
                          TextSpan(
                            text: '6. Altavoces:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Reproducen sonido\n\n'),
                          TextSpan(
                            text: '7. Cámara web:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Sirve para hacer videollamadas\n\n'),
                          TextSpan(
                            text: '8. Micrófono:\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Permite grabar o hablar en videollamadas\n',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //Navega a QuizScreen (agrega import y ajusta ruta)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                elevation: 6,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text('Iniciar Quiz', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
