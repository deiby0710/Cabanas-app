import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/core/services/local_storage_service.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    // Limpia la sesión del usuario simulado
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    // Limpia el orgId local
    await LocalStorageService().clearOrgId();

    // Navega al login
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.errorContainer,
            foregroundColor: theme.colorScheme.onErrorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
