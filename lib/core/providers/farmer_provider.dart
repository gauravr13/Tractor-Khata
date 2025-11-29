// =============================================================================
// PROJECT: Tractor Khata
// FILE: farmer_provider.dart
// DESCRIPTION:
// This provider manages the state of Farmer data.
// It interacts with the FarmerRepository to fetch, add, update, and delete farmers.
// It notifies listeners (UI) whenever the state changes.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../../data/local/database.dart';
import '../../data/repository/farmer_repository.dart';

/// ---------------------------------------------------------------------------
/// Class: FarmerProvider
/// Purpose: State management for Farmer data.
/// ---------------------------------------------------------------------------
class FarmerProvider with ChangeNotifier {
  final FarmerRepository _repository;

  // Internal state
  List<Farmer> _farmers = [];
  bool _isLoading = false;

  /// Returns the list of loaded farmers
  List<Farmer> get farmers => _farmers;

  /// Returns true if data is currently being loaded
  bool get isLoading => _isLoading;

  /// Constructor: Requires FarmerRepository dependency
  FarmerProvider(this._repository);

  /// ---------------------------------------------------------------------------
  /// Method: loadFarmers
  /// Purpose: Fetches all farmers from the repository and updates the state.
  /// ---------------------------------------------------------------------------
  Future<void> loadFarmers() async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loading indicator

    try {
      _farmers = await _repository.getAllFarmers();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading farmers: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to show data
    }
  }

  /// ---------------------------------------------------------------------------
  /// Method: addFarmer
  /// Purpose: Adds a new farmer and refreshes the list.
  /// ---------------------------------------------------------------------------
  Future<void> addFarmer({
    required String name,
    String? phone,
    String? notes,
  }) async {
    await _repository.addFarmer(name: name, phone: phone, notes: notes);
    await loadFarmers(); // Refresh list to include new farmer
  }

  /// ---------------------------------------------------------------------------
  /// Method: updateFarmer
  /// Purpose: Updates an existing farmer and refreshes the list.
  /// ---------------------------------------------------------------------------
  Future<void> updateFarmer(Farmer farmer) async {
    await _repository.updateFarmer(farmer);
    await loadFarmers(); // Refresh list to reflect changes
  }

  /// ---------------------------------------------------------------------------
  /// Method: deleteFarmer
  /// Purpose: Deletes a farmer and refreshes the list.
  /// ---------------------------------------------------------------------------
  Future<void> deleteFarmer(Farmer farmer) async {
    await _repository.deleteFarmer(farmer);
    await loadFarmers(); // Refresh list to remove deleted farmer
  }

  /// ---------------------------------------------------------------------------
  /// Method: searchFarmers
  /// Purpose: Filters the farmer list based on a search query.
  /// ---------------------------------------------------------------------------
  Future<void> searchFarmers(String query) async {
    if (query.isEmpty) {
      // If query is empty, load all farmers
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
