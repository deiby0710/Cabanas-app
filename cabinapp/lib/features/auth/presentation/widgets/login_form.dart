import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:cabinapp/features/auth/presentation/widgets/login_button.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import de las traducciones

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
        await authProvider.login(email, password);
      } else {
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
    final local = AppLocalizations.of(context)!; // 👈 Accedemos a los textos traducidos

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 🔹 Campo Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: local.emailLabel, // 👈 Traducción del label
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.emailHint; // 👈 Texto traducido
              }
              if (!value.contains('@')) {
                return local.emailInvalid; // 👈 Texto traducido
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 🔹 Campo Password
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: local.passwordLabel, // 👈 Traducción del label
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.passwordHint; // 👈 Texto traducido
              }
              if (value.length < 6) {
                return local.passwordTooShort; // 👈 Texto traducido
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // 🔹 Botón modular (login o registro)
          LoginButton(
            isLoading: authProvider.isLoading,
            text: widget.isLogin
                ? local.loginButton // 👈 “Ingresar” / “Sign In”
                : local.registerButton, // 👈 “Registrarme” / “Sign Up”
            onPressed: () => _submit(context),
          ),

          const SizedBox(height: 20),

          // 🔹 Mostrar errores (sin traducir porque viene del servidor)
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
