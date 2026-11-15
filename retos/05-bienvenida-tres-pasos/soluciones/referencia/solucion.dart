// Solución de referencia del reto 05. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _texto = Color(0xFF1E1B4B);
const _textoSuave = Color(0xFF4B5563);
const _primario = Color(0xFF4338CA);

class _Paso {
  const _Paso(this.titulo, this.texto, this.icono, this.fondo, this.circulo);
  final String titulo;
  final String texto;
  final IconData icono;
  final Color fondo;
  final Color circulo;
}

const _pasos = [
  _Paso(
    'Guardá sin darte cuenta',
    'Redondeá tus compras y lo que sobra se va a tu alcancía.',
    Icons.savings_outlined,
    Color(0xFFFEF3C7),
    Color(0xFFFCD34D),
  ),
  _Paso(
    'Metas que sí se cumplen',
    'Ponele nombre y fecha a cada meta: la feria, una laptop o el viaje a la playa.',
    Icons.flag_outlined,
    Color(0xFFDCFCE7),
    Color(0xFF86EFAC),
  ),
  _Paso(
    'Mirá cómo crece',
    'Cada semana te mostramos cuánto llevás y cuánto te falta.',
    Icons.trending_up,
    Color(0xFFE0E7FF),
    Color(0xFFA5B4FC),
  ),
];

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _primario),
      home: const Bienvenida(),
    );
  }
}

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final _paginas = PageController();
  int _paso = 0;
  bool _terminado = false;

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _siguiente() {
    if (_paso == _pasos.length - 1) {
      setState(() => _terminado = true);
    } else {
      _paginas.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_terminado) return const _Final();
    final ultimo = _paso == _pasos.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _pasos[_paso].fondo,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ultimo
                      ? null
                      : TextButton(
                          key: const Key('boton-saltar'),
                          onPressed: () => setState(() => _terminado = true),
                          style: TextButton.styleFrom(foregroundColor: _texto),
                          child: const Text('Saltar'),
                        ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  key: const Key('paginas'),
                  controller: _paginas,
                  itemCount: _pasos.length,
                  onPageChanged: (i) => setState(() => _paso = i),
                  itemBuilder: (context, i) => _PaginaPaso(paso: _pasos[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    Row(
                      key: const Key('indicador-paso'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _pasos.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _paso ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _paso ? _primario : const Color(0x334338CA),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Text(
                          '${_paso + 1} de ${_pasos.length}',
                          style: const TextStyle(color: _textoSuave, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        key: const Key('boton-siguiente'),
                        onPressed: _siguiente,
                        style: FilledButton.styleFrom(backgroundColor: _primario),
                        child: Text(ultimo ? 'Empezar' : 'Siguiente'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaginaPaso extends StatelessWidget {
  const _PaginaPaso({required this.paso});

  final _Paso paso;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: paso.circulo, shape: BoxShape.circle),
              child: Icon(paso.icono, size: 96, color: _texto),
            ),
            const SizedBox(height: 32),
            Text(
              paso.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: _texto),
            ),
            const SizedBox(height: 12),
            Text(
              paso.texto,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4, color: _textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}

class _Final extends StatelessWidget {
  const _Final();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFE0E7FF),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 96, color: _primario),
              SizedBox(height: 24),
              Text(
                'Todo listo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _texto),
              ),
              SizedBox(height: 8),
              Text(
                'Tu alcancía te espera.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: _textoSuave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
