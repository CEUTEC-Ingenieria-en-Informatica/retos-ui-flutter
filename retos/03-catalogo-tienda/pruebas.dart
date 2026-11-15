// Pruebas del reto 03: catálogo de una tienda. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

void probar(CrearReto crear, {required String quien}) {
  group('03 catálogo de tienda ($quien)', () {
    testWidgets('muestra el nombre de la tienda y las categorías', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Tiendita Barrilete'), findsOneWidget);
      for (final c in ['Todo', 'Ropa', 'Hogar', 'Accesorios']) {
        expect(find.text(c), findsOneWidget, reason: 'Falta la categoría "$c"');
      }
    });

    testWidgets('los primeros productos se ven con su precio en lempiras', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Camisa de manta'), findsOneWidget);
      expect(find.text('L 450.00'), findsOneWidget);
      expect(find.text('Gorra bordada'), findsOneWidget);
      expect(find.text('L 280.00'), findsOneWidget);
    });

    testWidgets('la cuadrícula tiene dos columnas', (tester) async {
      await abrir(tester, crear);
      final camisa = tester.getTopLeft(find.text('Camisa de manta'));
      final gorra = tester.getTopLeft(find.text('Gorra bordada'));
      final taza = tester.getTopLeft(find.text('Taza de barro'));
      expect(gorra.dy, closeTo(camisa.dy, 2), reason: 'Camisa y gorra van en la misma fila');
      expect(gorra.dx, greaterThan(camisa.dx + 100), reason: 'La gorra va a la derecha');
      expect(taza.dy, greaterThan(camisa.dy + 100), reason: 'La taza ya va en la segunda fila');
      expect(taza.dx, closeTo(camisa.dx, 2), reason: 'La taza empieza otra vez a la izquierda');
    });

    testWidgets('los filtros dejan solo los productos de esa categoría', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, find.text('Hogar'));
      expect(find.text('Taza de barro'), findsOneWidget);
      expect(find.text('Hamaca de colores'), findsOneWidget);
      expect(find.text('L 1,350.00'), findsOneWidget, reason: 'Los miles llevan coma: L 1,350.00');
      expect(find.text('Camisa de manta'), findsNothing);
      expect(find.text('Gorra bordada'), findsNothing);
      await tocar(tester, find.text('Accesorios'));
      expect(find.text('Bolso de tule'), findsOneWidget);
      expect(find.text('Taza de barro'), findsNothing);
    });

    testWidgets('agregar suma en el contador del carrito', (tester) async {
      await abrir(tester, crear);
      expect(clave('contador-carrito'), findsOneWidget);
      await tocar(tester, clave('agregar-camisa-manta'));
      expect(textoEn('contador-carrito', '1'), findsOneWidget);
      await tocar(tester, clave('agregar-gorra-bordada'));
      await tocar(tester, clave('agregar-camisa-manta'));
      expect(textoEn('contador-carrito', '3'), findsOneWidget);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(find.text('Camisa de manta'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
