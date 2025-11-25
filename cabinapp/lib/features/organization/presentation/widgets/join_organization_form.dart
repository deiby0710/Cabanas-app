import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/organization_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class JoinOrgForm extends StatefulWidget {
  const JoinOrgForm({super.key});

  @override
  State<JoinOrgForm> createState() => _JoinOrgFormState();
}

class _JoinOrgFormState extends State<JoinOrgForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final orgProvider = context.read<OrganizationProvider>();

    await orgProvider.joinOrganization(
      _codeController.text.trim().toUpperCase(),
    );

    if (!mounted) return;

    if (orgProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orgProvider.errorMessage!)),
      );
    } else {
      final local = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.joinedOrganizationSuccess)),
      );
      context.go('/home'); // 👈 Redirige al Home
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final orgProvider = context.watch<OrganizationProvider>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 🔹 Campo de código de invitación
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: local.invitationCode,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return local.enterValidCode;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 🔹 Botón
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
                    : Text(local.joinOrganization),
              ),
            ),

            // 🔹 Error (si ocurre)
            if (orgProvider.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                orgProvider.errorMessage!,
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
