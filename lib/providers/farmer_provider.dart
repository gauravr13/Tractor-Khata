import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../repositories/farmer_repository.dart';

/// Provider class for managing Farmer state.
/// Acts as a bridge between the UI and the FarmerRepository.
class FarmerProvider with ChangeNotifier {
  final FarmerRepository _repository;

  List<Farmer> _farmers = [];
  bool _isLoading = false;

  /// Returns the list of farmers.
  List<Farmer> get farmers => _farmers;

  /// Returns the loading state.
  bool get isLoading => _isLoading;

  FarmerProvider(this._repository);

  /// Loads all farmers from the database.
  Future<void> loadFarmers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _farmers = await _repository.getAllFarmers();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading farmers: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new farmer.
  Future<void> addFarmer({
    required String name,
    String? phone,
    String? notes,
  }) async {
    await _repository.addFarmer(name: name, phone: phone, notes: notes);
    await loadFarmers(); // Refresh the list
  }

  /// Updates an existing farmer.
  Future<void> updateFarmer(Farmer farmer) async {
    await _repository.updateFarmer(farmer);
    await loadFarmers(); // Refresh the list
  }

  /// Deletes a farmer.
  Future<void> deleteFarmer(Farmer farmer) async {
    await _repository.deleteFarmer(farmer);
    await loadFarmers(); // Refresh the list
  }

  /// Searches farmers by query.
  Future<void> searchFarmers(String query) async {
    if (query.isEmpty) {
      await loadFarmers();
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        _farmers = await _repository.searchFarmers(query);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
