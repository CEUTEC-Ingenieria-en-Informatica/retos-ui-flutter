// Pruebas del reto 08: clima con modo oscuro. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

const _ciudad = 'La Esperanza, Intibucá';

Brightness _brillo(WidgetTester tester) => Theme.of(tester.element(find.text(_ciudad))).brightness;

Color? _fondoDelScaffold(WidgetTester tester) {
  final scaffold = find.byType(Scaffold).first;
  final material = find.descendant(of: scaffold, matching: find.byType(Material)).first;
  return tester.widget<Material>(material).color;
}

void probar(CrearReto crear, {required String quien}) {
  group('08 clima con modo oscuro ($quien)', () {
    testWidgets('muestra ciudad, temperatura y detalles', (tester) async {
      await abrir(tester, crear);
      expect(find.text(_ciudad), findsOneWidget);
      expect(find.text('17°'), findsOneWidget);
      expect(find.text('Llovizna'), findsOneWidget);
      expect(find.textContaining('Máx 21°'), findsOneWidget);
      expect(find.textContaining('Mín 12°'), findsOneWidget);
      for (final t in ['Humedad', '84%', 'Viento', '9 km/h', 'Lluvia', '60%']) {
        expect(find.text(t), findsOneWidget, reason: 'Falta "$t"');
      }
    });

    testWidgets('el pronóstico por hora se desliza de lado', (tester) async {
      await abrir(tester, crear);
      expect(clave('pronostico-horas'), findsOneWidget);
      final scroll = tester.widget<Scrollable>(
        find.descendant(of: clave('pronostico-horas'), matching: find.byType(Scrollable), matchRoot: true).first,
      );
      expect(scroll.axisDirection, AxisDirection.right);
      expect(find.text('9 a. m.'), findsOneWidget);
      expect(find.text('16°'), findsOneWidget);
    });

    testWidgets('abre en claro si el teléfono está en claro', (tester) async {
      await abrir(tester, crear, brilloDelSistema: Brightness.light);
      expect(_brillo(tester), Brightness.light);
    });

    testWidgets('abre en oscuro si el teléfono está en oscuro', (tester) async {
      await abrir(tester, crear, brilloDelSistema: Brightness.dark);
      expect(_brillo(tester), Brightness.dark);
    });

    testWidgets('el botón cambia el tema y de verdad cambian los colores', (tester) async {
      await abrir(tester, crear);
      final fondoClaro = _fondoDelScaffold(tester);
      final textoClaro = colorDelTexto(tester, '17°');
      await tocar(tester, clave('cambiar-tema'));
      expect(_brillo(tester), Brightness.dark);
      expect(_fondoDelScaffold(tester), isNot(fondoClaro), reason: 'El fondo tiene que cambiar');
      expect(colorDelTexto(tester, '17°'), isNot(textoClaro), reason: 'El color del texto tiene que cambiar');
      await tocar(tester, clave('cambiar-tema'));
      expect(_brillo(tester), Brightness.light);
      expect(_fondoDelScaffold(tester), fondoClaro);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico, brilloDelSistema: Brightness.dark);
      expect(find.text(_ciudad), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
