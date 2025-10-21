import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/core/services/local_storage_service.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import necesario

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    // Limpia el orgId guardado
    await LocalStorageService().clearOrgId();

    // Navega al login si el contexto sigue montado
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!; // 👈 Acceso a traducciones

    return ElevatedButton.icon(
      onPressed: () => _logout(context),
      icon: const Icon(Icons.logout),
      label: Text(local.logoutButton), // 👈 “Cerrar sesión” / “Log out”
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: theme.colorScheme.onErrorContainer,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
