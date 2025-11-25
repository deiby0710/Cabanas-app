import 'package:cabinapp/features/settings/presentation/widgets/created_by_label.dart';
import 'package:flutter/material.dart';
import 'package:cabinapp/features/auth/presentation/widgets/login_form.dart';
import 'package:cabinapp/features/auth/presentation/widgets/register_form.dart';
import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:cabinapp/features/splash/presentation/widgets/splash_logo.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 🔹 Logo con color adaptativo
              SplashLogo(
                size: size.width * 0.3,
                color: isDark
                    ? Colors.white
                    : theme.colorScheme.primary, // 👈 cambia según modo
              ),

              const SizedBox(height: 32),

              // 🔹 Mensaje de bienvenida dinámico
              Text(
                _showLogin
                    ? local.welcomeBack // 👈 "¡Bienvenido de nuevo!"
                    : local.createAccount, // 👈 "Crea tu cuenta"
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                _showLogin
                    ? local.signInToContinue // "Inicia sesión para continuar"
                    : local.startExperience, // "Comienza tu experiencia"
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // 🔹 Toggle de Login / Registro
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(local.loginButton),
                    icon: const Icon(Icons.login),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(local.registerButton),
                    icon: const Icon(Icons.person_add),
                  ),
                ],
                selected: {_showLogin},
                onSelectionChanged: (val) {
                  setState(() => _showLogin = val.first);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return theme.colorScheme.primary.withOpacity(0.15);
                    }
                    return theme.colorScheme.surface;
                  }),
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 Formulario animado
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _showLogin
                    ? const LoginForm(key: ValueKey('login'))
                    : const RegisterForm(key: ValueKey('register')),
              ),
              const CreatedByLabel(),
            ],
          ),
        ),
      ),
    );
  }
}