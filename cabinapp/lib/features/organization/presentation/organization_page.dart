import 'package:flutter/material.dart';
import 'package:cabinapp/features/organization/presentation/widgets/create_organization_form.dart';
import 'package:cabinapp/features/organization/presentation/widgets/join_organization_form.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import necesario

class SelectOrganizationPage extends StatefulWidget {
  const SelectOrganizationPage({super.key});

  @override
  State<SelectOrganizationPage> createState() => _SelectOrganizationPageState();
}

class _SelectOrganizationPageState extends State<SelectOrganizationPage> {
  bool _showCreateForm = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!; // 👈 Obtenemos las traducciones

    return Scaffold(
      appBar: AppBar(
        title: Text(local.organizationTitle), // 👈 “Organización” / “Organization”
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ToggleButtons(
              borderRadius: BorderRadius.circular(12),
              fillColor: theme.colorScheme.primaryContainer,
              selectedColor: theme.colorScheme.onPrimaryContainer,
              isSelected: [_showCreateForm, !_showCreateForm],
              onPressed: (index) {
                setState(() => _showCreateForm = index == 0);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(local.createNew),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(local.joinWithCode),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showCreateForm
                    ? const CreateOrgForm()
                    : const JoinOrgForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
