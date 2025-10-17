import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/organization/data/organization_repository.dart';
import 'package:frontend/core/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';

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

    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid == null) {
      setState(() => _errorMessage = 'Usuario no autenticado');
      return;
    }

    try {
      // Crear organización
      await _repo.createOrganization(
        orgName: _nameController.text.trim(),
        userUid: userUid,
      );

      // Buscar el ID del documento recién creado por el código (más simple que retornar el ID directamente)
      final orgs = await _repo.findByCreator(userUid);
      if (orgs.isNotEmpty) {
        await _localStorage.saveOrgId(orgs.first.id);
      }

      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      print('🔥 Error detallado de Firestore: $e');
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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la organización',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
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
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Crear organización'),
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
