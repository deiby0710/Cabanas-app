import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/reservations_repository.dart';

class CreateReservationForm extends StatefulWidget {
  const CreateReservationForm({super.key});

  @override
  State<CreateReservationForm> createState() => _CreateReservationFormState();
}

class _CreateReservationFormState extends State<CreateReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ReservationsRepository();

  int? cabanaId;
  int? clienteId;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  double? abono;
  int? numPersonas;

  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await _repo.createReservation(
        cabanaId: cabanaId!,
        clienteId: clienteId!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        abono: abono ?? 0,
        numPersonas: numPersonas ?? 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva creada correctamente 🎉')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Cabana ID'),
            keyboardType: TextInputType.number,
            onSaved: (v) => cabanaId = int.tryParse(v ?? ''),
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Cliente ID'),
            keyboardType: TextInputType.number,
            onSaved: (v) => clienteId = int.tryParse(v ?? ''),
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Abono'),
            keyboardType: TextInputType.number,
            onSaved: (v) => abono = double.tryParse(v ?? '0'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Número de personas'),
            keyboardType: TextInputType.number,
            onSaved: (v) => numPersonas = int.tryParse(v ?? '1'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: isLoading
                ? const CircularProgressIndicator()
                : const Text('Crear reserva'),
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}