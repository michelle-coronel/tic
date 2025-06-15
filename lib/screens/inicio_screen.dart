import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  final VoidCallback onIniciarPressed;

  const InicioScreen({super.key, required this.onIniciarPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/inicio1.png', width: 180),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onIniciarPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 20,
                  // ignore: deprecated_member_use
                  shadowColor: Colors.amber.withOpacity(0.4),
                ),
                child: const Text('INICIAR', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
