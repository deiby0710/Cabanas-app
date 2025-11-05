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
          const SnackBar(content: Text('Reserva actualizada correctamente ✅')),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la reserva'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
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
                    Text('Capacidad: ${r.cabanaCapacidad ?? '-'} personas'),
                    const SizedBox(height: 4),
                    Text('Número de personas: ${r.numPersonas}'),
                    const SizedBox(height: 4),
                    Text('Cliente: ${r.clienteNombre}'),
                    const SizedBox(height: 4),
                    Text('Celular: ${r.clienteCelular.isNotEmpty ? r.clienteCelular : '-'}'),
                    const SizedBox(height: 4),
                    Text('Inicio: ${r.fechaInicio.toLocal().toString().split(" ").first}'),
                    Text('Fin: ${r.fechaFin.toLocal().toString().split(" ").first}'),
                    const Divider(height: 20),
                    Text(
                      'Creado por: ${r.creadoPorNombre} (${r.creadoPorEmail})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // 🔹 Campo de estado
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                decoration: const InputDecoration(
                  labelText: 'Estado de la reserva',
                  border: OutlineInputBorder(),
                ),
                items: _estados
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedEstado = v!),
              ),
              const SizedBox(height: 20),

              // 🔹 Campo de abono
              TextFormField(
                controller: _abonoController,
                decoration: const InputDecoration(
                  labelText: 'Monto del abono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value < 0) {
                    return 'Ingrese un valor válido';
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
                  label: Text(_loading ? 'Actualizando...' : 'Actualizar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
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