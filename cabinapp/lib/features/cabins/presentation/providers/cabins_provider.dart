import 'package:flutter/foundation.dart';
import 'package:cabinapp/features/cabins/data/cabins_repository.dart';
import 'package:cabinapp/features/cabins/domain/cabin_model.dart';

class CabinsProvider with ChangeNotifier {
  final CabinsRepository _cabinsRepository;

  CabinsProvider(this._cabinsRepository);

  List<CabinModel> _cabins = [];
  List<CabinModel> get cabins => _cabins;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🔹 Obtener todas las cabañas
  Future<void> fetchCabins() async {
    _setLoading(true);
    try {
      _cabins = await _cabinsRepository.getCabins();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Crear una nueva cabaña
  Future<void> createCabin(String nombre, int capacidad) async {
    _setLoading(true);
    try {
      final newCabin = await _cabinsRepository.createCabin(nombre, capacidad);
      _cabins.add(newCabin);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }
}
