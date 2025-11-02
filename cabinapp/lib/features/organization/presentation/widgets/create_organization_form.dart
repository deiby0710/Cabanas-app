import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/organization_provider.dart';
// import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import de traducciones

class CreateOrgForm extends StatefulWidget {
  const CreateOrgForm({super.key});

  @override
  State<CreateOrgForm> createState() => _CreateOrgFormState();
}

class _CreateOrgFormState extends State<CreateOrgForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Accedemos al provider
    final orgProvider = context.read<OrganizationProvider>();

    setState(() {}); // solo para redibujar si quisieras mostrar loading

    await orgProvider.createOrganization(_nameController.text.trim());

    if (!mounted) return;

    if (orgProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orgProvider.errorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organización creada exitosamente')),
      );
      context.go('/home');
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = context.watch<OrganizationProvider>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Organization name',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface, // opcional: para mantener consistencia de fondo
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un nombre válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: orgProvider.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: orgProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create organization'),
              ),
            ),
          ],
        ),
      )
    );
  }
}