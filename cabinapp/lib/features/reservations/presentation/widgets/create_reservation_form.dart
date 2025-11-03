import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cabinapp/features/reservations/data/reservations_repository.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/select_cabin_modal.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/select_client_modal.dart';

class CreateReservationForm extends StatefulWidget {
  final DateTime startDate;

  const CreateReservationForm({super.key, required this.startDate});

  @override
  State<CreateReservationForm> createState() => _CreateReservationFormState();
}

class _CreateReservationFormState extends State<CreateReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ReservationsRepository();

  CabinItem? selectedCabin;
  ClientItem? selectedClient;
  DateTime? fechaFin;
  double? abono;
  int? numPersonas;
  bool isLoading = false;

  Future<void> _selectFechaFin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate.add(const Duration(days: 1)),
      firstDate: widget.startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2030),
      locale: const Locale('es', ''), // 👈 idioma español
    );

    if (picked != null) {
      setState(() => fechaFin = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCabin == null || selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cabaña y un cliente')),
      );
      return;
    }

    if (fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de fin')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      await _repo.createReservation(
        cabanaId: selectedCabin!.id,
        clienteId: selectedClient!.id,
        fechaInicio: widget.startDate,
        fechaFin: fechaFin!,
        abono: abono ?? 0,
        numPersonas: numPersonas ?? 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva creada correctamente 🎉')),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔹 Selectores modales (mock por ahora)
  Future<void> _selectCabin() async {
    final cabinsList = [
      CabinItem(id: 1, name: 'Cabaña El Refugio', capacity: 5),
      CabinItem(id: 2, name: 'Vista al Lago', capacity: 8),
    ];
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SelectCabinModal(cabins: cabinsList)),
    );
    if (selected != null) setState(() => selectedCabin = selected);
  }

  Future<void> _selectClient() async {
    final clientsList = [
      ClientItem(id: 1, name: 'Juan Pérez', phone: '3012345678'),
      ClientItem(id: 2, name: 'María Gómez', phone: '3209876543'),
    ];
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SelectClientModal(clients: clientsList)),
    );
    if (selected != null) setState(() => selectedClient = selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Fecha de inicio (solo lectura)
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Fecha de inicio'),
            subtitle: Text(dateFormat.format(widget.startDate)),
          ),
          const Divider(),

          // 🔹 Fecha de fin
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Fecha de fin'),
            subtitle: Text(
              fechaFin != null
                  ? dateFormat.format(fechaFin!)
                  : 'Seleccionar fecha de fin',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectFechaFin,
          ),
          const Divider(),

          // 🔹 Cabaña
          ListTile(
            title: Text(selectedCabin?.name ?? 'Seleccionar cabaña'),
            subtitle: selectedCabin != null
                ? Text('Capacidad: ${selectedCabin!.capacity}')
                : null,
            leading: const Icon(Icons.cabin),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectCabin,
          ),
          const Divider(),

          // 🔹 Cliente
          ListTile(
            title: Text(selectedClient?.name ?? 'Seleccionar cliente'),
            subtitle:
                selectedClient != null ? Text(selectedClient!.phone) : null,
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectClient,
          ),
          const Divider(),

          // 🔹 Campo de abono
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Abono',
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.08),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            keyboardType: TextInputType.number,
            onSaved: (v) => abono = double.tryParse(v ?? '0'),
          ),

          const SizedBox(height: 16),

          // 🔹 Campo de número de personas
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Número de personas',
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.08),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.group_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            keyboardType: TextInputType.number,
            onSaved: (v) => numPersonas = int.tryParse(v ?? '1'),
          ),

          const SizedBox(height: 24),

          // 🔹 Botón de envío
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Crear reserva'),
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}