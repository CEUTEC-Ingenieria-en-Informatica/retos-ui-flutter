// Pruebas del reto 05: bienvenida de tres pasos. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

const _titulos = ['Guardá sin darte cuenta', 'Metas que sí se cumplen', 'Mirá cómo crece'];

void probar(CrearReto crear, {required String quien}) {
  group('05 bienvenida de tres pasos ($quien)', () {
    testWidgets('arranca en el paso 1 con Siguiente y Saltar', (tester) async {
      await abrir(tester, crear);
      expect(find.text(_titulos[0]), findsOneWidget);
      expect(find.textContaining('Redondeá tus compras'), findsOneWidget);
      expect(textoEn('indicador-paso', '1 de 3'), findsOneWidget);
      expect(textoEn('boton-siguiente', 'Siguiente'), findsOneWidget);
      expect(textoEn('boton-saltar', 'Saltar'), findsOneWidget);
    });

    testWidgets('Siguiente avanza de un paso en un paso', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('boton-siguiente'));
      expect(find.text(_titulos[1]), findsOneWidget);
      expect(textoEn('indicador-paso', '2 de 3'), findsOneWidget);
      await tocar(tester, clave('boton-siguiente'));
      expect(find.text(_titulos[2]), findsOneWidget);
      expect(textoEn('indicador-paso', '3 de 3'), findsOneWidget);
    });

    testWidgets('en el último paso el botón dice Empezar y ya no hay Saltar', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('boton-siguiente'));
      await tocar(tester, clave('boton-siguiente'));
      expect(textoEn('boton-siguiente', 'Empezar'), findsOneWidget);
      expect(clave('boton-saltar'), findsNothing);
    });

    testWidgets('Empezar lleva a la pantalla final', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('boton-siguiente'));
      await tocar(tester, clave('boton-siguiente'));
      await tocar(tester, clave('boton-siguiente'));
      expect(find.text('Todo listo'), findsOneWidget);
      expect(find.text('Tu alcancía te espera.'), findsOneWidget);
      expect(clave('boton-siguiente'), findsNothing);
    });

    testWidgets('Saltar lleva directo a la pantalla final', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('boton-saltar'));
      expect(find.text('Todo listo'), findsOneWidget);
    });

    testWidgets('también se avanza deslizando', (tester) async {
      await abrir(tester, crear);
      expect(clave('paginas'), findsOneWidget);
      await tester.drag(clave('paginas'), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(find.text(_titulos[1]), findsOneWidget);
      expect(textoEn('indicador-paso', '2 de 3'), findsOneWidget);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(find.text(_titulos[0]), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
