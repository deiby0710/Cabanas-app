import 'package:flutter/material.dart';
import 'package:cabinapp/features/auth/presentation/widgets/login_form.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true; // alterna entre login y registro

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cabin, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                _isLogin ? local.loginTitle : local.registerTitle,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),

              // Formulario modularizado
              LoginForm(isLogin: _isLogin),

              const SizedBox(height: 16),

              // Alternar entre login / registro
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? local.noAccount
                      : local.alreadyAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
