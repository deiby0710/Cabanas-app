import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/cabins/presentation/providers/cabins_provider.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

class CreateCabinForm extends StatefulWidget {
  const CreateCabinForm({super.key});

  @override
  State<CreateCabinForm> createState() => _CreateCabinFormState();
}

class _CreateCabinFormState extends State<CreateCabinForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<CabinsProvider>();
    final local = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    try {
      await provider.createCabin(
        _nameController.text.trim(),
        int.parse(_capacityController.text),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.cabinCreated)),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final cabinsProvider = context.watch<CabinsProvider>();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cabin,
                size: 70,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                local.createCabinTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 🔹 Nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: local.cabinNameLabel,
                  prefixIcon: const Icon(Icons.house_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? local.enterCabinName : null,
              ),
              const SizedBox(height: 20),

              // 🔹 Capacidad
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                decoration: InputDecoration(
                  labelText: local.cabinCapacityLabel,
                  prefixIcon: const Icon(Icons.group_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return local.enterCapacity;
                  final num? val = int.tryParse(v);
                  if (val == null || val <= 0) return local.invalidCapacity;
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // 🔹 Botón
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: cabinsProvider.isLoading ? null : _submit,
                  icon: cabinsProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    cabinsProvider.isLoading
                        ? local.creatingCabin
                        : local.createCabin,
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}