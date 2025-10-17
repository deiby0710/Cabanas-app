import 'package:flutter/material.dart';
import 'package:frontend/features/organization/presentation/widgets/create_organization_form.dart';
import 'package:frontend/features/organization/presentation/widgets/join_organization_form.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organización'),
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
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Crear nueva'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Unirse con código'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showCreateForm
                    ? CreateOrgForm()
                    : JoinOrgForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
