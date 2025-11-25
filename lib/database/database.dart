/// =============================================================================
/// PROJECT: Tractor Khata
/// FILE: database.dart
/// DESCRIPTION:
/// This file defines the main AppDatabase class using Drift (SQLite ORM).
/// It handles:
/// 1. Database Connection (LazyDatabase)
/// 2. Schema Versioning & Migrations
/// 3. DAOs (Data Access Objects) for Farmers, Works, Payments, and WorkTypes
/// =============================================================================

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

// Include the generated code by Drift
part 'database.g.dart';

/// ---------------------------------------------------------------------------
/// Class: AppDatabase
/// Purpose: The central database class that manages tables and queries.
/// ---------------------------------------------------------------------------
@DriftDatabase(tables: [Farmers, WorkTypes, Works, Payments])
class AppDatabase extends _$AppDatabase {
  /// Constructor: Opens the database connection
  AppDatabase() : super(_openConnection());

  /// Schema Version: Increment this when you change the table structure
  @override
  int get schemaVersion => 2;

  /// Migration Strategy: Handles database upgrades (e.g., adding new tables)
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll(); // Create all tables on first install
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle version upgrades
      if (from < 2) {
        // Version 1 -> 2: Added 'Payments' table
        await m.createTable(payments);
      }
    },
  );

  // ===========================================================================
  // FARMER QUERIES
  // ===========================================================================

  /// Get all farmers list
  Future<List<Farmer>> getAllFarmers() => select(farmers).get();

  /// Get a single farmer by ID
  Future<Farmer?> getFarmerById(int id) =>
      (select(farmers)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Insert a new farmer
  Future<int> insertFarmer(FarmersCompanion farmer) =>
      into(farmers).insert(farmer);

  /// Update an existing farmer
  Future<bool> updateFarmer(Farmer farmer) => update(farmers).replace(farmer);

  /// Delete a farmer
  Future<int> deleteFarmer(Farmer farmer) => delete(farmers).delete(farmer);
  
  /// Search farmers by name or phone number
  Future<List<Farmer>> searchFarmers(String query) {
    return (select(farmers)
          ..where((t) => t.name.contains(query) | t.phone.contains(query)))
        .get();
  }

  // ===========================================================================
  // WORK TYPE (RATE CARD) QUERIES
  // ===========================================================================

  /// Get all work types (Rate Card)
  Future<List<WorkType>> getAllWorkTypes() => select(workTypes).get();

  /// Insert a new work type
  Future<int> insertWorkType(WorkTypesCompanion workType) =>
      into(workTypes).insert(workType);

  /// Update a work type
  Future<bool> updateWorkType(WorkType workType) =>
      update(workTypes).replace(workType);

  /// Delete a work type
  Future<int> deleteWorkType(WorkType workType) =>
      delete(workTypes).delete(workType);

  // ===========================================================================
  // WORK QUERIES
  // ===========================================================================

  /// Get all works for a specific farmer, ordered by date (newest first)
  Future<List<Work>> getWorksForFarmer(int farmerId) {
    return (select(works)
          ..where((t) => t.farmerId.equals(farmerId))
          ..orderBy([(t) => OrderingTerm(expression: t.workDate, mode: OrderingMode.desc)]))
        .get();
  }

  /// Insert a new work entry
  Future<int> insertWork(WorksCompanion work) => into(works).insert(work);

  /// Delete a work entry
  Future<int> deleteWork(Work work) => delete(works).delete(work);

  /// Update a work entry
  Future<bool> updateWork(Work work) => update(works).replace(work);
  
  /// Get total earnings (Sum of all work amounts)
  Future<double?> getTotalEarnings() {
    final totalAmount = works.totalAmount.sum();
    final query = selectOnly(works)..addColumns([totalAmount]);
    return query.map((row) => row.read(totalAmount)).getSingle();
  }
  
  /// Get total count of work entries
  Future<int> getTotalWorkCount() async {
    final count = works.id.count();
    final query = selectOnly(works)..addColumns([count]);
    final result = await query.map((row) => row.read(count)).getSingle();
    return result ?? 0;
  }

  /// Get total work amount grouped by farmer
  /// Returns a Map: {farmerId: totalAmount}
  Future<Map<int, double>> getFarmerWorkTotals() async {
    final totalAmount = works.totalAmount.sum();
    final query = selectOnly(works)
      ..addColumns([works.farmerId, totalAmount])
      ..groupBy([works.farmerId]);
    
    final result = await query.get();
    return {
      for (final row in result)
        if (row.read(works.farmerId) != null)
          row.read(works.farmerId)!: row.read(totalAmount) ?? 0.0
    };
  }

  // ===========================================================================
  // PAYMENT QUERIES
  // ===========================================================================

  /// Get all payments for a specific farmer, ordered by date (newest first)
  Future<List<Payment>> getPaymentsForFarmer(int farmerId) {
    return (select(payments)
          ..where((t) => t.farmerId.equals(farmerId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  /// Insert a new payment
  Future<int> insertPayment(PaymentsCompanion payment) => into(payments).insert(payment);

  /// Delete a payment
  Future<int> deletePayment(Payment payment) => delete(payments).delete(payment);

  /// Update a payment
  Future<bool> updatePayment(Payment payment) => update(payments).replace(payment);

  /// Get total received amount (Sum of all payments)
  Future<double?> getTotalReceived() {
    final total = payments.amount.sum();
    final query = selectOnly(payments)..addColumns([total]);
    return query.map((row) => row.read(total)).getSingle();
  }

  /// Get total payment amount grouped by farmer
  /// Returns a Map: {farmerId: totalAmount}
  Future<Map<int, double>> getFarmerPaymentTotals() async {
    final totalPayment = payments.amount.sum();
    final query = selectOnly(payments)
      ..addColumns([payments.farmerId, totalPayment])
      ..groupBy([payments.farmerId]);
    
    final result = await query.get();
    return {
      for (final row in result)
        if (row.read(payments.farmerId) != null)
          row.read(payments.farmerId)!: row.read(totalPayment) ?? 0.0
    };
  }
}

/// ---------------------------------------------------------------------------
/// Helper: Open Database Connection
/// ---------------------------------------------------------------------------
LazyDatabase _openConnection() {
  // Finds the right location for the database file asynchronously
  return LazyDatabase(() async {
    // Get the application documents directory
    final dbFolder = await getApplicationDocumentsDirectory();
    
    // Create the database file 'db.sqlite'
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    
    // Open the database in a background isolate for performance
    return NativeDatabase.createInBackground(file);
  });
}
