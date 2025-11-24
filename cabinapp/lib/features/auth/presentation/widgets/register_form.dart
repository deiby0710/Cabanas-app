import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final local = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await authProvider.register(nombre, email, password);

      if (authProvider.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.registrationSuccess)),
        );
        context.go('/selectOrganization');
      }
    } catch (e) {
      debugPrint('❌ Error en registro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 🔹 Nombre
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: local.nameLabel,
              prefixIcon: const Icon(Icons.person_outline),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.enterName; // “Ingresa tu nombre”
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 🔹 Email 
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: local.emailLabel,
              prefixIcon: const Icon(Icons.email_outlined),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.emailHint;
              }
              if (!value.contains('@')) {
                return local.emailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 🔹 Contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: local.passwordLabel,
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.passwordHint;
              }
              if (value.length < 6) {
                return local.passwordTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 🔹 Confirmar contraseña
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: local.confirmPasswordLabel, // “Confirmar contraseña”
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_person_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.confirmPasswordHint; // “Repite tu contraseña”
              }
              if (value != _passwordController.text) {
                return local.passwordsDontMatch; // “Las contraseñas no coinciden”
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // 🔹 Botón de registro
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () => _submit(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: authProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(local.registerButton), // “Registrarme”
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Mensaje de error si falla
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
