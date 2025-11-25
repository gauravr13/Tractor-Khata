import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../repositories/work_repository.dart';

/// Provider class for managing Work, Payments, and Rate Card state.
class WorkProvider with ChangeNotifier {
  final WorkRepository _repository;

  List<WorkType> _workTypes = [];
  
  // Combined list of Works and Payments for the current farmer
  List<dynamic> _transactions = []; 
  
  // Stats for the current farmer
  double _farmerTotalWorkAmount = 0.0;
  double _farmerTotalReceived = 0.0;
  int _farmerWorkCount = 0;

  // Global stats
  double _totalEarnings = 0.0;
  double _totalReceived = 0.0;
  int _totalWorkCount = 0;
  
  bool _isLoading = false;

  /// Returns the list of work types (Rate Card).
  List<WorkType> get workTypes => _workTypes;

  /// Returns the combined list of works and payments for the currently selected farmer.
  List<dynamic> get transactions => _transactions;
  
  // Farmer specific stats
  double get farmerTotalWorkAmount => _farmerTotalWorkAmount;
  double get farmerTotalReceived => _farmerTotalReceived;
  double get farmerPendingAmount => _farmerTotalWorkAmount - _farmerTotalReceived;
  int get farmerWorkCount => _farmerWorkCount;

  // Global stats
  double get totalEarnings => _totalEarnings;
  double get totalReceived => _totalReceived;
  double get totalPending => _totalEarnings - _totalReceived;
  int get totalWorkCountGlobal => _totalWorkCount; // Renamed to avoid confusion

  /// Returns the loading state.
  bool get isLoading => _isLoading;
  
  // Cache for all farmer pending amounts
  Map<int, double> _allFarmerPendingAmounts = {};
  Map<int, double> get allFarmerPendingAmounts => _allFarmerPendingAmounts;

  WorkProvider(this._repository);

  // ---------------------------------------------------------------------------
  // Work Type (Rate Card) Methods
  // ---------------------------------------------------------------------------

  Future<void> loadWorkTypes() async {
    _workTypes = await _repository.getAllWorkTypes();
    notifyListeners();
  }

  Future<void> addWorkType({required String name, required double ratePerHour}) async {
    await _repository.addWorkType(name: name, ratePerHour: ratePerHour);
    await loadWorkTypes();
  }

  Future<void> updateWorkType(WorkType workType) async {
    await _repository.updateWorkType(workType);
    await loadWorkTypes();
  }

  Future<void> deleteWorkType(WorkType workType) async {
    await _repository.deleteWorkType(workType);
    await loadWorkTypes();
  }

  // ---------------------------------------------------------------------------
  // Transaction Methods (Work + Payment)
  // ---------------------------------------------------------------------------

  /// Loads works and payments for a specific farmer, combines them, and calculates totals.
  Future<void> loadTransactionsForFarmer(int farmerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final works = await _repository.getWorksForFarmer(farmerId);
      final payments = await _repository.getPaymentsForFarmer(farmerId);

      _farmerTotalWorkAmount = works.fold(0.0, (sum, item) => sum + item.totalAmount);
      _farmerWorkCount = works.length;
      _farmerTotalReceived = payments.fold(0.0, (sum, item) => sum + item.amount);

      // Combine and sort
      _transactions = [...works, ...payments];
      _transactions.sort((a, b) {
        DateTime dateA;
        if (a is Work) dateA = a.workDate;
        else if (a is Payment) dateA = a.date;
        else dateA = DateTime(0);

        DateTime dateB;
        if (b is Work) dateB = b.workDate;
        else if (b is Payment) dateB = b.date;
        else dateB = DateTime(0);

        return dateB.compareTo(dateA); // Descending
      });

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new work entry.
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
    await loadDashboardStats();
  }

  Future<void> deleteWork(Work work) async {
    await _repository.deleteWork(work);
    await loadTransactionsForFarmer(work.farmerId);
    await loadDashboardStats();
  }

  Future<void> updateWork(Work work) async {
    await _repository.updateWork(work);
    await loadTransactionsForFarmer(work.farmerId);
    await loadDashboardStats();
  }
  
  // ---------------------------------------------------------------------------
  // Payment Methods
  // ---------------------------------------------------------------------------

  Future<void> addPayment({required int farmerId, required double amount, required DateTime date, String? notes}) async {
    await _repository.addPayment(farmerId: farmerId, amount: amount, date: date, notes: notes);
    await loadTransactionsForFarmer(farmerId);
    await loadDashboardStats();
  }

  Future<void> deletePayment(Payment payment) async {
    await _repository.deletePayment(payment);
    await loadTransactionsForFarmer(payment.farmerId);
    await loadDashboardStats();
  }

  Future<void> updatePayment(Payment payment) async {
    await _repository.updatePayment(payment);
    await loadTransactionsForFarmer(payment.farmerId);
    await loadDashboardStats();
  }

  /// Loads global dashboard statistics.
  Future<void> loadDashboardStats() async {
    _totalEarnings = await _repository.getTotalEarnings();
    _totalWorkCount = await _repository.getTotalWorkCount();
    _totalReceived = await _repository.getTotalReceived();
    notifyListeners();
  }
  
  /// Loads pending amounts for all farmers.
  Future<void> loadAllFarmerPendingAmounts() async {
    _allFarmerPendingAmounts = await _repository.getAllFarmerPendingAmounts();
    notifyListeners();
  }
}
