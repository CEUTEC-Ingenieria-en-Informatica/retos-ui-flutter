// Pruebas del reto 04: detalle de producto con galería. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

void probar(CrearReto crear, {required String quien}) {
  group('04 detalle con galería ($quien)', () {
    testWidgets('muestra nombre, precio, valoración y descripción', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Mochila tejida'), findsOneWidget);
      expect(find.text('L 590.00'), findsOneWidget);
      expect(find.textContaining('4.8'), findsWidgets);
      expect(find.textContaining('126 reseñas'), findsOneWidget);
      expect(find.textContaining('Tejida a mano'), findsOneWidget);
    });

    testWidgets('la galería ocupa todo el ancho y arranca en 1 / 4', (tester) async {
      await abrir(tester, crear);
      expect(clave('galeria'), findsOneWidget);
      midaCerca(tester, clave('galeria'), ancho: telefono.width, alto: 360);
      expect(textoEn('indicador-foto', '1 / 4'), findsOneWidget);
    });

    testWidgets('deslizar la galería pasa a la siguiente foto', (tester) async {
      await abrir(tester, crear);
      await tester.drag(clave('galeria'), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(textoEn('indicador-foto', '2 / 4'), findsOneWidget);
    });

    testWidgets('tocar una miniatura salta a esa foto', (tester) async {
      await abrir(tester, crear);
      await tocar(tester, clave('miniatura-3'));
      expect(textoEn('indicador-foto', '4 / 4'), findsOneWidget);
      await tocar(tester, clave('miniatura-0'));
      expect(textoEn('indicador-foto', '1 / 4'), findsOneWidget);
    });

    testWidgets('se puede elegir la talla', (tester) async {
      await abrir(tester, crear);
      for (final t in ['Pequeña', 'Mediana', 'Grande']) {
        expect(find.text(t), findsOneWidget, reason: 'Falta la talla "$t"');
      }
    });

    testWidgets('la cantidad no baja de 1 y el total se actualiza', (tester) async {
      await abrir(tester, crear);
      expect(textoEn('cantidad', '1'), findsOneWidget);
      await tocar(tester, clave('menos'));
      expect(textoEn('cantidad', '1'), findsOneWidget, reason: 'La cantidad mínima es 1');
      await tocar(tester, clave('mas'));
      expect(textoEn('cantidad', '2'), findsOneWidget);
      expect(
        find.descendant(of: clave('boton-agregar'), matching: find.textContaining('L 1,180.00')),
        findsOneWidget,
        reason: 'El botón muestra el total: 2 x L 590.00',
      );
    });

    testWidgets('el corazón marca y desmarca favorito', (tester) async {
      await abrir(tester, crear);
      expect(find.descendant(of: clave('favorito'), matching: find.byIcon(Icons.favorite_border)),
          findsOneWidget);
      await tocar(tester, clave('favorito'));
      expect(find.descendant(of: clave('favorito'), matching: find.byIcon(Icons.favorite)),
          findsOneWidget);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(clave('boton-agregar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
