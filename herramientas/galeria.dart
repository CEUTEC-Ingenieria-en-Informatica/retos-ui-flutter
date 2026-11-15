// Arma la galería del README con las soluciones que hay en cada reto.
//
// Uso (desde la raíz del repo):
//   dart run herramientas/galeria.dart            reescribe la galería en README.md
//   dart run herramientas/galeria.dart --revisar  solo dice si está al día (sale con 1 si no)
//
// Lo corre quien mantiene el repo después de aceptar soluciones, así los PR no chocan en el README.

import 'dart:io';

const inicio = '<!-- galeria:inicio -->';
const fin = '<!-- galeria:fin -->';

void main(List<String> args) {
  final readme = File('README.md');
  if (!readme.existsSync() || !Directory('retos').existsSync()) {
    stderr.writeln('Corré esto desde la raíz del repo.');
    exit(2);
  }

  final filas = <String>[];
  final retos = Directory('retos')
      .listSync()
      .whereType<Directory>()
      .map((d) => d.path.replaceAll('\\', '/'))
      .where((p) => RegExp(r'/\d\d-[^/]+$').hasMatch(p))
      .toList()
    ..sort();

  var total = 0;
  for (final ruta in retos) {
    final nombre = ruta.split('/').last;
    final leeme = File('$ruta/README.md');
    var titulo = nombre;
    var nivel = '';
    if (leeme.existsSync()) {
      final texto = leeme.readAsStringSync();
      titulo = RegExp(r'^# (.+)$', multiLine: true).firstMatch(texto)?.group(1)?.trim() ?? nombre;
      nivel = RegExp(r'^Nivel: (\S+)', multiLine: true).firstMatch(texto)?.group(1) ?? '';
    }
    final soluciones = Directory('$ruta/soluciones').existsSync()
        ? (Directory('$ruta/soluciones')
            .listSync()
            .whereType<Directory>()
            .map((d) => d.path.replaceAll('\\', '/').split('/').last)
            .where((u) => u != 'referencia')
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())))
        : <String>[];
    total += soluciones.length;
    final enlaces = soluciones.isEmpty
        ? 'Todavía nadie. ¡Estrená este reto!'
        : soluciones.map((u) => '[@$u](retos/$nombre/soluciones/$u/)').join(' · ');
    filas.add('| [$titulo](retos/$nombre/) | $nivel | ${soluciones.length} | $enlaces |');
  }

  final tabla = [
    inicio,
    '',
    'Soluciones de la comunidad: $total. La de referencia de cada reto no se cuenta.',
    '',
    '| Reto | Nivel | Soluciones | Quiénes |',
    '|---|---|---|---|',
    ...filas,
    '',
    fin,
  ].join('\n');

  final actual = readme.readAsStringSync().replaceAll('\r\n', '\n');
  final a = actual.indexOf(inicio);
  final b = actual.indexOf(fin);
  if (a < 0 || b < a) {
    stderr.writeln('El README no tiene las marcas $inicio y $fin.');
    exit(2);
  }
  final nuevo = actual.substring(0, a) + tabla + actual.substring(b + fin.length);

  if (args.contains('--revisar')) {
    if (nuevo != actual) {
      stdout.writeln('La galería no está al día. Corré: dart run herramientas/galeria.dart');
      exit(1);
    }
    stdout.writeln('La galería está al día ($total soluciones).');
    return;
  }
  readme.writeAsStringSync(nuevo);
  stdout.writeln('Galería actualizada: $total soluciones.');
}
