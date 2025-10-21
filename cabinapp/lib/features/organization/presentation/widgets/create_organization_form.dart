import 'package:flutter/material.dart';
import 'package:cabinapp/features/organization/data/organization_repository.dart';
import 'package:cabinapp/core/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/l10n/app_localizations.dart'; // 👈 Import de traducciones

class CreateOrgForm extends StatefulWidget {
  const CreateOrgForm({super.key});

  @override
  State<CreateOrgForm> createState() => _CreateOrgFormState();
}

class _CreateOrgFormState extends State<CreateOrgForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _repo = OrganizationRepository();
  final _localStorage = LocalStorageService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 🔹 Crear organización simulada
      final newOrg = await _repo.createOrganization(
        orgName: _nameController.text.trim(),
      );

      // 🔹 Guardar el orgId en almacenamiento local
      await _localStorage.saveOrgId(newOrg['id']);

      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      debugPrint('🔥 Error en creación de organización: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; // 👈 Acceso a las traducciones
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 🔹 Campo de nombre de la organización
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: local.organizationName, // 👈 “Nombre de la organización” / “Organization name”
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return local.enterValidName; // 👈 “Ingresa un nombre válido” / “Enter a valid name”
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 🔹 Botón “Crear organización”
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(local.createOrganization), 
              ),
            ),

            // 🔹 Mensaje de error (sin traducir porque viene del backend)
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
