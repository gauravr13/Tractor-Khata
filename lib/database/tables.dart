import 'package:drift/drift.dart';

// This file defines the database tables for the Tractor Khata app.
// It uses the Drift package to generate the database code.

/// Table to store farmer details.
/// This table holds the personal information of the farmers.
class Farmers extends Table {
  /// Unique identifier for the farmer. Auto-incremented.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the farmer. Required.
  TextColumn get name => text()();

  /// Phone number of the farmer. Optional.
  TextColumn get phone => text().nullable()();

  /// Additional notes about the farmer. Optional.
  TextColumn get notes => text().nullable()();

  /// Date and time when this record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Date and time when this record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table to store work types (Rate Card).
/// This defines the different types of work (e.g., Jutai, Rotavator) and their default rates.
class WorkTypes extends Table {
  /// Unique identifier for the work type. Auto-incremented.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the work type (e.g., "Jutai"). Required.
  TextColumn get name => text()();

  /// Default rate per hour for this work type. Required.
  RealColumn get ratePerHour => real()();

  /// Date and time when this record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Date and time when this record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table to store work entries.
/// This records the actual work done for a farmer.
class Works extends Table {
  /// Unique identifier for the work entry. Auto-incremented.
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key linking to the [Farmers] table.
  /// Identifies which farmer this work belongs to.
  IntColumn get farmerId => integer().references(Farmers, #id)();

  /// Foreign key linking to the [WorkTypes] table.
  /// Optional, because the user might enter a custom work name.
  IntColumn get workTypeId => integer().nullable().references(WorkTypes, #id)();

  /// Custom name for the work if not selected from [WorkTypes].
  /// This is used when 'Write your own work name' is selected.
  TextColumn get customWorkName => text().nullable()();

  /// The time when the work started.
  DateTimeColumn get startTime => dateTime()();

  /// The time when the work ended.
  DateTimeColumn get endTime => dateTime()();

  /// The total duration of the work in minutes.
  /// Calculated as (endTime - startTime).
  IntColumn get durationInMinutes => integer()();

  /// The rate charged per hour for this specific work entry.
  RealColumn get ratePerHour => real()();

  /// The total amount for this work entry.
  /// Calculated as (durationInHours * ratePerHour).
  RealColumn get totalAmount => real()();

  /// The date when the work was performed.
  /// Usually the same as startTime, but stored separately for easier filtering by date.
  DateTimeColumn get workDate => dateTime()();

  /// Additional notes about this specific work entry.
  TextColumn get notes => text().nullable()();
}

/// Table to store payments received from farmers.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get farmerId => integer().references(Farmers, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
