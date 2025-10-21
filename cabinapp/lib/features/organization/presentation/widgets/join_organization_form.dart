import 'package:flutter/material.dart';
import 'package:cabinapp/features/organization/data/organization_repository.dart';
import 'package:cabinapp/core/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class JoinOrgForm extends StatefulWidget {
  const JoinOrgForm({super.key});

  @override
  State<JoinOrgForm> createState() => _JoinOrgFormState();
}

class _JoinOrgFormState extends State<JoinOrgForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _repo = OrganizationRepository();
  final _localStorage = LocalStorageService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 🔹 Unirse a la organización simulada
      final org = await _repo.joinOrganizationByCode(
        inviteCode: _codeController.text.trim().toUpperCase(),
      );

      // 🔹 Guardar el orgId localmente
      await _localStorage.saveOrgId(org['id']);

      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      debugPrint('❌ Error al unirse a la organización: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; // 👈 Obtenemos las traducciones
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 🔹 Campo código de invitación
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: local.invitationCode, // 👈 “Código de invitación” / “Invitation code”
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return local.enterValidCode; // 👈 “Ingresa un código válido”
                }
                if (!v.contains('-')) {
                  return local.invalidFormat; // 👈 “Formato inválido...”
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 🔹 Botón de envío
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
                    : Text(local.joinOrganization), // 👈 “Unirme a la organización” / “Join organization”
              ),
            ),

            // 🔹 Mensaje de error si algo falla
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
