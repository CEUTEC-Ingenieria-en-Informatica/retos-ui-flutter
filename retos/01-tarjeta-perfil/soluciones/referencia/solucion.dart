// Solución de referencia del reto 01. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFF4F1EA);
const _acento = Color(0xFF0F766E);
const _textoPrincipal = Color(0xFF1F2937);
const _textoSecundario = Color(0xFF6B7280);
const _avatarFondo = Color(0xFFFDE68A);
const _avatarTexto = Color(0xFF92400E);
const _chipFondo = Color(0xFFE6F4F1);

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _acento, scaffoldBackgroundColor: _fondo),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: TarjetaPerfil(),
            ),
          ),
        ),
      ),
    );
  }
}

class TarjetaPerfil extends StatefulWidget {
  const TarjetaPerfil({super.key});

  @override
  State<TarjetaPerfil> createState() => _TarjetaPerfilState();
}

class _TarjetaPerfilState extends State<TarjetaPerfil> {
  bool _siguiendo = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 8)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(height: 112, color: _acento),
                  Positioned(
                    top: 64,
                    child: Container(
                      key: const Key('avatar'),
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _avatarFondo,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Text(
                        'KF',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: _avatarTexto,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  const Text(
                    'Karla Funes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Diseñadora de producto',
                    style: TextStyle(fontSize: 15, color: _acento, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.place_outlined, size: 16, color: _textoSecundario),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'San Pedro Sula, Cortés',
                          style: TextStyle(fontSize: 13, color: _textoSecundario),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Diseño interfaces para apps de transporte y salud. '
                    'Me gusta el café de altura y probar todo con usuarios de verdad.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.5, color: _textoPrincipal),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      _Cifra(valor: '38', etiqueta: 'Proyectos'),
                      _Cifra(valor: '1.2 k', etiqueta: 'Seguidores'),
                      _Cifra(valor: '4.9', etiqueta: 'Reseñas'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _Habilidad('Figma'),
                      _Habilidad('Flutter'),
                      _Habilidad('Accesibilidad'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: _siguiendo
                              ? OutlinedButton(
                                  key: const Key('boton-seguir'),
                                  onPressed: () => setState(() => _siguiendo = false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _acento,
                                    side: const BorderSide(color: _acento),
                                  ),
                                  child: const Text('Siguiendo'),
                                )
                              : FilledButton(
                                  key: const Key('boton-seguir'),
                                  onPressed: () => setState(() => _siguiendo = true),
                                  style: FilledButton.styleFrom(backgroundColor: _acento),
                                  child: const Text('Seguir'),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(foregroundColor: _textoPrincipal),
                            child: const Text('Mensaje'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textoPrincipal,
            ),
          ),
          const SizedBox(height: 2),
          Text(etiqueta, style: const TextStyle(fontSize: 12, color: _textoSecundario)),
        ],
      ),
    );
  }
}

class _Habilidad extends StatelessWidget {
  const _Habilidad(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _chipFondo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 13, color: _acento, fontWeight: FontWeight.w600),
      ),
    );
  }
}
