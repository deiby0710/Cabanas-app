import 'package:flutter/material.dart';
import 'package:cabinapp/features/organization/presentation/widgets/create_organization_form.dart';
import 'package:cabinapp/features/organization/presentation/widgets/join_organization_form.dart';
import 'package:cabinapp/features/organization/presentation/widgets/my_organizations_list.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

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
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.organizationTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView( // 👈 permite scroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Botones para alternar formularios
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

              // 🔹 Formulario dinámico (crear / unirse)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showCreateForm
                    ? const CreateOrgForm()
                    : const JoinOrgForm(),
              ),

              const SizedBox(height: 40),

              // 🔹 NUEVA SECCIÓN: Lista de organizaciones existentes
              Text(
                local.myOrganizations,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              // 🔹 Lista de organizaciones del usuario
              const MyOrganizationsList(),
            ],
          ),
        ),
      ),
    );
  }
}
