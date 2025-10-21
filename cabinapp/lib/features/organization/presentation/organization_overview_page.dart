import 'package:flutter/material.dart';
import 'package:cabinapp/core/services/local_storage_service.dart';
import 'package:cabinapp/features/organization/data/organization_repository.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import para traducciones

class OrganizationOverviewPage extends StatefulWidget {
  const OrganizationOverviewPage({super.key});

  @override
  State<OrganizationOverviewPage> createState() =>
      _OrganizationOverviewPageState();
}

class _OrganizationOverviewPageState extends State<OrganizationOverviewPage> {
  final _repo = OrganizationRepository();
  final _localStorage = LocalStorageService();

  Map<String, dynamic>? _organization;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final orgId = await _localStorage.getOrgId();
      if (orgId == null) throw Exception('noActiveOrganization'); // 👈 traducible

      // 🔹 Buscar la organización en el mock por ID
      final orgData = _repo.getOrganizationById(orgId);

      setState(() {
        _organization = orgData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!; // 👈 Obtenemos traducciones

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            '${local.errorLabel}: $_error', // 👈 “Error” / “Error”
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(local.organizationTitle), // 👈 “Organización” / “Organization”
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _organization?['name'] ?? local.noName, // 👈 “Sin nombre” / “No name”
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${local.invitationCode}: ${_organization?['inviteCode']}', // 👈 “Código de invitación” / “Invitation code”
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 32),
            Text(
              '${local.members}:', // 👈 “Miembros:” / “Members:”
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: (_organization?['users'] as List).length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final member =
                      (_organization?['users'] as List<Map<String, dynamic>>)[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(member['id']),
                    subtitle: Text(
                      '${local.roleLabel}: ${member['role']}', // 👈 “Rol:” / “Role:”
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
