import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/organization/presentation/providers/organization_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class MyOrganizationsList extends StatefulWidget {
  const MyOrganizationsList({super.key});

  @override
  State<MyOrganizationsList> createState() => _MyOrganizationsListState();
}

class _MyOrganizationsListState extends State<MyOrganizationsList> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadOrganizations(); // 👈 ahora sí cambia el estado
    });
  }

  Future<void> _loadOrganizations() async {
    final orgProvider = context.read<OrganizationProvider>();
    await orgProvider.getMyOrganizations();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = context.watch<OrganizationProvider>();
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orgProvider.myOrganizations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          local.noOrganizationsYet, // 👈 “Aún no perteneces a ninguna organización”
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.myOrganizations, // “Mis organizaciones”
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orgProvider.myOrganizations.length,
            itemBuilder: (context, index) {
              final org = orgProvider.myOrganizations[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.apartment_rounded),
                  title: Text(org.nombre),
                  subtitle: Text('${local.roleLabel}: ${org.role ?? 'USER'}'),
                  onTap: () async {
                    await orgProvider.setActiveOrganization(org);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(local.organizationSelected)),
                    );
                    context.go('/home');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
