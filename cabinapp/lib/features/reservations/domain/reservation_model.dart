class ReservationModel {
  final int id;
  final String estado;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double abono;
  final int numPersonas;
  final String cabanaNombre;
  final int? cabanaCapacidad;
  final String clienteNombre;
  final String clienteCelular;
  final String creadoPorNombre;
  final String creadoPorEmail;

  ReservationModel({
    required this.id,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.abono,
    required this.numPersonas,
    required this.cabanaNombre,
    this.cabanaCapacidad,
    required this.clienteNombre,
    required this.clienteCelular,
    required this.creadoPorNombre,
    required this.creadoPorEmail,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final cabana = json['cabana'] ?? {};
    final cliente = json['cliente'] ?? {};
    final creadoPor = json['creadoPor'] ?? {};

    return ReservationModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      estado: json['estado'] ?? '',
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime.now(),
      fechaFin: DateTime.tryParse(json['fechaFin'] ?? '') ?? DateTime.now(),
      abono: double.tryParse('${json['abono'] ?? 0}') ?? 0,
      numPersonas: json['numPersonas'] is int
          ? json['numPersonas']
          : int.tryParse('${json['numPersonas']}') ?? 0,
      cabanaNombre: cabana['nombre'] ?? 'Sin nombre',
      cabanaCapacidad: cabana['capacidad'] == null
          ? null
          : (cabana['capacidad'] is int
              ? cabana['capacidad']
              : int.tryParse('${cabana['capacidad']}')),
      clienteNombre: cliente['nombre'] ?? 'Sin cliente',
      clienteCelular: cliente['celular'] ?? '',
      creadoPorNombre: creadoPor['nombre'] ?? '',
      creadoPorEmail: creadoPor['email'] ?? '',
    );
  }
}