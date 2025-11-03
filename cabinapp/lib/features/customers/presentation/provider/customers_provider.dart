import 'package:flutter/foundation.dart';
import 'package:cabinapp/features/customers/data/customers_repository.dart';
import 'package:cabinapp/features/customers/domain/client_model.dart';

class CustomersProvider with ChangeNotifier {
  final CustomersRepository _repository;

  CustomersProvider(this._repository);

  // 🔹 Lista de clientes cargados
  List<ClientModel> _customers = [];
  List<ClientModel> get customers => _customers;

  // 🔹 Indicador de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 🔹 Mensaje de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🔹 Obtener todos los clientes de la organización activa
  Future<void> fetchCustomers() async {
    _setLoading(true);
    try {
      _customers = await _repository.getCustomers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Crear un nuevo cliente
  Future<void> createCustomer(String nombre, String celular) async {
    _setLoading(true);
    try {
      final newCustomer = await _repository.createCustomer(nombre, celular);
      _customers.add(newCustomer);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }
}