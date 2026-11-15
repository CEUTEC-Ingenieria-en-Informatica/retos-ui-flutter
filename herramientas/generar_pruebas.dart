// Busca las soluciones de cada reto y arma un archivo de prueba por solución.
//
// Uso:
//   dart run herramientas/generar_pruebas.dart
//       Todas las soluciones de todos los retos.
//   dart run herramientas/generar_pruebas.dart --reto 01-tarjeta-perfil --usuario tu-usuario
//       Solo tu solución (y la de referencia) de ese reto.
//   dart run herramientas/generar_pruebas.dart --cambios cambios.txt --autor tu-usuario
//       Lo usa el workflow: prueba solo lo que tocó el PR.
//
// Escribe en test/generado (soluciones, tienen que pasar) y en test/contraprueba
// (la plantilla vacía, tiene que fallar). Las dos carpetas se borran y se arman de nuevo.
// Después corré:  flutter test test/generado

import 'dart:io';

const referencia = 'referencia';
final usuarioValido = RegExp(r'^[A-Za-z0-9](?:[A-Za-z0-9-]{0,38})$');
const extensionesPermitidas = {'.dart', '.md'};
const rutasGenerales = [
  'herramientas/',
  'plantilla/',
  'pubspec.yaml',
  'pubspec.lock',
  '.github/workflows/',
];

void main(List<String> args) {
  final opciones = _leerOpciones(args);
  final raiz = Directory.current;
  final carpetaRetos = Directory('${raiz.path}/retos');
  if (!carpetaRetos.existsSync()) {
    _salir('Corré esto desde la raíz del repo (no encontré la carpeta retos).');
  }

  final retos = carpetaRetos
      .listSync()
      .whereType<Directory>()
      .map((d) => _nombre(d.path))
      .where((n) => RegExp(r'^\d\d-').hasMatch(n))
      .toList()
    ..sort();

  final errores = <String>[];
  // reto -> usuarios a probar
  final elegidos = <String, Set<String>>{};

  void agregar(String reto, String usuario) {
    if (!retos.contains(reto)) return;
    elegidos.putIfAbsent(reto, () => {referencia}).add(usuario);
  }

  void agregarTodas(String reto) {
    for (final u in _soluciones(reto)) {
      agregar(reto, u);
    }
    elegidos.putIfAbsent(reto, () => {referencia});
  }

  if (opciones['cambios'] != null) {
    final cambios = File(opciones['cambios']!)
        .readAsLinesSync()
        .map((l) => l.trim().replaceAll('\\', '/'))
        .where((l) => l.isNotEmpty);
    final autor = opciones['autor']?.toLowerCase();
    for (final ruta in cambios) {
      final partes = ruta.split('/');
      if (rutasGenerales.any(ruta.startsWith)) {
        for (final r in retos) {
          elegidos.putIfAbsent(r, () => {referencia});
        }
      } else if (partes.length >= 4 && partes[0] == 'retos' && partes[2] == 'soluciones') {
        final reto = partes[1];
        final usuario = partes[3];
        if (autor != null &&
            autor.isNotEmpty &&
            usuario != referencia &&
            usuario.toLowerCase() != autor) {
          errores.add('$ruta: solo podés tocar tu carpeta (soluciones/$autor).');
        }
        if (Directory('retos/$reto/soluciones/$usuario').existsSync()) {
          agregar(reto, usuario);
        }
      } else if (partes.length >= 2 && partes[0] == 'retos') {
        agregarTodas(partes[1]);
      }
    }
  } else if (opciones['reto'] != null) {
    final reto = opciones['reto']!;
    if (!retos.contains(reto)) {
      _salir('No existe el reto "$reto". Los retos son: ${retos.join(', ')}');
    }
    final usuario = opciones['usuario'];
    if (usuario != null) {
      agregar(reto, usuario);
    } else {
      agregarTodas(reto);
    }
  } else {
    retos.forEach(agregarTodas);
  }

  final generado = Directory('test/generado');
  final contraprueba = Directory('test/contraprueba');
  for (final d in [generado, contraprueba]) {
    if (d.existsSync()) d.deleteSync(recursive: true);
    d.createSync(recursive: true);
  }

  var total = 0;
  for (final reto in elegidos.keys.toList()..sort()) {
    if (!File('retos/$reto/pruebas.dart').existsSync()) {
      errores.add('retos/$reto: falta pruebas.dart.');
      continue;
    }
    for (final usuario in elegidos[reto]!.toList()..sort()) {
      final carpeta = 'retos/$reto/soluciones/$usuario';
      final problema = _revisarCarpeta(carpeta, usuario);
      if (problema != null) {
        errores.add(problema);
        continue;
      }
      _escribirPrueba(
        '${generado.path}/${reto}__${usuario}_test.dart',
        reto,
        '../../$carpeta/solucion.dart',
        usuario,
      );
      total++;
    }
    _escribirPrueba(
      '${contraprueba.path}/${reto}_test.dart',
      reto,
      '../../plantilla/solucion.dart',
      'plantilla',
    );
  }

  stdout.writeln('Pruebas generadas: $total soluciones en ${elegidos.length} retos.');
  for (final reto in elegidos.keys.toList()..sort()) {
    stdout.writeln('  $reto: ${(elegidos[reto]!.toList()..sort()).join(', ')}');
  }
  if (errores.isNotEmpty) {
    stderr.writeln('\nHay cosas que arreglar:');
    for (final e in errores) {
      stderr.writeln('  $e');
    }
    exit(1);
  }
}

