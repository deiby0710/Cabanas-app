import 'package:flutter/material.dart';
import 'package:cabinapp/features/settings/presentation/widgets/logout_button.dart';
import 'package:cabinapp/features/settings/presentation/widgets/theme_button.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!; // 👈 Acceso a las traducciones

    return Scaffold(
      appBar: AppBar(
        title: Text(local.settingsTitle), // 👈 “Configuración” / “Settings”
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: const [
          ThemeToggleButton(), // 👈 botón para cambiar tema
        ],
      ),
      body: const Center(
        child: LogoutButton(),
      ),
    );
  }
}