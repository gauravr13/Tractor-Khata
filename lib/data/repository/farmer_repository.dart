// =============================================================================
// PROJECT: Tractor Khata
// FILE: farmer_repository.dart
// DESCRIPTION:
// This repository handles all data operations related to Farmers.
// It acts as an abstraction layer between the UI/Providers and the Database.
// =============================================================================

import 'package:drift/drift.dart';
import '../local/database.dart';

/// ---------------------------------------------------------------------------
/// Class: FarmerRepository
/// Purpose: Manages CRUD operations for Farmer entities.
/// ---------------------------------------------------------------------------
class FarmerRepository {
  final AppDatabase _db;

  /// Constructor: Requires an instance of AppDatabase
  FarmerRepository(this._db);

  /// ---------------------------------------------------------------------------
  /// Method: getAllFarmers
  /// Purpose: Retrieves a list of all farmers stored in the database.
  /// Returns: `Future<List<Farmer>>`
  /// ---------------------------------------------------------------------------
  Future<List<Farmer>> getAllFarmers() {
    return _db.getAllFarmers();
  }

  /// ---------------------------------------------------------------------------
  /// Method: getFarmerById
  /// Purpose: Retrieves a specific farmer by their unique ID.
  /// Returns: `Future<Farmer?>` (Null if not found)
  /// ---------------------------------------------------------------------------
  Future<Farmer?> getFarmerById(int id) {
    return _db.getFarmerById(id);
  }

  /// ---------------------------------------------------------------------------
  /// Method: addFarmer
  /// Purpose: Creates a new farmer record.
  /// Parameters:
  /// - name: Name of the farmer (Required)
  /// - phone: Phone number (Optional)
  /// - notes: Additional notes (Optional)
  /// Returns: `Future<int>` (The ID of the newly created farmer)
  /// ---------------------------------------------------------------------------
  Future<int> addFarmer({
    required String name,
    String? phone,
    String? notes,
  }) {
    final companion = FarmersCompanion(
      name: Value(name),
      phone: Value(phone),
      notes: Value(notes),
    );
    return _db.insertFarmer(companion);
  }

  /// ---------------------------------------------------------------------------
  /// Method: updateFarmer
  /// Purpose: Updates an existing farmer's details.
  /// Returns: `Future<bool>` (True if successful)
  /// ---------------------------------------------------------------------------
  Future<bool> updateFarmer(Farmer farmer) {
    return _db.updateFarmer(farmer);
  }

  /// ---------------------------------------------------------------------------
  /// Method: deleteFarmer
  /// Purpose: Deletes a farmer record from the database.
  /// Returns: `Future<int>` (Number of rows affected)
  /// ---------------------------------------------------------------------------
  Future<int> deleteFarmer(Farmer farmer) {
    return _db.deleteFarmer(farmer);
  }

  /// ---------------------------------------------------------------------------
  /// Method: searchFarmers
  /// Purpose: Searches for farmers by name or phone number.
  /// Returns: `Future<List<Farmer>>` (List of matching farmers)
  /// ---------------------------------------------------------------------------
  Future<List<Farmer>> searchFarmers(String query) {
    return _db.searchFarmers(query);
  }
}
