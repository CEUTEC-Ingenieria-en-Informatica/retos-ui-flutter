// Solución de referencia del reto 02. Es una forma de hacerlo, no la única.
import 'package:flutter/material.dart';

void main() => runApp(const Reto());

const _fondo = Color(0xFFFFF8F0);
const _primario = Color(0xFFC2410C);
const _texto = Color(0xFF1C1917);
const _textoSuave = Color(0xFF78716C);
const _borde = Color(0xFFE7E5E4);
const _error = Color(0xFFB91C1C);
const _circulo = Color(0xFFFED7AA);

class Reto extends StatelessWidget {
  const Reto({super.key});

  @override
  Widget build(BuildContext context) {
    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _borde),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _primario,
        scaffoldBackgroundColor: _fondo,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: bordeCampo,
          enabledBorder: bordeCampo,
          focusedBorder: bordeCampo.copyWith(
            borderSide: const BorderSide(color: _primario, width: 2),
          ),
          errorStyle: const TextStyle(color: _error),
        ),
      ),
      home: const PantallaInicioSesion(),
    );
  }
}

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final _formulario = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _ocultarClave = true;

  static final _patronCorreo = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (_formulario.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listo, ya entraste')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(color: _circulo, shape: BoxShape.circle),
                    child: const Icon(Icons.menu_book_rounded, size: 44, color: _primario),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hola de nuevo',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _texto),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entrá a Libreta para seguir con tus apuntes.',
                  style: TextStyle(fontSize: 15, color: _textoSuave),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  key: const Key('campo-correo'),
                  controller: _correo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (v) =>
                      _patronCorreo.hasMatch(v?.trim() ?? '') ? null : 'Escribí un correo válido',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('campo-clave'),
                  controller: _clave,
                  obscureText: _ocultarClave,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      key: const Key('ver-clave'),
                      tooltip: _ocultarClave ? 'Mostrar contraseña' : 'Ocultar contraseña',
                      icon: Icon(_ocultarClave ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _ocultarClave = !_ocultarClave),
                    ),
                  ),
                  validator: (v) => (v ?? '').length >= 8 ? null : 'Usá al menos 8 caracteres',
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: _primario),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    key: const Key('boton-ingresar'),
                    onPressed: _ingresar,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primario,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Ingresar'),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('¿No tenés cuenta?', style: TextStyle(color: _textoSuave)),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: _primario),
                      child: const Text('Creá una'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
