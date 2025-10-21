import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:cabinapp/features/auth/presentation/widgets/login_button.dart';

class LoginForm extends StatefulWidget {
  final bool isLogin;
  const LoginForm({super.key, required this.isLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (widget.isLogin) {
        // Simulación de login
        await authProvider.login(email, password);
      } else {
        // Simulación de registro
        await authProvider.register(email, password);
      }

      if (authProvider.user != null && mounted) {
        context.go('/selectOrganization');
      }
    } catch (e) {
      debugPrint('❌ Error en login/registro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu correo electrónico';
              }
              if (!value.contains('@')) {
                return 'Correo inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Campo Password
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu contraseña';
              }
              if (value.length < 6) {
                return 'Debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Botón modular
          LoginButton(
            isLoading: authProvider.isLoading,
            text: widget.isLogin ? 'Iniciar Sesión' : 'Registrarme',
            onPressed: () => _submit(context),
          ),

          const SizedBox(height: 20),

          // Mostrar errores
          if (authProvider.errorMessage != null)
            Text(
              authProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
