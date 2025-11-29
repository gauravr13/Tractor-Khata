// =============================================================================
// PROJECT: Tractor Khata
// FILE: work_repository.dart
// DESCRIPTION:
// This repository handles all data operations related to:
// 1. Work Entries (Recording work done)
// 2. Work Types (Rate Card management)
// 3. Payments (Recording payments received)
// =============================================================================

import 'package:drift/drift.dart';
import '../local/database.dart';

/// ---------------------------------------------------------------------------
/// Class: WorkRepository
/// Purpose: Manages CRUD operations for Work, WorkType, and Payment entities.
/// ---------------------------------------------------------------------------
class WorkRepository {
  final AppDatabase _db;

  /// Constructor: Requires an instance of AppDatabase
  WorkRepository(this._db);

  // ===========================================================================
  // WORK TYPE (RATE CARD) OPERATIONS
  // ===========================================================================

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

  // ===========================================================================
  // WORK ENTRY OPERATIONS
  // ===========================================================================

  /// Retrieves all work entries for a specific farmer.
  Future<List<Work>> getWorksForFarmer(int farmerId) {
    return _db.getWorksForFarmer(farmerId);
  }

  /// Adds a new work entry for a farmer.
  /// Automatically calculates:
  /// - Duration (in minutes)
  /// - Total Amount (Duration * Rate)
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
  
  /// Gets total earnings summary (Sum of all work amounts).
  Future<double> getTotalEarnings() async {
    return (await _db.getTotalEarnings()) ?? 0.0;
  }
  
  /// Gets total work count summary.
  Future<int> getTotalWorkCount() {
    return _db.getTotalWorkCount();
  }

  // ===========================================================================
  // PAYMENT OPERATIONS
  // ===========================================================================

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

  /// Gets total received amount (Sum of all payments).
  Future<double> getTotalReceived() async => (await _db.getTotalReceived()) ?? 0.0;

  /// Gets pending amount for all farmers efficiently.
  /// Calculates: (Total Work Amount - Total Payment Amount) for each farmer.
  Future<Map<int, double>> getAllFarmerPendingAmounts() async {
    final workTotals = await _db.getFarmerWorkTotals();
    final paymentTotals = await _db.getFarmerPaymentTotals();
    
    final Map<int, double> pendingMap = {};
    
    // Merge keys from both maps
    final allKeys = {...workTotals.keys, ...paymentTotals.keys};
    
    for (final id in allKeys) {
      final work = workTotals[id] ?? 0.0;
      final payment = paymentTotals[id] ?? 0.0;
      pendingMap[id] = work - payment;
    }
    
    return pendingMap;
  }
}
