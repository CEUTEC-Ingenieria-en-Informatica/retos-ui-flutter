// Pruebas del reto 07: chat con burbujas. Revisan lo que pide el README, no cómo lo armaste.
import 'package:flutter_test/flutter_test.dart';

import '../../herramientas/ayuda_pruebas.dart';

const _mios = ['Sí, la terminé anoche', 'Dale, te mando foto en un rato'];
const _suyos = ['¿Ya tenés la guía de física?', '¿Me la pasás? Me quedé en el ejercicio 4', 'Sos lo máximo'];

void probar(CrearReto crear, {required String quien}) {
  group('07 chat con burbujas ($quien)', () {
    testWidgets('el encabezado muestra el contacto y su estado', (tester) async {
      await abrir(tester, crear);
      expect(find.text('Mateo Zelaya'), findsOneWidget);
      expect(find.text('en línea'), findsOneWidget);
      expect(find.text('Hoy'), findsOneWidget);
    });

    testWidgets('trae los cinco mensajes con su hora', (tester) async {
      await abrir(tester, crear);
      for (final m in [..._mios, ..._suyos]) {
        expect(find.text(m), findsOneWidget, reason: 'Falta el mensaje "$m"');
      }
      expect(find.text('7:40 a. m.'), findsOneWidget);
      expect(find.text('7:44 a. m.'), findsOneWidget);
    });

    testWidgets('mis mensajes van a la derecha y los de Mateo a la izquierda', (tester) async {
      await abrir(tester, crear);
      final mitad = telefono.width / 2;
      for (final m in _mios) {
        expect(tester.getCenter(find.text(m)).dx, greaterThan(mitad), reason: '"$m" es mío: va a la derecha');
      }
      for (final m in _suyos) {
        expect(tester.getCenter(find.text(m)).dx, lessThan(mitad), reason: '"$m" es de Mateo: va a la izquierda');
      }
    });

    testWidgets('ninguna burbuja pasa del 75% del ancho', (tester) async {
      await abrir(tester, crear);
      final largo = find.text('¿Me la pasás? Me quedé en el ejercicio 4');
      expect(tester.getSize(largo).width, lessThanOrEqualTo(telefono.width * 0.75));
    });

    testWidgets('enviar agrega mi mensaje a la derecha y limpia el campo', (tester) async {
      await abrir(tester, crear);
      await escribir(tester, 'campo-mensaje', 'Nos vemos en la biblio');
      await tocar(tester, clave('boton-enviar'));
      expect(find.text('Nos vemos en la biblio'), findsOneWidget);
      expect(find.text('Ahora'), findsOneWidget);
      expect(tester.getCenter(find.text('Nos vemos en la biblio')).dx, greaterThan(telefono.width / 2));
      expect(campoEn(tester, 'campo-mensaje').controller.text, isEmpty);
    });

    testWidgets('un mensaje vacío o con solo espacios no se envía', (tester) async {
      await abrir(tester, crear);
      await escribir(tester, 'campo-mensaje', '   ');
      await tocar(tester, clave('boton-enviar'));
      expect(find.text('Ahora'), findsNothing);
    });

    testWidgets('cabe en un teléfono chico sin desbordarse', (tester) async {
      await abrir(tester, crear, tamano: telefonoChico);
      expect(clave('campo-mensaje'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