String? _revisarCarpeta(String carpeta, String usuario) {
  final dir = Directory(carpeta);
  if (!dir.existsSync()) return '$carpeta: no existe.';
  if (usuario != referencia && !usuarioValido.hasMatch(usuario)) {
    return '$carpeta: el nombre de la carpeta tiene que ser tu usuario de GitHub.';
  }
  if (!File('$carpeta/solucion.dart').existsSync()) {
    return '$carpeta: falta solucion.dart (copiá plantilla/solucion.dart).';
  }
  for (final f in dir.listSync(recursive: true).whereType<File>()) {
    final nombre = _nombre(f.path);
    final punto = nombre.lastIndexOf('.');
    final ext = punto < 0 ? '' : nombre.substring(punto).toLowerCase();
    if (!extensionesPermitidas.contains(ext)) {
      return '$carpeta/$nombre: en tu carpeta solo van archivos .dart y .md.';
    }
  }
  return null;
}

void _escribirPrueba(String destino, String reto, String importSolucion, String quien) {
  File(destino).writeAsStringSync('''
// Generado por herramientas/generar_pruebas.dart. No lo edites a mano.
import '../../retos/$reto/pruebas.dart' as reto;
import '$importSolucion' as solucion;

void main() => reto.probar(() => solucion.Reto(), quien: '$quien');
''');
}

List<String> _soluciones(String reto) {
  final dir = Directory('retos/$reto/soluciones');
  if (!dir.existsSync()) return [];
  return dir.listSync().whereType<Directory>().map((d) => _nombre(d.path)).toList()..sort();
}

String _nombre(String ruta) => ruta.replaceAll('\\', '/').split('/').last;

Map<String, String?> _leerOpciones(List<String> args) {
  const validas = {'--reto', '--usuario', '--cambios', '--autor'};
  final opciones = <String, String?>{};
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '-h' || a == '--help') {
      stdout.writeln('Uso: dart run herramientas/generar_pruebas.dart '
          '[--reto <nn-nombre> [--usuario <usuario>]] [--cambios <archivo> [--autor <usuario>]]');
      exit(0);
    }
    if (!validas.contains(a) || i + 1 >= args.length) {
      _salir('Opción desconocida o sin valor: $a');
    }
    opciones[a.substring(2)] = args[++i];
  }
  return opciones;
}

Never _salir(String mensaje) {
  stderr.writeln(mensaje);
  exit(2);
}
