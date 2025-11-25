import 'package:drift/drift.dart';
import '../database/database.dart';

/// Repository class for managing Farmer data.
/// This class abstracts the database operations for Farmers.
class FarmerRepository {
  final AppDatabase _db;

  /// Constructor requiring the [AppDatabase] instance.
  FarmerRepository(this._db);

  /// Retrieves all farmers from the database.
  /// Returns a list of [Farmer] objects.
  Future<List<Farmer>> getAllFarmers() {
    return _db.getAllFarmers();
  }

  /// Retrieves a single farmer by their ID.
  Future<Farmer?> getFarmerById(int id) {
    return _db.getFarmerById(id);
  }

  /// Adds a new farmer to the database.
  /// [name] is required. [phone] and [notes] are optional.
  /// Returns the ID of the newly created farmer.
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

  /// Updates an existing farmer's details.
  /// [farmer] is the updated Farmer object.
  Future<bool> updateFarmer(Farmer farmer) {
    return _db.updateFarmer(farmer);
  }

  /// Deletes a farmer from the database.
  Future<int> deleteFarmer(Farmer farmer) {
    return _db.deleteFarmer(farmer);
  }

  /// Searches for farmers by name or phone number.
  Future<List<Farmer>> searchFarmers(String query) {
    return _db.searchFarmers(query);
  }
}
