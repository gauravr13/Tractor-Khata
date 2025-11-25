import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

// Include the generated file.
part 'database.g.dart';

/// The main database class for the application.
/// It manages the connection to the SQLite database and provides methods to access data.
@DriftDatabase(tables: [Farmers, WorkTypes, Works, Payments])
class AppDatabase extends _$AppDatabase {
  /// Constructor that opens the connection.
  AppDatabase() : super(_openConnection());

  /// The schema version of the database.
  /// Should be incremented whenever the schema changes.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(payments);
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Farmers Queries
  // ---------------------------------------------------------------------------

  /// Retrieves all farmers from the database.
  /// Returns a list of [Farmer] objects.
  Future<List<Farmer>> getAllFarmers() => select(farmers).get();

  /// Retrieves a single farmer by their ID.
  /// Returns a [Farmer] object or null if not found.
  Future<Farmer?> getFarmerById(int id) =>
      (select(farmers)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts a new farmer into the database.
  /// Returns the ID of the inserted farmer.
  Future<int> insertFarmer(FarmersCompanion farmer) =>
      into(farmers).insert(farmer);

  /// Updates an existing farmer's details.
  /// Returns true if the update was successful.
  Future<bool> updateFarmer(Farmer farmer) => update(farmers).replace(farmer);

  /// Deletes a farmer from the database.
  /// Returns the number of rows affected.
  Future<int> deleteFarmer(Farmer farmer) => delete(farmers).delete(farmer);
  
  /// Searches farmers by name or phone number.
  /// Returns a list of matching [Farmer] objects.
  Future<List<Farmer>> searchFarmers(String query) {
    return (select(farmers)
          ..where((t) => t.name.contains(query) | t.phone.contains(query)))
        .get();
  }

  // ---------------------------------------------------------------------------
  // WorkTypes (Rate Card) Queries
  // ---------------------------------------------------------------------------

  /// Retrieves all work types (Rate Card) from the database.
  Future<List<WorkType>> getAllWorkTypes() => select(workTypes).get();

  /// Inserts a new work type.
  Future<int> insertWorkType(WorkTypesCompanion workType) =>
      into(workTypes).insert(workType);

  /// Updates an existing work type.
  Future<bool> updateWorkType(WorkType workType) =>
      update(workTypes).replace(workType);

  /// Deletes a work type.
  Future<int> deleteWorkType(WorkType workType) =>
      delete(workTypes).delete(workType);

  // ---------------------------------------------------------------------------
  // Works Queries
  // ---------------------------------------------------------------------------

  /// Retrieves all work entries for a specific farmer.
  /// Ordered by work date (newest first).
  Future<List<Work>> getWorksForFarmer(int farmerId) {
    return (select(works)
          ..where((t) => t.farmerId.equals(farmerId))
          ..orderBy([(t) => OrderingTerm(expression: t.workDate, mode: OrderingMode.desc)]))
        .get();
  }

  /// Inserts a new work entry.
  Future<int> insertWork(WorksCompanion work) => into(works).insert(work);

  /// Deletes a work entry.
  Future<int> deleteWork(Work work) => delete(works).delete(work);

  /// Updates a work entry.
  Future<bool> updateWork(Work work) => update(works).replace(work);
  
  /// Gets the total earnings (sum of totalAmount) from all works.
  /// Used for the Profit Summary.
  Future<double?> getTotalEarnings() {
    final totalAmount = works.totalAmount.sum();
    final query = selectOnly(works)..addColumns([totalAmount]);
    return query.map((row) => row.read(totalAmount)).getSingle();
  }
  
  /// Gets the total count of work entries.
  Future<int> getTotalWorkCount() async {
    final count = works.id.count();
    final query = selectOnly(works)..addColumns([count]);
    final result = await query.map((row) => row.read(count)).getSingle();
    return result ?? 0;
  }

  /// Gets total work amount per farmer.
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

  // ---------------------------------------------------------------------------
  // Payments Queries
  // ---------------------------------------------------------------------------

  /// Retrieves all payments for a specific farmer.
  /// Ordered by date (newest first).
  Future<List<Payment>> getPaymentsForFarmer(int farmerId) {
    return (select(payments)
          ..where((t) => t.farmerId.equals(farmerId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  /// Inserts a new payment entry.
  Future<int> insertPayment(PaymentsCompanion payment) => into(payments).insert(payment);

  /// Deletes a payment entry.
  Future<int> deletePayment(Payment payment) => delete(payments).delete(payment);

  /// Updates a payment entry.
  Future<bool> updatePayment(Payment payment) => update(payments).replace(payment);

  /// Gets the total received amount (sum of amount) from all payments.
  Future<double?> getTotalReceived() {
    final total = payments.amount.sum();
    final query = selectOnly(payments)..addColumns([total]);
    return query.map((row) => row.read(total)).getSingle();
  }

  /// Gets total payment amount per farmer.
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

/// Opens the connection to the SQLite database.
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
