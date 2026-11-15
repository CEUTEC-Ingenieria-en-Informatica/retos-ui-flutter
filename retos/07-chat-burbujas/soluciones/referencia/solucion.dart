// Solución de referencia del reto 07. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFF8FAFC);
const _mia = Color(0xFF2563EB);
const _suya = Color(0xFFE2E8F0);
const _texto = Color(0xFF0F172A);
const _hora = Color(0xFF64748B);
const _enLinea = Color(0xFF16A34A);

class Mensaje {
  const Mensaje(this.texto, this.hora, {required this.mio});
  final String texto;
  final String hora;
  final bool mio;
}

const _iniciales = [
  Mensaje('¿Ya tenés la guía de física?', '7:40 a. m.', mio: false),
  Mensaje('Sí, la terminé anoche', '7:41 a. m.', mio: true),
  Mensaje('¿Me la pasás? Me quedé en el ejercicio 4', '7:41 a. m.', mio: false),
  Mensaje('Dale, te mando foto en un rato', '7:43 a. m.', mio: true),
  Mensaje('Sos lo máximo', '7:44 a. m.', mio: false),
];

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _mia, scaffoldBackgroundColor: _fondo),
      home: const Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _mensajes = [..._iniciales];
  final _campo = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _campo.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _campo.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _campo.text.trim();
    if (texto.isEmpty) return;
    setState(() => _mensajes.add(Mensaje(texto, 'Ahora', mio: true)));
    _campo.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final puedeEnviar = _campo.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(tooltip: 'Regresar', onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFFDE68A),
              child: Text('MZ', style: TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w700)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mateo Zelaya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('en línea', style: TextStyle(fontSize: 12, color: _enLinea)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: _suya, borderRadius: BorderRadius.circular(999)),
                    child: const Text('Hoy', style: TextStyle(fontSize: 12, color: _hora)),
                  ),
                ),
                for (final m in _mensajes) _Burbuja(mensaje: m),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('campo-mensaje'),
                      controller: _campo,
                      onSubmitted: (_) => _enviar(),
                      decoration: InputDecoration(
                        hintText: 'Escribí un mensaje',
                        filled: true,
                        fillColor: _fondo,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    key: const Key('boton-enviar'),
                    tooltip: 'Enviar',
                    onPressed: puedeEnviar ? _enviar : null,
                    style: IconButton.styleFrom(backgroundColor: _mia),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.mensaje});

  final Mensaje mensaje;

  @override
  Widget build(BuildContext context) {
    final mio = mensaje.mio;
    const radio = Radius.circular(18);
    const esquina = Radius.circular(4);
    return Align(
      alignment: mio ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            color: mio ? _mia : _suya,
            borderRadius: BorderRadius.only(
              topLeft: radio,
              topRight: radio,
              bottomLeft: mio ? radio : esquina,
              bottomRight: mio ? esquina : radio,
            ),
          ),
          child: Column(
            crossAxisAlignment: mio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                mensaje.texto,
                style: TextStyle(fontSize: 15, color: mio ? Colors.white : _texto),
              ),
              const SizedBox(height: 4),
              Text(
                mensaje.hora,
                style: TextStyle(fontSize: 11, color: mio ? const Color(0xCCFFFFFF) : _hora),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
