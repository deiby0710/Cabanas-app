import 'package:cabinapp/features/organization/presentation/widgets/my_organizations_list.dart';
import 'package:cabinapp/features/organization/presentation/widgets/organization_danger_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/organization_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class OrganizationOverviewPage extends StatefulWidget {
  const OrganizationOverviewPage({super.key});

  @override
  State<OrganizationOverviewPage> createState() =>
      _OrganizationOverviewPageState();
}

class _OrganizationOverviewPageState extends State<OrganizationOverviewPage> {
  @override
  void initState() {
    super.initState();
    final orgProvider = context.read<OrganizationProvider>();

    // 🔹 Cargar organización activa
    Future.microtask(() => orgProvider.loadActiveOrganization());

    // 🔹 Cargar lista de mis organizaciones
    Future.microtask(() => orgProvider.getMyOrganizations());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final orgProvider = context.watch<OrganizationProvider>();

    final organization = orgProvider.activeOrganization;

    if (orgProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (organization == null) {
      return Scaffold(
        body: Center(
          child: Text(
            local.noActiveOrganization, // 👈 “No hay organización activa”
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(local.organizationTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ir al chat IA
          context.push('/ai');
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.smart_toy, color: theme.colorScheme.onPrimary,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( // 👈 para permitir scroll si hay muchas orgs
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Nombre de la organización
              Text(
                organization.nombre,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),

              // 🔹 Código de invitación
              Text(
                '${local.invitationCode}: ${organization.codigoInvitacion}',
                style: const TextStyle(fontSize: 16),
              ),

              const Divider(height: 32),

              // 🔹 Info básica (por ahora sin miembros)
              Text(
                '${local.roleLabel}: ${organization.role ?? "ADMIN"}',
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 16),

              // 🔹 Botón para limpiar organización activa
              const OrganizationDangerButton(),

              const SizedBox(height: 32),

              // 👇 NUEVA SECCIÓN
              const MyOrganizationsList(),
            ],
          ),
        ),
      ),
    );
  }
}
