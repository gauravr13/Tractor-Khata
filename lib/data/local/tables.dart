// =============================================================================
// PROJECT: Tractor Khata
// FILE: tables.dart
// DESCRIPTION:
// This file defines the database schema using the Drift package.
// It contains the table definitions for:
// 1. Farmers: Stores farmer profiles.
// 2. WorkTypes: Stores rate card items (e.g., Plowing, Sowing).
// 3. Works: Stores individual work records linked to farmers.
// 4. Payments: Stores payment records linked to farmers.
// =============================================================================

import 'package:drift/drift.dart';

/// ---------------------------------------------------------------------------
/// Table: Farmers
/// Description: Stores personal details of farmers/clients.
/// ---------------------------------------------------------------------------
class Farmers extends Table {
  /// Unique identifier (Primary Key, Auto-increment)
  IntColumn get id => integer().autoIncrement()();

  /// Farmer's Name (Required)
  TextColumn get name => text()();

  /// Farmer's Phone Number (Optional)
  TextColumn get phone => text().nullable()();

  /// Additional Notes (Optional)
  TextColumn get notes => text().nullable()();

  /// Record Creation Timestamp (Default: Current Time)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Record Update Timestamp (Default: Current Time)
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// Table: WorkTypes
/// Description: Stores the Rate Card items (Predefined work types with rates).
/// ---------------------------------------------------------------------------
class WorkTypes extends Table {
  /// Unique identifier (Primary Key, Auto-increment)
  IntColumn get id => integer().autoIncrement()();

  /// Name of the work (e.g., "Jutai", "Rotavator")
  TextColumn get name => text()();

  /// Default Rate per Hour for this work type
  RealColumn get ratePerHour => real()();

  /// Record Creation Timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Record Update Timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// Table: Works
/// Description: Stores the actual work done for a farmer.
/// Links to [Farmers] and optionally [WorkTypes].
/// ---------------------------------------------------------------------------
class Works extends Table {
  /// Unique identifier (Primary Key, Auto-increment)
  IntColumn get id => integer().autoIncrement()();

  /// Foreign Key: Links to the Farmer who owns this work
  IntColumn get farmerId => integer().references(Farmers, #id)();

  /// Foreign Key: Links to a WorkType (Optional)
  /// Nullable because users can enter a custom work name without a predefined type.
  IntColumn get workTypeId => integer().nullable().references(WorkTypes, #id)();

  /// Custom Work Name (Used if workTypeId is null)
  TextColumn get customWorkName => text().nullable()();

  /// Work Start Time
  DateTimeColumn get startTime => dateTime()();

  /// Work End Time
  DateTimeColumn get endTime => dateTime()();

  /// Duration in Minutes (Calculated: endTime - startTime)
  IntColumn get durationInMinutes => integer()();

  /// Rate Charged Per Hour for this specific job
  RealColumn get ratePerHour => real()();

  /// Total Amount (Calculated: Duration * Rate)
  RealColumn get totalAmount => real()();

  /// Date of Work (Stored separately for easier filtering)
  DateTimeColumn get workDate => dateTime()();

  /// Additional Notes for this work
  TextColumn get notes => text().nullable()();
}

/// ---------------------------------------------------------------------------
/// Table: Payments
/// Description: Stores payments received from farmers.
/// Links to [Farmers].
/// ---------------------------------------------------------------------------
class Payments extends Table {
  /// Unique identifier (Primary Key, Auto-increment)
  IntColumn get id => integer().autoIncrement()();

  /// Foreign Key: Links to the Farmer who made the payment
  IntColumn get farmerId => integer().references(Farmers, #id)();

  /// Amount Received
  RealColumn get amount => real()();

  /// Date of Payment
  DateTimeColumn get date => dateTime()();

  /// Additional Notes (e.g., "Cash", "UPI")
  TextColumn get notes => text().nullable()();

  /// Record Creation Timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
