// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FarmersTable extends Farmers with TableInfo<$FarmersTable, Farmer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farmers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Farmer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Farmer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Farmer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FarmersTable createAlias(String alias) {
    return $FarmersTable(attachedDatabase, alias);
  }
}

class Farmer extends DataClass implements Insertable<Farmer> {
  /// Unique identifier (Primary Key, Auto-increment)
  final int id;

  /// Farmer's Name (Required)
  final String name;

  /// Farmer's Phone Number (Optional)
  final String? phone;

  /// Additional Notes (Optional)
  final String? notes;

  /// Record Creation Timestamp (Default: Current Time)
  final DateTime createdAt;

  /// Record Update Timestamp (Default: Current Time)
  final DateTime updatedAt;
  const Farmer({
    required this.id,
    required this.name,
    this.phone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FarmersCompanion toCompanion(bool nullToAbsent) {
    return FarmersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Farmer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Farmer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Farmer copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Farmer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Farmer copyWithCompanion(FarmersCompanion data) {
    return Farmer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Farmer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Farmer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FarmersCompanion extends UpdateCompanion<Farmer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FarmersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FarmersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Farmer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FarmersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FarmersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkTypesTable extends WorkTypes
    with TableInfo<$WorkTypesTable, WorkType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratePerHourMeta = const VerificationMeta(
    'ratePerHour',
  );
  @override
  late final GeneratedColumn<double> ratePerHour = GeneratedColumn<double>(
    'rate_per_hour',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    ratePerHour,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rate_per_hour')) {
      context.handle(
        _ratePerHourMeta,
        ratePerHour.isAcceptableOrUnknown(
          data['rate_per_hour']!,
          _ratePerHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratePerHourMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ratePerHour: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_per_hour'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkTypesTable createAlias(String alias) {
    return $WorkTypesTable(attachedDatabase, alias);
  }
}

class WorkType extends DataClass implements Insertable<WorkType> {
  /// Unique identifier (Primary Key, Auto-increment)
  final int id;

  /// Name of the work (e.g., "Jutai", "Rotavator")
  final String name;

  /// Default Rate per Hour for this work type
  final double ratePerHour;

  /// Record Creation Timestamp
  final DateTime createdAt;

  /// Record Update Timestamp
  final DateTime updatedAt;
  const WorkType({
    required this.id,
    required this.name,
    required this.ratePerHour,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['rate_per_hour'] = Variable<double>(ratePerHour);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkTypesCompanion toCompanion(bool nullToAbsent) {
    return WorkTypesCompanion(
      id: Value(id),
      name: Value(name),
      ratePerHour: Value(ratePerHour),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ratePerHour: serializer.fromJson<double>(json['ratePerHour']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ratePerHour': serializer.toJson<double>(ratePerHour),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkType copyWith({
    int? id,
    String? name,
    double? ratePerHour,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkType(
    id: id ?? this.id,
    name: name ?? this.name,
    ratePerHour: ratePerHour ?? this.ratePerHour,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkType copyWithCompanion(WorkTypesCompanion data) {
    return WorkType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ratePerHour: data.ratePerHour.present
          ? data.ratePerHour.value
          : this.ratePerHour,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ratePerHour: $ratePerHour, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ratePerHour, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkType &&
          other.id == this.id &&
          other.name == this.name &&
          other.ratePerHour == this.ratePerHour &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkTypesCompanion extends UpdateCompanion<WorkType> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> ratePerHour;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WorkTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ratePerHour = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WorkTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double ratePerHour,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       ratePerHour = Value(ratePerHour);
  static Insertable<WorkType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? ratePerHour,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ratePerHour != null) 'rate_per_hour': ratePerHour,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WorkTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? ratePerHour,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WorkTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ratePerHour: ratePerHour ?? this.ratePerHour,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ratePerHour.present) {
      map['rate_per_hour'] = Variable<double>(ratePerHour.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ratePerHour: $ratePerHour, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorksTable extends Works with TableInfo<$WorksTable, Work> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _farmerIdMeta = const VerificationMeta(
    'farmerId',
  );
  @override
  late final GeneratedColumn<int> farmerId = GeneratedColumn<int>(
    'farmer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES farmers (id)',
    ),
  );
  static const VerificationMeta _workTypeIdMeta = const VerificationMeta(
    'workTypeId',
  );
  @override
  late final GeneratedColumn<int> workTypeId = GeneratedColumn<int>(
    'work_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES work_types (id)',
    ),
  );
  static const VerificationMeta _customWorkNameMeta = const VerificationMeta(
    'customWorkName',
  );
  @override
  late final GeneratedColumn<String> customWorkName = GeneratedColumn<String>(
    'custom_work_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationInMinutesMeta = const VerificationMeta(
    'durationInMinutes',
  );
  @override
  late final GeneratedColumn<int> durationInMinutes = GeneratedColumn<int>(
    'duration_in_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratePerHourMeta = const VerificationMeta(
    'ratePerHour',
  );
  @override
  late final GeneratedColumn<double> ratePerHour = GeneratedColumn<double>(
    'rate_per_hour',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workDateMeta = const VerificationMeta(
    'workDate',
  );
  @override
  late final GeneratedColumn<DateTime> workDate = GeneratedColumn<DateTime>(
    'work_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    farmerId,
    workTypeId,
    customWorkName,
    startTime,
    endTime,
    durationInMinutes,
    ratePerHour,
    totalAmount,
    workDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'works';
  @override
  VerificationContext validateIntegrity(
    Insertable<Work> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('farmer_id')) {
      context.handle(
        _farmerIdMeta,
        farmerId.isAcceptableOrUnknown(data['farmer_id']!, _farmerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_farmerIdMeta);
    }
    if (data.containsKey('work_type_id')) {
      context.handle(
        _workTypeIdMeta,
        workTypeId.isAcceptableOrUnknown(
          data['work_type_id']!,
          _workTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('custom_work_name')) {
      context.handle(
        _customWorkNameMeta,
        customWorkName.isAcceptableOrUnknown(
          data['custom_work_name']!,
          _customWorkNameMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('duration_in_minutes')) {
      context.handle(
        _durationInMinutesMeta,
        durationInMinutes.isAcceptableOrUnknown(
          data['duration_in_minutes']!,
          _durationInMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationInMinutesMeta);
    }
    if (data.containsKey('rate_per_hour')) {
      context.handle(
        _ratePerHourMeta,
        ratePerHour.isAcceptableOrUnknown(
          data['rate_per_hour']!,
          _ratePerHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratePerHourMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('work_date')) {
      context.handle(
        _workDateMeta,
        workDate.isAcceptableOrUnknown(data['work_date']!, _workDateMeta),
      );
    } else if (isInserting) {
      context.missing(_workDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Work map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Work(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      farmerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farmer_id'],
      )!,
      workTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_type_id'],
      ),
      customWorkName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_work_name'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      durationInMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_in_minutes'],
      )!,
      ratePerHour: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_per_hour'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      workDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}work_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorksTable createAlias(String alias) {
    return $WorksTable(attachedDatabase, alias);
  }
}

class Work extends DataClass implements Insertable<Work> {
  /// Unique identifier (Primary Key, Auto-increment)
  final int id;

  /// Foreign Key: Links to the Farmer who owns this work
  final int farmerId;

  /// Foreign Key: Links to a WorkType (Optional)
  /// Nullable because users can enter a custom work name without a predefined type.
  final int? workTypeId;

  /// Custom Work Name (Used if workTypeId is null)
  final String? customWorkName;

  /// Work Start Time
  final DateTime startTime;

  /// Work End Time
  final DateTime endTime;

  /// Duration in Minutes (Calculated: endTime - startTime)
  final int durationInMinutes;

  /// Rate Charged Per Hour for this specific job
  final double ratePerHour;

  /// Total Amount (Calculated: Duration * Rate)
  final double totalAmount;

  /// Date of Work (Stored separately for easier filtering)
  final DateTime workDate;

  /// Additional Notes for this work
  final String? notes;
  const Work({
    required this.id,
    required this.farmerId,
    this.workTypeId,
    this.customWorkName,
    required this.startTime,
    required this.endTime,
    required this.durationInMinutes,
    required this.ratePerHour,
    required this.totalAmount,
    required this.workDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['farmer_id'] = Variable<int>(farmerId);
    if (!nullToAbsent || workTypeId != null) {
      map['work_type_id'] = Variable<int>(workTypeId);
    }
    if (!nullToAbsent || customWorkName != null) {
      map['custom_work_name'] = Variable<String>(customWorkName);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['duration_in_minutes'] = Variable<int>(durationInMinutes);
    map['rate_per_hour'] = Variable<double>(ratePerHour);
    map['total_amount'] = Variable<double>(totalAmount);
    map['work_date'] = Variable<DateTime>(workDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorksCompanion toCompanion(bool nullToAbsent) {
    return WorksCompanion(
      id: Value(id),
      farmerId: Value(farmerId),
      workTypeId: workTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(workTypeId),
      customWorkName: customWorkName == null && nullToAbsent
          ? const Value.absent()
          : Value(customWorkName),
      startTime: Value(startTime),
      endTime: Value(endTime),
      durationInMinutes: Value(durationInMinutes),
      ratePerHour: Value(ratePerHour),
      totalAmount: Value(totalAmount),
      workDate: Value(workDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Work.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Work(
      id: serializer.fromJson<int>(json['id']),
      farmerId: serializer.fromJson<int>(json['farmerId']),
      workTypeId: serializer.fromJson<int?>(json['workTypeId']),
      customWorkName: serializer.fromJson<String?>(json['customWorkName']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      durationInMinutes: serializer.fromJson<int>(json['durationInMinutes']),
      ratePerHour: serializer.fromJson<double>(json['ratePerHour']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      workDate: serializer.fromJson<DateTime>(json['workDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'farmerId': serializer.toJson<int>(farmerId),
      'workTypeId': serializer.toJson<int?>(workTypeId),
      'customWorkName': serializer.toJson<String?>(customWorkName),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'durationInMinutes': serializer.toJson<int>(durationInMinutes),
      'ratePerHour': serializer.toJson<double>(ratePerHour),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'workDate': serializer.toJson<DateTime>(workDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Work copyWith({
    int? id,
    int? farmerId,
    Value<int?> workTypeId = const Value.absent(),
    Value<String?> customWorkName = const Value.absent(),
    DateTime? startTime,
    DateTime? endTime,
    int? durationInMinutes,
    double? ratePerHour,
    double? totalAmount,
    DateTime? workDate,
    Value<String?> notes = const Value.absent(),
  }) => Work(
    id: id ?? this.id,
    farmerId: farmerId ?? this.farmerId,
    workTypeId: workTypeId.present ? workTypeId.value : this.workTypeId,
    customWorkName: customWorkName.present
        ? customWorkName.value
        : this.customWorkName,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    durationInMinutes: durationInMinutes ?? this.durationInMinutes,
    ratePerHour: ratePerHour ?? this.ratePerHour,
    totalAmount: totalAmount ?? this.totalAmount,
    workDate: workDate ?? this.workDate,
    notes: notes.present ? notes.value : this.notes,
  );
  Work copyWithCompanion(WorksCompanion data) {
    return Work(
      id: data.id.present ? data.id.value : this.id,
      farmerId: data.farmerId.present ? data.farmerId.value : this.farmerId,
      workTypeId: data.workTypeId.present
          ? data.workTypeId.value
          : this.workTypeId,
      customWorkName: data.customWorkName.present
          ? data.customWorkName.value
          : this.customWorkName,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationInMinutes: data.durationInMinutes.present
          ? data.durationInMinutes.value
          : this.durationInMinutes,
      ratePerHour: data.ratePerHour.present
          ? data.ratePerHour.value
          : this.ratePerHour,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Work(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('workTypeId: $workTypeId, ')
          ..write('customWorkName: $customWorkName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('ratePerHour: $ratePerHour, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('workDate: $workDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    farmerId,
    workTypeId,
    customWorkName,
    startTime,
    endTime,
    durationInMinutes,
    ratePerHour,
    totalAmount,
    workDate,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Work &&
          other.id == this.id &&
          other.farmerId == this.farmerId &&
          other.workTypeId == this.workTypeId &&
          other.customWorkName == this.customWorkName &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationInMinutes == this.durationInMinutes &&
          other.ratePerHour == this.ratePerHour &&
          other.totalAmount == this.totalAmount &&
          other.workDate == this.workDate &&
          other.notes == this.notes);
}

class WorksCompanion extends UpdateCompanion<Work> {
  final Value<int> id;
  final Value<int> farmerId;
  final Value<int?> workTypeId;
  final Value<String?> customWorkName;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> durationInMinutes;
  final Value<double> ratePerHour;
  final Value<double> totalAmount;
  final Value<DateTime> workDate;
  final Value<String?> notes;
  const WorksCompanion({
    this.id = const Value.absent(),
    this.farmerId = const Value.absent(),
    this.workTypeId = const Value.absent(),
    this.customWorkName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationInMinutes = const Value.absent(),
    this.ratePerHour = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.workDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorksCompanion.insert({
    this.id = const Value.absent(),
    required int farmerId,
    this.workTypeId = const Value.absent(),
    this.customWorkName = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    required int durationInMinutes,
    required double ratePerHour,
    required double totalAmount,
    required DateTime workDate,
    this.notes = const Value.absent(),
  }) : farmerId = Value(farmerId),
       startTime = Value(startTime),
       endTime = Value(endTime),
       durationInMinutes = Value(durationInMinutes),
       ratePerHour = Value(ratePerHour),
       totalAmount = Value(totalAmount),
       workDate = Value(workDate);
  static Insertable<Work> custom({
    Expression<int>? id,
    Expression<int>? farmerId,
    Expression<int>? workTypeId,
    Expression<String>? customWorkName,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationInMinutes,
    Expression<double>? ratePerHour,
    Expression<double>? totalAmount,
    Expression<DateTime>? workDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmerId != null) 'farmer_id': farmerId,
      if (workTypeId != null) 'work_type_id': workTypeId,
      if (customWorkName != null) 'custom_work_name': customWorkName,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationInMinutes != null) 'duration_in_minutes': durationInMinutes,
      if (ratePerHour != null) 'rate_per_hour': ratePerHour,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (workDate != null) 'work_date': workDate,
      if (notes != null) 'notes': notes,
    });
  }

  WorksCompanion copyWith({
    Value<int>? id,
    Value<int>? farmerId,
    Value<int?>? workTypeId,
    Value<String?>? customWorkName,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? durationInMinutes,
    Value<double>? ratePerHour,
    Value<double>? totalAmount,
    Value<DateTime>? workDate,
    Value<String?>? notes,
  }) {
    return WorksCompanion(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      workTypeId: workTypeId ?? this.workTypeId,
      customWorkName: customWorkName ?? this.customWorkName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      ratePerHour: ratePerHour ?? this.ratePerHour,
      totalAmount: totalAmount ?? this.totalAmount,
      workDate: workDate ?? this.workDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (farmerId.present) {
      map['farmer_id'] = Variable<int>(farmerId.value);
    }
    if (workTypeId.present) {
      map['work_type_id'] = Variable<int>(workTypeId.value);
    }
    if (customWorkName.present) {
      map['custom_work_name'] = Variable<String>(customWorkName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationInMinutes.present) {
      map['duration_in_minutes'] = Variable<int>(durationInMinutes.value);
    }
    if (ratePerHour.present) {
      map['rate_per_hour'] = Variable<double>(ratePerHour.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (workDate.present) {
      map['work_date'] = Variable<DateTime>(workDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorksCompanion(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('workTypeId: $workTypeId, ')
          ..write('customWorkName: $customWorkName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationInMinutes: $durationInMinutes, ')
          ..write('ratePerHour: $ratePerHour, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('workDate: $workDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _farmerIdMeta = const VerificationMeta(
    'farmerId',
  );
  @override
  late final GeneratedColumn<int> farmerId = GeneratedColumn<int>(
    'farmer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES farmers (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    farmerId,
    amount,
    date,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('farmer_id')) {
      context.handle(
        _farmerIdMeta,
        farmerId.isAcceptableOrUnknown(data['farmer_id']!, _farmerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_farmerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      farmerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farmer_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  /// Unique identifier (Primary Key, Auto-increment)
  final int id;

  /// Foreign Key: Links to the Farmer who made the payment
  final int farmerId;

  /// Amount Received
  final double amount;

  /// Date of Payment
  final DateTime date;

  /// Additional Notes (e.g., "Cash", "UPI")
  final String? notes;

  /// Record Creation Timestamp
  final DateTime createdAt;
  const Payment({
    required this.id,
    required this.farmerId,
    required this.amount,
    required this.date,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['farmer_id'] = Variable<int>(farmerId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      farmerId: Value(farmerId),
      amount: Value(amount),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      farmerId: serializer.fromJson<int>(json['farmerId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'farmerId': serializer.toJson<int>(farmerId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith({
    int? id,
    int? farmerId,
    double? amount,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Payment(
    id: id ?? this.id,
    farmerId: farmerId ?? this.farmerId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      farmerId: data.farmerId.present ? data.farmerId.value : this.farmerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, farmerId, amount, date, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.farmerId == this.farmerId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> farmerId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.farmerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int farmerId,
    required double amount,
    required DateTime date,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : farmerId = Value(farmerId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? farmerId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmerId != null) 'farmer_id': farmerId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? farmerId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (farmerId.present) {
      map['farmer_id'] = Variable<int>(farmerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FarmersTable farmers = $FarmersTable(this);
  late final $WorkTypesTable workTypes = $WorkTypesTable(this);
  late final $WorksTable works = $WorksTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    farmers,
    workTypes,
    works,
    payments,
  ];
}

typedef $$FarmersTableCreateCompanionBuilder =
    FarmersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FarmersTableUpdateCompanionBuilder =
    FarmersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FarmersTableReferences
    extends BaseReferences<_$AppDatabase, $FarmersTable, Farmer> {
  $$FarmersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorksTable, List<Work>> _worksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.works,
    aliasName: $_aliasNameGenerator(db.farmers.id, db.works.farmerId),
  );

  $$WorksTableProcessedTableManager get worksRefs {
    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.farmerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_worksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.farmers.id, db.payments.farmerId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.farmerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FarmersTableFilterComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> worksRefs(
    Expression<bool> Function($$WorksTableFilterComposer f) f,
  ) {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.farmerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.farmerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FarmersTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FarmersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> worksRefs<T extends Object>(
    Expression<T> Function($$WorksTableAnnotationComposer a) f,
  ) {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.farmerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.farmerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FarmersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FarmersTable,
          Farmer,
          $$FarmersTableFilterComposer,
          $$FarmersTableOrderingComposer,
          $$FarmersTableAnnotationComposer,
          $$FarmersTableCreateCompanionBuilder,
          $$FarmersTableUpdateCompanionBuilder,
          (Farmer, $$FarmersTableReferences),
          Farmer,
          PrefetchHooks Function({bool worksRefs, bool paymentsRefs})
        > {
  $$FarmersTableTableManager(_$AppDatabase db, $FarmersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FarmersCompanion(
                id: id,
                name: name,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FarmersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FarmersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worksRefs = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (worksRefs) db.works,
                if (paymentsRefs) db.payments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (worksRefs)
                    await $_getPrefetchedData<Farmer, $FarmersTable, Work>(
                      currentTable: table,
                      referencedTable: $$FarmersTableReferences._worksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$FarmersTableReferences(db, table, p0).worksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.farmerId == item.id),
                      typedResults: items,
                    ),
                  if (paymentsRefs)
                    await $_getPrefetchedData<Farmer, $FarmersTable, Payment>(
                      currentTable: table,
                      referencedTable: $$FarmersTableReferences
                          ._paymentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FarmersTableReferences(db, table, p0).paymentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.farmerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FarmersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FarmersTable,
      Farmer,
      $$FarmersTableFilterComposer,
      $$FarmersTableOrderingComposer,
      $$FarmersTableAnnotationComposer,
      $$FarmersTableCreateCompanionBuilder,
      $$FarmersTableUpdateCompanionBuilder,
      (Farmer, $$FarmersTableReferences),
      Farmer,
      PrefetchHooks Function({bool worksRefs, bool paymentsRefs})
    >;
typedef $$WorkTypesTableCreateCompanionBuilder =
    WorkTypesCompanion Function({
      Value<int> id,
      required String name,
      required double ratePerHour,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WorkTypesTableUpdateCompanionBuilder =
    WorkTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> ratePerHour,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$WorkTypesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkTypesTable, WorkType> {
  $$WorkTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorksTable, List<Work>> _worksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.works,
    aliasName: $_aliasNameGenerator(db.workTypes.id, db.works.workTypeId),
  );

  $$WorksTableProcessedTableManager get worksRefs {
    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.workTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_worksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkTypesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkTypesTable> {
  $$WorkTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> worksRefs(
    Expression<bool> Function($$WorksTableFilterComposer f) f,
  ) {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.workTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkTypesTable> {
  $$WorkTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkTypesTable> {
  $$WorkTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> worksRefs<T extends Object>(
    Expression<T> Function($$WorksTableAnnotationComposer a) f,
  ) {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.workTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkTypesTable,
          WorkType,
          $$WorkTypesTableFilterComposer,
          $$WorkTypesTableOrderingComposer,
          $$WorkTypesTableAnnotationComposer,
          $$WorkTypesTableCreateCompanionBuilder,
          $$WorkTypesTableUpdateCompanionBuilder,
          (WorkType, $$WorkTypesTableReferences),
          WorkType,
          PrefetchHooks Function({bool worksRefs})
        > {
  $$WorkTypesTableTableManager(_$AppDatabase db, $WorkTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> ratePerHour = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WorkTypesCompanion(
                id: id,
                name: name,
                ratePerHour: ratePerHour,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double ratePerHour,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WorkTypesCompanion.insert(
                id: id,
                name: name,
                ratePerHour: ratePerHour,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (worksRefs) db.works],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (worksRefs)
                    await $_getPrefetchedData<WorkType, $WorkTypesTable, Work>(
                      currentTable: table,
                      referencedTable: $$WorkTypesTableReferences
                          ._worksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkTypesTableReferences(db, table, p0).worksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workTypeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkTypesTable,
      WorkType,
      $$WorkTypesTableFilterComposer,
      $$WorkTypesTableOrderingComposer,
      $$WorkTypesTableAnnotationComposer,
      $$WorkTypesTableCreateCompanionBuilder,
      $$WorkTypesTableUpdateCompanionBuilder,
      (WorkType, $$WorkTypesTableReferences),
      WorkType,
      PrefetchHooks Function({bool worksRefs})
    >;
typedef $$WorksTableCreateCompanionBuilder =
    WorksCompanion Function({
      Value<int> id,
      required int farmerId,
      Value<int?> workTypeId,
      Value<String?> customWorkName,
      required DateTime startTime,
      required DateTime endTime,
      required int durationInMinutes,
      required double ratePerHour,
      required double totalAmount,
      required DateTime workDate,
      Value<String?> notes,
    });
typedef $$WorksTableUpdateCompanionBuilder =
    WorksCompanion Function({
      Value<int> id,
      Value<int> farmerId,
      Value<int?> workTypeId,
      Value<String?> customWorkName,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> durationInMinutes,
      Value<double> ratePerHour,
      Value<double> totalAmount,
      Value<DateTime> workDate,
      Value<String?> notes,
    });

final class $$WorksTableReferences
    extends BaseReferences<_$AppDatabase, $WorksTable, Work> {
  $$WorksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FarmersTable _farmerIdTable(_$AppDatabase db) => db.farmers
      .createAlias($_aliasNameGenerator(db.works.farmerId, db.farmers.id));

  $$FarmersTableProcessedTableManager get farmerId {
    final $_column = $_itemColumn<int>('farmer_id')!;

    final manager = $$FarmersTableTableManager(
      $_db,
      $_db.farmers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_farmerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkTypesTable _workTypeIdTable(_$AppDatabase db) => db.workTypes
      .createAlias($_aliasNameGenerator(db.works.workTypeId, db.workTypes.id));

  $$WorkTypesTableProcessedTableManager? get workTypeId {
    final $_column = $_itemColumn<int>('work_type_id');
    if ($_column == null) return null;
    final manager = $$WorkTypesTableTableManager(
      $_db,
      $_db.workTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorksTableFilterComposer extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customWorkName => $composableBuilder(
    column: $table.customWorkName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$FarmersTableFilterComposer get farmerId {
    final $$FarmersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableFilterComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkTypesTableFilterComposer get workTypeId {
    final $$WorkTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workTypeId,
      referencedTable: $db.workTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTypesTableFilterComposer(
            $db: $db,
            $table: $db.workTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customWorkName => $composableBuilder(
    column: $table.customWorkName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$FarmersTableOrderingComposer get farmerId {
    final $$FarmersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableOrderingComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkTypesTableOrderingComposer get workTypeId {
    final $$WorkTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workTypeId,
      referencedTable: $db.workTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTypesTableOrderingComposer(
            $db: $db,
            $table: $db.workTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customWorkName => $composableBuilder(
    column: $table.customWorkName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationInMinutes => $composableBuilder(
    column: $table.durationInMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ratePerHour => $composableBuilder(
    column: $table.ratePerHour,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get workDate =>
      $composableBuilder(column: $table.workDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$FarmersTableAnnotationComposer get farmerId {
    final $$FarmersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableAnnotationComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkTypesTableAnnotationComposer get workTypeId {
    final $$WorkTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workTypeId,
      referencedTable: $db.workTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.workTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorksTable,
          Work,
          $$WorksTableFilterComposer,
          $$WorksTableOrderingComposer,
          $$WorksTableAnnotationComposer,
          $$WorksTableCreateCompanionBuilder,
          $$WorksTableUpdateCompanionBuilder,
          (Work, $$WorksTableReferences),
          Work,
          PrefetchHooks Function({bool farmerId, bool workTypeId})
        > {
  $$WorksTableTableManager(_$AppDatabase db, $WorksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> farmerId = const Value.absent(),
                Value<int?> workTypeId = const Value.absent(),
                Value<String?> customWorkName = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> durationInMinutes = const Value.absent(),
                Value<double> ratePerHour = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> workDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorksCompanion(
                id: id,
                farmerId: farmerId,
                workTypeId: workTypeId,
                customWorkName: customWorkName,
                startTime: startTime,
                endTime: endTime,
                durationInMinutes: durationInMinutes,
                ratePerHour: ratePerHour,
                totalAmount: totalAmount,
                workDate: workDate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int farmerId,
                Value<int?> workTypeId = const Value.absent(),
                Value<String?> customWorkName = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                required int durationInMinutes,
                required double ratePerHour,
                required double totalAmount,
                required DateTime workDate,
                Value<String?> notes = const Value.absent(),
              }) => WorksCompanion.insert(
                id: id,
                farmerId: farmerId,
                workTypeId: workTypeId,
                customWorkName: customWorkName,
                startTime: startTime,
                endTime: endTime,
                durationInMinutes: durationInMinutes,
                ratePerHour: ratePerHour,
                totalAmount: totalAmount,
                workDate: workDate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$WorksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({farmerId = false, workTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (farmerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.farmerId,
                                referencedTable: $$WorksTableReferences
                                    ._farmerIdTable(db),
                                referencedColumn: $$WorksTableReferences
                                    ._farmerIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (workTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workTypeId,
                                referencedTable: $$WorksTableReferences
                                    ._workTypeIdTable(db),
                                referencedColumn: $$WorksTableReferences
                                    ._workTypeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorksTable,
      Work,
      $$WorksTableFilterComposer,
      $$WorksTableOrderingComposer,
      $$WorksTableAnnotationComposer,
      $$WorksTableCreateCompanionBuilder,
      $$WorksTableUpdateCompanionBuilder,
      (Work, $$WorksTableReferences),
      Work,
      PrefetchHooks Function({bool farmerId, bool workTypeId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int farmerId,
      required double amount,
      required DateTime date,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> farmerId,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FarmersTable _farmerIdTable(_$AppDatabase db) => db.farmers
      .createAlias($_aliasNameGenerator(db.payments.farmerId, db.farmers.id));

  $$FarmersTableProcessedTableManager get farmerId {
    final $_column = $_itemColumn<int>('farmer_id')!;

    final manager = $$FarmersTableTableManager(
      $_db,
      $_db.farmers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_farmerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FarmersTableFilterComposer get farmerId {
    final $$FarmersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableFilterComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FarmersTableOrderingComposer get farmerId {
    final $$FarmersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableOrderingComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FarmersTableAnnotationComposer get farmerId {
    final $$FarmersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.farmerId,
      referencedTable: $db.farmers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmersTableAnnotationComposer(
            $db: $db,
            $table: $db.farmers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool farmerId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> farmerId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                farmerId: farmerId,
                amount: amount,
                date: date,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int farmerId,
                required double amount,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                farmerId: farmerId,
                amount: amount,
                date: date,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({farmerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (farmerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.farmerId,
                                referencedTable: $$PaymentsTableReferences
                                    ._farmerIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._farmerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool farmerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmersTableTableManager get farmers =>
      $$FarmersTableTableManager(_db, _db.farmers);
  $$WorkTypesTableTableManager get workTypes =>
      $$WorkTypesTableTableManager(_db, _db.workTypes);
  $$WorksTableTableManager get works =>
      $$WorksTableTableManager(_db, _db.works);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
}
