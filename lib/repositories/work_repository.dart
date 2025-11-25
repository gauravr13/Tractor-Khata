import 'package:drift/drift.dart';
import '../database/database.dart';

/// Repository class for managing Work entries and Rate Card (Work Types).
class WorkRepository {
  final AppDatabase _db;

  /// Constructor requiring the [AppDatabase] instance.
  WorkRepository(this._db);

  // ---------------------------------------------------------------------------
  // Work Type (Rate Card) Operations
  // ---------------------------------------------------------------------------

  /// Retrieves all defined work types (Rate Card).
  Future<List<WorkType>> getAllWorkTypes() {
    return _db.getAllWorkTypes();
  }

  /// Adds a new work type to the Rate Card.
  Future<int> addWorkType({required String name, required double ratePerHour}) {
    final companion = WorkTypesCompanion(
      name: Value(name),
      ratePerHour: Value(ratePerHour),
    );
    return _db.insertWorkType(companion);
  }

  /// Updates an existing work type.
  Future<bool> updateWorkType(WorkType workType) {
    return _db.updateWorkType(workType);
  }

  /// Deletes a work type.
  Future<int> deleteWorkType(WorkType workType) {
    return _db.deleteWorkType(workType);
  }

  // ---------------------------------------------------------------------------
  // Work Entry Operations
  // ---------------------------------------------------------------------------

  /// Retrieves all work entries for a specific farmer.
  Future<List<Work>> getWorksForFarmer(int farmerId) {
    return _db.getWorksForFarmer(farmerId);
  }

  /// Adds a new work entry for a farmer.
  /// Calculates duration and total amount before saving.
  Future<int> addWork({
    required int farmerId,
    int? workTypeId,
    String? customWorkName,
    required DateTime startTime,
    required DateTime endTime,
    required double ratePerHour,
    DateTime? workDate,
    String? notes,
  }) {
    // Calculate duration in minutes
    final durationInMinutes = endTime.difference(startTime).inMinutes;
    
    // Calculate total amount: (minutes / 60) * rate
    final durationInHours = durationInMinutes / 60.0;
    final totalAmount = durationInHours * ratePerHour;

    final companion = WorksCompanion(
      farmerId: Value(farmerId),
      workTypeId: Value(workTypeId),
      customWorkName: Value(customWorkName),
      startTime: Value(startTime),
      endTime: Value(endTime),
      durationInMinutes: Value(durationInMinutes),
      ratePerHour: Value(ratePerHour),
      totalAmount: Value(totalAmount),
      workDate: Value(workDate ?? startTime),
      notes: Value(notes),
    );
    return _db.insertWork(companion);
  }

  /// Deletes a work entry.
  Future<int> deleteWork(Work work) {
    return _db.deleteWork(work);
  }

  /// Updates a work entry.
  Future<bool> updateWork(Work work) {
    return _db.updateWork(work);
  }
  
  /// Gets total earnings summary.
  Future<double> getTotalEarnings() async {
    return (await _db.getTotalEarnings()) ?? 0.0;
  }
  
  /// Gets total work count summary.
  Future<int> getTotalWorkCount() {
    return _db.getTotalWorkCount();
  }

  // ---------------------------------------------------------------------------
  // Payment Operations
  // ---------------------------------------------------------------------------

  /// Retrieves all payments for a specific farmer.
  Future<List<Payment>> getPaymentsForFarmer(int farmerId) {
    return _db.getPaymentsForFarmer(farmerId);
  }

  /// Adds a new payment entry.
  Future<int> addPayment({required int farmerId, required double amount, required DateTime date, String? notes}) {
    final companion = PaymentsCompanion(
      farmerId: Value(farmerId),
      amount: Value(amount),
      date: Value(date),
      notes: Value(notes),
    );
    return _db.insertPayment(companion);
  }

  /// Deletes a payment entry.
  Future<int> deletePayment(Payment payment) => _db.deletePayment(payment);

  /// Updates a payment entry.
  Future<bool> updatePayment(Payment payment) => _db.updatePayment(payment);

  /// Gets total received amount.
  Future<double> getTotalReceived() async => (await _db.getTotalReceived()) ?? 0.0;

  /// Gets pending amount for all farmers efficiently.
  Future<Map<int, double>> getAllFarmerPendingAmounts() async {
    final workTotals = await _db.getFarmerWorkTotals();
    final paymentTotals = await _db.getFarmerPaymentTotals();
    
    final Map<int, double> pendingMap = {};
    
    // Merge keys
    final allKeys = {...workTotals.keys, ...paymentTotals.keys};
    
    for (final id in allKeys) {
      final work = workTotals[id] ?? 0.0;
      final payment = paymentTotals[id] ?? 0.0;
      pendingMap[id] = work - payment;
    }
    
    return pendingMap;
  }
}
