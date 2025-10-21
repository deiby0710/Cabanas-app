import 'package:flutter/material.dart';
import 'package:cabinapp/features/settings/presentation/widgets/logout_button.dart';
import 'package:cabinapp/features/settings/presentation/widgets/theme_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: const [
          ThemeToggleButton(), // 👈 botón en la barra superior
        ],
      ),
      body: const Center(
        child: LogoutButton(),
      ),
    );
  }
}
