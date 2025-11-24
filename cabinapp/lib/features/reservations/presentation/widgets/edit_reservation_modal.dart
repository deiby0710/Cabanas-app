import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/features/reservations/data/reservations_repository.dart';
import 'package:cabinapp/features/reservations/domain/reservation_model.dart';
import 'package:cabinapp/features/reservations/presentation/provider/reservation_provider.dart';

class EditReservationModal extends StatefulWidget {
  final ReservationModel reservation;

  const EditReservationModal({super.key, required this.reservation});

  @override
  State<EditReservationModal> createState() => _EditReservationModalState();
}

class _EditReservationModalState extends State<EditReservationModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _abonoController;
  late String _selectedEstado;
  bool _loading = false;

  final List<String> _estados = [
    'PENDIENTE',
    'CONFIRMADA',
    'CANCELADA',
    'COMPLETADA',
  ];

  String _translateEstado(String estado, AppLocalizations local) {
    switch (estado) {
      case 'PENDIENTE':
        return local.statusPending;
      case 'CONFIRMADA':
        return local.confirmed;
      case 'CANCELADA':
        return local.statusCanceled;
      case 'COMPLETADA':
        return local.statusCompleted;
      default:
        return estado;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedEstado = widget.reservation.estado;
    _abonoController =
        TextEditingController(text: widget.reservation.abono.toString());
  }

  @override
  void dispose() {
    _abonoController.dispose();
    super.dispose();
  }

  Future<void> _updateReservation() async {
    final local = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final repo = ReservationsRepository();
      await repo.updateReservation(
        reservationId: widget.reservation.id,
        updates: {
          'estado': _selectedEstado,
          'abono': double.tryParse(_abonoController.text) ?? 0.0,
        },
      );

      // Refrescar la lista de reservas
      final provider = context.read<ReservationsProvider>();
      await provider.fetchReservations();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.reservationUpdatedSuccess)),
        );
        context.pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.reservation;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.reservationDetailsTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Sección de información
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.cabanaNombre,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${local.cabinCapacityLabel}: ${r.cabanaCapacidad ?? '-'} ${local.peopleLabel}'),
                    const SizedBox(height: 4),
                    Text('${local.peopleCountLabel}: ${r.numPersonas}'),
                    const SizedBox(height: 4),
                    Text('${local.client}: ${r.clienteNombre}'),
                    const SizedBox(height: 4),
                    Text('${local.phoneLabel}: ${r.clienteCelular.isNotEmpty ? r.clienteCelular : '-'}'),
                    const SizedBox(height: 4),
                    Text('${local.startLabel}: ${r.fechaInicio.toLocal().toString().split(" ").first}'),
                    Text('${local.endLabel}: ${r.fechaFin.toLocal().toString().split(" ").first}'),
                    const Divider(height: 20),
                    Text(
                      '${local.createdByLabel}: ${r.creadoPorNombre} (${r.creadoPorEmail})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // 🔹 Campo de estado
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                decoration: InputDecoration(
                  labelText: local.reservationStatusLabel,
                  border: OutlineInputBorder(),
                ),
                items: _estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado, // 👈 el valor REAL queda intacto
                    child: Text(_translateEstado(estado, local)), // 👈 aquí se traduce
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedEstado = v!),
              ),
              const SizedBox(height: 20),

              // 🔹 Campo de abono
              TextFormField(
                controller: _abonoController,
                decoration: InputDecoration(
                  labelText: local.depositAmountLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value < 0) {
                    return local.enterValidValue;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // 🔹 Botón de actualizar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _updateReservation,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_loading ? local.updatingLabel : local.updateButton),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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