import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

import 'package:cabinapp/core/routes/app_router.dart';           // 👈 nuevo
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../presentation/providers/organization_provider.dart';
import 'organization_danger_dialog.dart';

class OrganizationDangerButton extends StatelessWidget {
  const OrganizationDangerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    final auth = context.watch<AuthProvider>();
    final orgProvider = context.watch<OrganizationProvider>();
    final org = orgProvider.activeOrganization;

    if (auth.user == null || org == null) {
      return const SizedBox.shrink();
    }

    final String orgId = org.id.toString();
    final String userId = auth.user!.id.toString();

    final bool esAdmin = (org.role == "ADMIN");

    final String buttonText = esAdmin
        ? local.deleteOrganization
        : local.leaveOrganization;

    return ElevatedButton.icon(
      icon: const Icon(Icons.warning_rounded),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        // Diálogo de confirmación
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => OrganizationDangerDialog(
            title: buttonText,
            description: local.organizationDangerDescription,
            confirmText: buttonText,
          ),
        );

        if (confirmed != true) return;

        try {
          // 1️⃣ Navegamos primero (o podrías hacerlo después, da igual porque no dependemos del context)
          appRouter.go('/splash');

          // 2️⃣ Ejecutamos la acción en segundo plano (no usamos context aquí)
          if (esAdmin) {
            await orgProvider.deleteOrganization(orgId);
          } else {
            await orgProvider.leaveOrganization(orgId, userId);
          }

          appRouter.go('/splash');

          // 3️⃣ Cerramos el diálogo si sigue abierto (por seguridad)
          Navigator.of(context).maybePop();
        } catch (e) {
          // aquí sí usamos context solo para mostrar el error si seguimos montados
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      },
    );
  }
}