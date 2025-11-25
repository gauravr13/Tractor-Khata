// =============================================================================
// PROJECT: Tractor Khata
// FILE: work_provider.dart
// DESCRIPTION:
// This provider handles the state for:
// 1. Work Entries (Adding, Editing, Deleting)
// 2. Payments (Adding, Editing, Deleting)
// 3. Rate Card (Work Types)
// 4. Dashboard Statistics (Total Earnings, Pending Amounts)
// =============================================================================

import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../repositories/work_repository.dart';

/// ---------------------------------------------------------------------------
/// Class: WorkProvider
/// Purpose: Central state management for all financial and work-related data.
/// ---------------------------------------------------------------------------
class WorkProvider with ChangeNotifier {
  final WorkRepository _repository;

  // --- State Variables ---
  
  // List of available work types (Rate Card)
  List<WorkType> _workTypes = [];
  
  // Combined list of Works and Payments for the currently selected farmer
  List<dynamic> _transactions = []; 
  
  // Stats for the currently selected farmer
  double _farmerTotalWorkAmount = 0.0;
  double _farmerTotalReceived = 0.0;
  int _farmerWorkCount = 0;

  // Global Dashboard Stats
  double _totalEarnings = 0.0;
  double _totalReceived = 0.0;
  int _totalWorkCount = 0;
  
  // Loading state indicator
  bool _isLoading = false;
  
  // Cache for pending amounts of all farmers (for the Farmer List screen)
  Map<int, double> _allFarmerPendingAmounts = {};

  // --- Getters ---

  List<WorkType> get workTypes => _workTypes;
  List<dynamic> get transactions => _transactions;
  
  // Farmer Stats Getters
  double get farmerTotalWorkAmount => _farmerTotalWorkAmount;
  double get farmerTotalReceived => _farmerTotalReceived;
  double get farmerPendingAmount => _farmerTotalWorkAmount - _farmerTotalReceived;
  int get farmerWorkCount => _farmerWorkCount;

  // Global Stats Getters
  double get totalEarnings => _totalEarnings;
  double get totalReceived => _totalReceived;
  double get totalPending => _totalEarnings - _totalReceived;
  int get totalWorkCountGlobal => _totalWorkCount;
  
  bool get isLoading => _isLoading;
  Map<int, double> get allFarmerPendingAmounts => _allFarmerPendingAmounts;

  /// Constructor: Requires WorkRepository dependency
  WorkProvider(this._repository);

  // ===========================================================================
  // RATE CARD (WORK TYPE) METHODS
  // ===========================================================================

  /// Loads all work types from the database.
  Future<void> loadWorkTypes() async {
    _workTypes = await _repository.getAllWorkTypes();
    notifyListeners();
  }

  /// Adds a new work type to the rate card.
  Future<void> addWorkType({required String name, required double ratePerHour}) async {
    await _repository.addWorkType(name: name, ratePerHour: ratePerHour);
    await loadWorkTypes(); // Refresh list
  }

  /// Updates an existing work type.
  Future<void> updateWorkType(WorkType workType) async {
    await _repository.updateWorkType(workType);
    await loadWorkTypes(); // Refresh list
  }

  /// Deletes a work type.
  Future<void> deleteWorkType(WorkType workType) async {
    await _repository.deleteWorkType(workType);
    await loadWorkTypes(); // Refresh list
  }

  // ===========================================================================
  // TRANSACTION METHODS (WORK + PAYMENT)
  // ===========================================================================

  /// Loads both Works and Payments for a specific farmer.
  /// Combines them into a single list sorted by date (newest first).
  /// Also calculates totals for that farmer.
  Future<void> loadTransactionsForFarmer(int farmerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final works = await _repository.getWorksForFarmer(farmerId);
      final payments = await _repository.getPaymentsForFarmer(farmerId);

      // Calculate totals
      _farmerTotalWorkAmount = works.fold(0.0, (sum, item) => sum + item.totalAmount);
      _farmerWorkCount = works.length;
      _farmerTotalReceived = payments.fold(0.0, (sum, item) => sum + item.amount);

      // Combine lists
      _transactions = [...works, ...payments];
      
      // Sort by date descending
      _transactions.sort((a, b) {
        DateTime dateA;
        if (a is Work) dateA = a.workDate;
        else if (a is Payment) dateA = a.date;
        else dateA = DateTime(0);

        DateTime dateB;
        if (b is Work) dateB = b.workDate;
        else if (b is Payment) dateB = b.date;
        else dateB = DateTime(0);

        return dateB.compareTo(dateA);
      });

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new work entry and refreshes stats.
  Future<void> addWork({
    required int farmerId,
    int? workTypeId,
    String? customWorkName,
    required DateTime startTime,
    required DateTime endTime,
    required double ratePerHour,
    DateTime? workDate,
    String? notes,
  }) async {
    await _repository.addWork(
      farmerId: farmerId,
      workTypeId: workTypeId,
      customWorkName: customWorkName,
      startTime: startTime,
      endTime: endTime,
      ratePerHour: ratePerHour,
      workDate: workDate,
      notes: notes,
    );
    await loadTransactionsForFarmer(farmerId);
    await loadDashboardStats(); // Refresh global stats
  }

  /// Deletes a work entry and refreshes stats.
  Future<void> deleteWork(Work work) async {
    await _repository.deleteWork(work);
    await loadTransactionsForFarmer(work.farmerId);
    await loadDashboardStats();
  }

  /// Updates a work entry and refreshes stats.
  Future<void> updateWork(Work work) async {
    await _repository.updateWork(work);
    await loadTransactionsForFarmer(work.farmerId);
    await loadDashboardStats();
  }
  
  // ===========================================================================
  // PAYMENT METHODS
  // ===========================================================================

  /// Adds a new payment and refreshes stats.
  Future<void> addPayment({required int farmerId, required double amount, required DateTime date, String? notes}) async {
    await _repository.addPayment(farmerId: farmerId, amount: amount, date: date, notes: notes);
    await loadTransactionsForFarmer(farmerId);
    await loadDashboardStats();
  }

  /// Deletes a payment and refreshes stats.
  Future<void> deletePayment(Payment payment) async {
    await _repository.deletePayment(payment);
    await loadTransactionsForFarmer(payment.farmerId);
    await loadDashboardStats();
  }

  /// Updates a payment and refreshes stats.
  Future<void> updatePayment(Payment payment) async {
    await _repository.updatePayment(payment);
    await loadTransactionsForFarmer(payment.farmerId);
    await loadDashboardStats();
  }

  // ===========================================================================
  // DASHBOARD & GLOBAL STATS
  // ===========================================================================

  /// Loads global statistics for the dashboard (Total Earnings, Total Received, etc.)
  Future<void> loadDashboardStats() async {
    _totalEarnings = await _repository.getTotalEarnings();
    _totalWorkCount = await _repository.getTotalWorkCount();
    _totalReceived = await _repository.getTotalReceived();
    notifyListeners();
  }
  
  /// Loads pending amounts for all farmers efficiently.
  /// Used to display "Pending: ₹500" on the farmer list cards.
  Future<void> loadAllFarmerPendingAmounts() async {
    _allFarmerPendingAmounts = await _repository.getAllFarmerPendingAmounts();
    notifyListeners();
  }
}
