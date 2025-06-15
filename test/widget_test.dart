import 'package:flutter_test/flutter_test.dart';
import 'package:bitysoft/main.dart';
import 'package:bitysoft/screens/splash_screen.dart'; // Importa SplashScreen para usarlo en el test

void main() {
  testWidgets(
    'La aplicación BitySoftApp se carga correctamente y muestra SplashScreen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BitySoftApp());
      await tester.pumpAndSettle(); // Espera a que se construya la UI

      expect(
        find.byType(SplashScreen),
        findsOneWidget,
      ); // Verifica que SplashScreen está visible
    },
  );
}
