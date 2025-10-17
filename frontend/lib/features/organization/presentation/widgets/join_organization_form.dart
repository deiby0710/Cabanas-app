import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/organization/data/organization_repository.dart';
import 'package:frontend/core/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';

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

    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid == null) {
      setState(() => _errorMessage = 'Usuario no autenticado');
      return;
    }

    try {
      // Unirse mediante código
      final orgId = await _repo.joinOrganizationByCodeAndReturnId(
        inviteCode: _codeController.text.trim().toUpperCase(),
        userUid: userUid,
      );

      // Guardar el orgId localmente
      await _localStorage.saveOrgId(orgId);

      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Código de invitación',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Ingresa un código válido';
                }
                if (!v.contains('-')) {
                  return 'Formato inválido (ejemplo: BOSQUE-1234)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Unirme a la organización'),
              ),
            ),
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
