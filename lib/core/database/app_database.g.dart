// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _monthlyBudgetDzdMeta = const VerificationMeta(
    'monthlyBudgetDzd',
  );
  @override
  late final GeneratedColumn<int> monthlyBudgetDzd = GeneratedColumn<int>(
    'monthly_budget_dzd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50000),
  );
  static const VerificationMeta _householdSizeMeta = const VerificationMeta(
    'householdSize',
  );
  @override
  late final GeneratedColumn<int> householdSize = GeneratedColumn<int>(
    'household_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstDayOfWeekMeta = const VerificationMeta(
    'firstDayOfWeek',
  );
  @override
  late final GeneratedColumn<int> firstDayOfWeek = GeneratedColumn<int>(
    'first_day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta(
    'currencySymbol',
  );
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DA'),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    monthlyBudgetDzd,
    householdSize,
    firstDayOfWeek,
    currencySymbol,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('monthly_budget_dzd')) {
      context.handle(
        _monthlyBudgetDzdMeta,
        monthlyBudgetDzd.isAcceptableOrUnknown(
          data['monthly_budget_dzd']!,
          _monthlyBudgetDzdMeta,
        ),
      );
    }
    if (data.containsKey('household_size')) {
      context.handle(
        _householdSizeMeta,
        householdSize.isAcceptableOrUnknown(
          data['household_size']!,
          _householdSizeMeta,
        ),
      );
    }
    if (data.containsKey('first_day_of_week')) {
      context.handle(
        _firstDayOfWeekMeta,
        firstDayOfWeek.isAcceptableOrUnknown(
          data['first_day_of_week']!,
          _firstDayOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(
          data['currency_symbol']!,
          _currencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      monthlyBudgetDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_budget_dzd'],
      )!,
      householdSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_size'],
      ),
      firstDayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_day_of_week'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
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
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String language;
  final int monthlyBudgetDzd;
  final int? householdSize;
  final int firstDayOfWeek;
  final String currencySymbol;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Profile({
    required this.id,
    required this.language,
    required this.monthlyBudgetDzd,
    this.householdSize,
    required this.firstDayOfWeek,
    required this.currencySymbol,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language'] = Variable<String>(language);
    map['monthly_budget_dzd'] = Variable<int>(monthlyBudgetDzd);
    if (!nullToAbsent || householdSize != null) {
      map['household_size'] = Variable<int>(householdSize);
    }
    map['first_day_of_week'] = Variable<int>(firstDayOfWeek);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      language: Value(language),
      monthlyBudgetDzd: Value(monthlyBudgetDzd),
      householdSize: householdSize == null && nullToAbsent
          ? const Value.absent()
          : Value(householdSize),
      firstDayOfWeek: Value(firstDayOfWeek),
      currencySymbol: Value(currencySymbol),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      monthlyBudgetDzd: serializer.fromJson<int>(json['monthlyBudgetDzd']),
      householdSize: serializer.fromJson<int?>(json['householdSize']),
      firstDayOfWeek: serializer.fromJson<int>(json['firstDayOfWeek']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'language': serializer.toJson<String>(language),
      'monthlyBudgetDzd': serializer.toJson<int>(monthlyBudgetDzd),
      'householdSize': serializer.toJson<int?>(householdSize),
      'firstDayOfWeek': serializer.toJson<int>(firstDayOfWeek),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Profile copyWith({
    String? id,
    String? language,
    int? monthlyBudgetDzd,
    Value<int?> householdSize = const Value.absent(),
    int? firstDayOfWeek,
    String? currencySymbol,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Profile(
    id: id ?? this.id,
    language: language ?? this.language,
    monthlyBudgetDzd: monthlyBudgetDzd ?? this.monthlyBudgetDzd,
    householdSize: householdSize.present
        ? householdSize.value
        : this.householdSize,
    firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      monthlyBudgetDzd: data.monthlyBudgetDzd.present
          ? data.monthlyBudgetDzd.value
          : this.monthlyBudgetDzd,
      householdSize: data.householdSize.present
          ? data.householdSize.value
          : this.householdSize,
      firstDayOfWeek: data.firstDayOfWeek.present
          ? data.firstDayOfWeek.value
          : this.firstDayOfWeek,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('monthlyBudgetDzd: $monthlyBudgetDzd, ')
          ..write('householdSize: $householdSize, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    monthlyBudgetDzd,
    householdSize,
    firstDayOfWeek,
    currencySymbol,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.language == this.language &&
          other.monthlyBudgetDzd == this.monthlyBudgetDzd &&
          other.householdSize == this.householdSize &&
          other.firstDayOfWeek == this.firstDayOfWeek &&
          other.currencySymbol == this.currencySymbol &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> language;
  final Value<int> monthlyBudgetDzd;
  final Value<int?> householdSize;
  final Value<int> firstDayOfWeek;
  final Value<String> currencySymbol;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.monthlyBudgetDzd = const Value.absent(),
    this.householdSize = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.language = const Value.absent(),
    this.monthlyBudgetDzd = const Value.absent(),
    this.householdSize = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? language,
    Expression<int>? monthlyBudgetDzd,
    Expression<int>? householdSize,
    Expression<int>? firstDayOfWeek,
    Expression<String>? currencySymbol,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (monthlyBudgetDzd != null) 'monthly_budget_dzd': monthlyBudgetDzd,
      if (householdSize != null) 'household_size': householdSize,
      if (firstDayOfWeek != null) 'first_day_of_week': firstDayOfWeek,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? language,
    Value<int>? monthlyBudgetDzd,
    Value<int?>? householdSize,
    Value<int>? firstDayOfWeek,
    Value<String>? currencySymbol,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      monthlyBudgetDzd: monthlyBudgetDzd ?? this.monthlyBudgetDzd,
      householdSize: householdSize ?? this.householdSize,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (monthlyBudgetDzd.present) {
      map['monthly_budget_dzd'] = Variable<int>(monthlyBudgetDzd.value);
    }
    if (householdSize.present) {
      map['household_size'] = Variable<int>(householdSize.value);
    }
    if (firstDayOfWeek.present) {
      map['first_day_of_week'] = Variable<int>(firstDayOfWeek.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('monthlyBudgetDzd: $monthlyBudgetDzd, ')
          ..write('householdSize: $householdSize, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyBudgetDzdMeta = const VerificationMeta(
    'monthlyBudgetDzd',
  );
  @override
  late final GeneratedColumn<int> monthlyBudgetDzd = GeneratedColumn<int>(
    'monthly_budget_dzd',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameEn,
    nameFr,
    nameAr,
    iconKey,
    colorHex,
    monthlyBudgetDzd,
    sortOrder,
    isSystem,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('monthly_budget_dzd')) {
      context.handle(
        _monthlyBudgetDzdMeta,
        monthlyBudgetDzd.isAcceptableOrUnknown(
          data['monthly_budget_dzd']!,
          _monthlyBudgetDzdMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      monthlyBudgetDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_budget_dzd'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String nameEn;
  final String nameFr;
  final String nameAr;
  final String iconKey;
  final String colorHex;
  final int? monthlyBudgetDzd;
  final int sortOrder;
  final bool isSystem;
  final DateTime? deletedAt;
  const Category({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.nameAr,
    required this.iconKey,
    required this.colorHex,
    this.monthlyBudgetDzd,
    required this.sortOrder,
    required this.isSystem,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_en'] = Variable<String>(nameEn);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_ar'] = Variable<String>(nameAr);
    map['icon_key'] = Variable<String>(iconKey);
    map['color_hex'] = Variable<String>(colorHex);
    if (!nullToAbsent || monthlyBudgetDzd != null) {
      map['monthly_budget_dzd'] = Variable<int>(monthlyBudgetDzd);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameEn: Value(nameEn),
      nameFr: Value(nameFr),
      nameAr: Value(nameAr),
      iconKey: Value(iconKey),
      colorHex: Value(colorHex),
      monthlyBudgetDzd: monthlyBudgetDzd == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyBudgetDzd),
      sortOrder: Value(sortOrder),
      isSystem: Value(isSystem),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      monthlyBudgetDzd: serializer.fromJson<int?>(json['monthlyBudgetDzd']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameAr': serializer.toJson<String>(nameAr),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorHex': serializer.toJson<String>(colorHex),
      'monthlyBudgetDzd': serializer.toJson<int?>(monthlyBudgetDzd),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isSystem': serializer.toJson<bool>(isSystem),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Category copyWith({
    String? id,
    String? nameEn,
    String? nameFr,
    String? nameAr,
    String? iconKey,
    String? colorHex,
    Value<int?> monthlyBudgetDzd = const Value.absent(),
    int? sortOrder,
    bool? isSystem,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    nameEn: nameEn ?? this.nameEn,
    nameFr: nameFr ?? this.nameFr,
    nameAr: nameAr ?? this.nameAr,
    iconKey: iconKey ?? this.iconKey,
    colorHex: colorHex ?? this.colorHex,
    monthlyBudgetDzd: monthlyBudgetDzd.present
        ? monthlyBudgetDzd.value
        : this.monthlyBudgetDzd,
    sortOrder: sortOrder ?? this.sortOrder,
    isSystem: isSystem ?? this.isSystem,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      monthlyBudgetDzd: data.monthlyBudgetDzd.present
          ? data.monthlyBudgetDzd.value
          : this.monthlyBudgetDzd,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyBudgetDzd: $monthlyBudgetDzd, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameEn,
    nameFr,
    nameAr,
    iconKey,
    colorHex,
    monthlyBudgetDzd,
    sortOrder,
    isSystem,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nameEn == this.nameEn &&
          other.nameFr == this.nameFr &&
          other.nameAr == this.nameAr &&
          other.iconKey == this.iconKey &&
          other.colorHex == this.colorHex &&
          other.monthlyBudgetDzd == this.monthlyBudgetDzd &&
          other.sortOrder == this.sortOrder &&
          other.isSystem == this.isSystem &&
          other.deletedAt == this.deletedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> nameEn;
  final Value<String> nameFr;
  final Value<String> nameAr;
  final Value<String> iconKey;
  final Value<String> colorHex;
  final Value<int?> monthlyBudgetDzd;
  final Value<int> sortOrder;
  final Value<bool> isSystem;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.monthlyBudgetDzd = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String nameEn,
    required String nameFr,
    required String nameAr,
    required String iconKey,
    required String colorHex,
    this.monthlyBudgetDzd = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameEn = Value(nameEn),
       nameFr = Value(nameFr),
       nameAr = Value(nameAr),
       iconKey = Value(iconKey),
       colorHex = Value(colorHex);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? nameEn,
    Expression<String>? nameFr,
    Expression<String>? nameAr,
    Expression<String>? iconKey,
    Expression<String>? colorHex,
    Expression<int>? monthlyBudgetDzd,
    Expression<int>? sortOrder,
    Expression<bool>? isSystem,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameEn != null) 'name_en': nameEn,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameAr != null) 'name_ar': nameAr,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorHex != null) 'color_hex': colorHex,
      if (monthlyBudgetDzd != null) 'monthly_budget_dzd': monthlyBudgetDzd,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isSystem != null) 'is_system': isSystem,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameEn,
    Value<String>? nameFr,
    Value<String>? nameAr,
    Value<String>? iconKey,
    Value<String>? colorHex,
    Value<int?>? monthlyBudgetDzd,
    Value<int>? sortOrder,
    Value<bool>? isSystem,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameFr: nameFr ?? this.nameFr,
      nameAr: nameAr ?? this.nameAr,
      iconKey: iconKey ?? this.iconKey,
      colorHex: colorHex ?? this.colorHex,
      monthlyBudgetDzd: monthlyBudgetDzd ?? this.monthlyBudgetDzd,
      sortOrder: sortOrder ?? this.sortOrder,
      isSystem: isSystem ?? this.isSystem,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (monthlyBudgetDzd.present) {
      map['monthly_budget_dzd'] = Variable<int>(monthlyBudgetDzd.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyBudgetDzd: $monthlyBudgetDzd, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeTypeMeta = const VerificationMeta(
    'storeType',
  );
  @override
  late final GeneratedColumn<String> storeType = GeneratedColumn<String>(
    'store_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    area,
    storeType,
    rating,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Store> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('store_type')) {
      context.handle(
        _storeTypeMeta,
        storeType.isAcceptableOrUnknown(data['store_type']!, _storeTypeMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Store(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      storeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_type'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final String id;
  final String name;
  final String? area;
  final String? storeType;
  final int? rating;
  final DateTime? deletedAt;
  const Store({
    required this.id,
    required this.name,
    this.area,
    this.storeType,
    this.rating,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || storeType != null) {
      map['store_type'] = Variable<String>(storeType);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      name: Value(name),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      storeType: storeType == null && nullToAbsent
          ? const Value.absent()
          : Value(storeType),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Store.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      area: serializer.fromJson<String?>(json['area']),
      storeType: serializer.fromJson<String?>(json['storeType']),
      rating: serializer.fromJson<int?>(json['rating']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'area': serializer.toJson<String?>(area),
      'storeType': serializer.toJson<String?>(storeType),
      'rating': serializer.toJson<int?>(rating),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Store copyWith({
    String? id,
    String? name,
    Value<String?> area = const Value.absent(),
    Value<String?> storeType = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Store(
    id: id ?? this.id,
    name: name ?? this.name,
    area: area.present ? area.value : this.area,
    storeType: storeType.present ? storeType.value : this.storeType,
    rating: rating.present ? rating.value : this.rating,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Store copyWithCompanion(StoresCompanion data) {
    return Store(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      area: data.area.present ? data.area.value : this.area,
      storeType: data.storeType.present ? data.storeType.value : this.storeType,
      rating: data.rating.present ? data.rating.value : this.rating,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('area: $area, ')
          ..write('storeType: $storeType, ')
          ..write('rating: $rating, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, area, storeType, rating, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          other.id == this.id &&
          other.name == this.name &&
          other.area == this.area &&
          other.storeType == this.storeType &&
          other.rating == this.rating &&
          other.deletedAt == this.deletedAt);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> area;
  final Value<String?> storeType;
  final Value<int?> rating;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.area = const Value.absent(),
    this.storeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required String name,
    this.area = const Value.absent(),
    this.storeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Store> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? area,
    Expression<String>? storeType,
    Expression<int>? rating,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (area != null) 'area': area,
      if (storeType != null) 'store_type': storeType,
      if (rating != null) 'rating': rating,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? area,
    Value<String?>? storeType,
    Value<int?>? rating,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      storeType: storeType ?? this.storeType,
      rating: rating ?? this.rating,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (storeType.present) {
      map['store_type'] = Variable<String>(storeType.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('area: $area, ')
          ..write('storeType: $storeType, ')
          ..write('rating: $rating, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredUnitIdMeta = const VerificationMeta(
    'preferredUnitId',
  );
  @override
  late final GeneratedColumn<String> preferredUnitId = GeneratedColumn<String>(
    'preferred_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _packageQuantityMeta = const VerificationMeta(
    'packageQuantity',
  );
  @override
  late final GeneratedColumn<double> packageQuantity = GeneratedColumn<double>(
    'package_quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packageUnitIdMeta = const VerificationMeta(
    'packageUnitId',
  );
  @override
  late final GeneratedColumn<String> packageUnitId = GeneratedColumn<String>(
    'package_unit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPriceDzdMeta = const VerificationMeta(
    'lastPriceDzd',
  );
  @override
  late final GeneratedColumn<int> lastPriceDzd = GeneratedColumn<int>(
    'last_price_dzd',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    normalizedName,
    brand,
    variant,
    barcode,
    categoryId,
    preferredUnitId,
    packageQuantity,
    packageUnitId,
    lastPriceDzd,
    isArchived,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('preferred_unit_id')) {
      context.handle(
        _preferredUnitIdMeta,
        preferredUnitId.isAcceptableOrUnknown(
          data['preferred_unit_id']!,
          _preferredUnitIdMeta,
        ),
      );
    }
    if (data.containsKey('package_quantity')) {
      context.handle(
        _packageQuantityMeta,
        packageQuantity.isAcceptableOrUnknown(
          data['package_quantity']!,
          _packageQuantityMeta,
        ),
      );
    }
    if (data.containsKey('package_unit_id')) {
      context.handle(
        _packageUnitIdMeta,
        packageUnitId.isAcceptableOrUnknown(
          data['package_unit_id']!,
          _packageUnitIdMeta,
        ),
      );
    }
    if (data.containsKey('last_price_dzd')) {
      context.handle(
        _lastPriceDzdMeta,
        lastPriceDzd.isAcceptableOrUnknown(
          data['last_price_dzd']!,
          _lastPriceDzdMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      preferredUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_unit_id'],
      )!,
      packageQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}package_quantity'],
      ),
      packageUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_unit_id'],
      ),
      lastPriceDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_price_dzd'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String normalizedName;
  final String? brand;
  final String? variant;
  final String? barcode;
  final String? categoryId;
  final String preferredUnitId;
  final double? packageQuantity;
  final String? packageUnitId;
  final int? lastPriceDzd;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Product({
    required this.id,
    required this.name,
    required this.normalizedName,
    this.brand,
    this.variant,
    this.barcode,
    this.categoryId,
    required this.preferredUnitId,
    this.packageQuantity,
    this.packageUnitId,
    this.lastPriceDzd,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['preferred_unit_id'] = Variable<String>(preferredUnitId);
    if (!nullToAbsent || packageQuantity != null) {
      map['package_quantity'] = Variable<double>(packageQuantity);
    }
    if (!nullToAbsent || packageUnitId != null) {
      map['package_unit_id'] = Variable<String>(packageUnitId);
    }
    if (!nullToAbsent || lastPriceDzd != null) {
      map['last_price_dzd'] = Variable<int>(lastPriceDzd);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      preferredUnitId: Value(preferredUnitId),
      packageQuantity: packageQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(packageQuantity),
      packageUnitId: packageUnitId == null && nullToAbsent
          ? const Value.absent()
          : Value(packageUnitId),
      lastPriceDzd: lastPriceDzd == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceDzd),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      brand: serializer.fromJson<String?>(json['brand']),
      variant: serializer.fromJson<String?>(json['variant']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      preferredUnitId: serializer.fromJson<String>(json['preferredUnitId']),
      packageQuantity: serializer.fromJson<double?>(json['packageQuantity']),
      packageUnitId: serializer.fromJson<String?>(json['packageUnitId']),
      lastPriceDzd: serializer.fromJson<int?>(json['lastPriceDzd']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'brand': serializer.toJson<String?>(brand),
      'variant': serializer.toJson<String?>(variant),
      'barcode': serializer.toJson<String?>(barcode),
      'categoryId': serializer.toJson<String?>(categoryId),
      'preferredUnitId': serializer.toJson<String>(preferredUnitId),
      'packageQuantity': serializer.toJson<double?>(packageQuantity),
      'packageUnitId': serializer.toJson<String?>(packageUnitId),
      'lastPriceDzd': serializer.toJson<int?>(lastPriceDzd),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? normalizedName,
    Value<String?> brand = const Value.absent(),
    Value<String?> variant = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? preferredUnitId,
    Value<double?> packageQuantity = const Value.absent(),
    Value<String?> packageUnitId = const Value.absent(),
    Value<int?> lastPriceDzd = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    brand: brand.present ? brand.value : this.brand,
    variant: variant.present ? variant.value : this.variant,
    barcode: barcode.present ? barcode.value : this.barcode,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    preferredUnitId: preferredUnitId ?? this.preferredUnitId,
    packageQuantity: packageQuantity.present
        ? packageQuantity.value
        : this.packageQuantity,
    packageUnitId: packageUnitId.present
        ? packageUnitId.value
        : this.packageUnitId,
    lastPriceDzd: lastPriceDzd.present ? lastPriceDzd.value : this.lastPriceDzd,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      brand: data.brand.present ? data.brand.value : this.brand,
      variant: data.variant.present ? data.variant.value : this.variant,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      preferredUnitId: data.preferredUnitId.present
          ? data.preferredUnitId.value
          : this.preferredUnitId,
      packageQuantity: data.packageQuantity.present
          ? data.packageQuantity.value
          : this.packageQuantity,
      packageUnitId: data.packageUnitId.present
          ? data.packageUnitId.value
          : this.packageUnitId,
      lastPriceDzd: data.lastPriceDzd.present
          ? data.lastPriceDzd.value
          : this.lastPriceDzd,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('preferredUnitId: $preferredUnitId, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnitId: $packageUnitId, ')
          ..write('lastPriceDzd: $lastPriceDzd, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    normalizedName,
    brand,
    variant,
    barcode,
    categoryId,
    preferredUnitId,
    packageQuantity,
    packageUnitId,
    lastPriceDzd,
    isArchived,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.brand == this.brand &&
          other.variant == this.variant &&
          other.barcode == this.barcode &&
          other.categoryId == this.categoryId &&
          other.preferredUnitId == this.preferredUnitId &&
          other.packageQuantity == this.packageQuantity &&
          other.packageUnitId == this.packageUnitId &&
          other.lastPriceDzd == this.lastPriceDzd &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<String?> brand;
  final Value<String?> variant;
  final Value<String?> barcode;
  final Value<String?> categoryId;
  final Value<String> preferredUnitId;
  final Value<double?> packageQuantity;
  final Value<String?> packageUnitId;
  final Value<int?> lastPriceDzd;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.brand = const Value.absent(),
    this.variant = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.preferredUnitId = const Value.absent(),
    this.packageQuantity = const Value.absent(),
    this.packageUnitId = const Value.absent(),
    this.lastPriceDzd = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String normalizedName,
    this.brand = const Value.absent(),
    this.variant = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.preferredUnitId = const Value.absent(),
    this.packageQuantity = const Value.absent(),
    this.packageUnitId = const Value.absent(),
    this.lastPriceDzd = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       normalizedName = Value(normalizedName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<String>? brand,
    Expression<String>? variant,
    Expression<String>? barcode,
    Expression<String>? categoryId,
    Expression<String>? preferredUnitId,
    Expression<double>? packageQuantity,
    Expression<String>? packageUnitId,
    Expression<int>? lastPriceDzd,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (brand != null) 'brand': brand,
      if (variant != null) 'variant': variant,
      if (barcode != null) 'barcode': barcode,
      if (categoryId != null) 'category_id': categoryId,
      if (preferredUnitId != null) 'preferred_unit_id': preferredUnitId,
      if (packageQuantity != null) 'package_quantity': packageQuantity,
      if (packageUnitId != null) 'package_unit_id': packageUnitId,
      if (lastPriceDzd != null) 'last_price_dzd': lastPriceDzd,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<String?>? brand,
    Value<String?>? variant,
    Value<String?>? barcode,
    Value<String?>? categoryId,
    Value<String>? preferredUnitId,
    Value<double?>? packageQuantity,
    Value<String?>? packageUnitId,
    Value<int?>? lastPriceDzd,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      brand: brand ?? this.brand,
      variant: variant ?? this.variant,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      preferredUnitId: preferredUnitId ?? this.preferredUnitId,
      packageQuantity: packageQuantity ?? this.packageQuantity,
      packageUnitId: packageUnitId ?? this.packageUnitId,
      lastPriceDzd: lastPriceDzd ?? this.lastPriceDzd,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (preferredUnitId.present) {
      map['preferred_unit_id'] = Variable<String>(preferredUnitId.value);
    }
    if (packageQuantity.present) {
      map['package_quantity'] = Variable<double>(packageQuantity.value);
    }
    if (packageUnitId.present) {
      map['package_unit_id'] = Variable<String>(packageUnitId.value);
    }
    if (lastPriceDzd.present) {
      map['last_price_dzd'] = Variable<int>(lastPriceDzd.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('preferredUnitId: $preferredUnitId, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnitId: $packageUnitId, ')
          ..write('lastPriceDzd: $lastPriceDzd, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductAliasesTable extends ProductAliases
    with TableInfo<$ProductAliasesTable, ProductAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedAliasMeta = const VerificationMeta(
    'normalizedAlias',
  );
  @override
  late final GeneratedColumn<String> normalizedAlias = GeneratedColumn<String>(
    'normalized_alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    alias,
    normalizedAlias,
    languageCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductAliase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('normalized_alias')) {
      context.handle(
        _normalizedAliasMeta,
        normalizedAlias.isAcceptableOrUnknown(
          data['normalized_alias']!,
          _normalizedAliasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedAliasMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductAliase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductAliase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      normalizedAlias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_alias'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      ),
    );
  }

  @override
  $ProductAliasesTable createAlias(String alias) {
    return $ProductAliasesTable(attachedDatabase, alias);
  }
}

class ProductAliase extends DataClass implements Insertable<ProductAliase> {
  final String id;
  final String productId;
  final String alias;
  final String normalizedAlias;
  final String? languageCode;
  const ProductAliase({
    required this.id,
    required this.productId,
    required this.alias,
    required this.normalizedAlias,
    this.languageCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['alias'] = Variable<String>(alias);
    map['normalized_alias'] = Variable<String>(normalizedAlias);
    if (!nullToAbsent || languageCode != null) {
      map['language_code'] = Variable<String>(languageCode);
    }
    return map;
  }

  ProductAliasesCompanion toCompanion(bool nullToAbsent) {
    return ProductAliasesCompanion(
      id: Value(id),
      productId: Value(productId),
      alias: Value(alias),
      normalizedAlias: Value(normalizedAlias),
      languageCode: languageCode == null && nullToAbsent
          ? const Value.absent()
          : Value(languageCode),
    );
  }

  factory ProductAliase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductAliase(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      alias: serializer.fromJson<String>(json['alias']),
      normalizedAlias: serializer.fromJson<String>(json['normalizedAlias']),
      languageCode: serializer.fromJson<String?>(json['languageCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'alias': serializer.toJson<String>(alias),
      'normalizedAlias': serializer.toJson<String>(normalizedAlias),
      'languageCode': serializer.toJson<String?>(languageCode),
    };
  }

  ProductAliase copyWith({
    String? id,
    String? productId,
    String? alias,
    String? normalizedAlias,
    Value<String?> languageCode = const Value.absent(),
  }) => ProductAliase(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    alias: alias ?? this.alias,
    normalizedAlias: normalizedAlias ?? this.normalizedAlias,
    languageCode: languageCode.present ? languageCode.value : this.languageCode,
  );
  ProductAliase copyWithCompanion(ProductAliasesCompanion data) {
    return ProductAliase(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      alias: data.alias.present ? data.alias.value : this.alias,
      normalizedAlias: data.normalizedAlias.present
          ? data.normalizedAlias.value
          : this.normalizedAlias,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductAliase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('alias: $alias, ')
          ..write('normalizedAlias: $normalizedAlias, ')
          ..write('languageCode: $languageCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, alias, normalizedAlias, languageCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductAliase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.alias == this.alias &&
          other.normalizedAlias == this.normalizedAlias &&
          other.languageCode == this.languageCode);
}

class ProductAliasesCompanion extends UpdateCompanion<ProductAliase> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> alias;
  final Value<String> normalizedAlias;
  final Value<String?> languageCode;
  final Value<int> rowid;
  const ProductAliasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.alias = const Value.absent(),
    this.normalizedAlias = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductAliasesCompanion.insert({
    required String id,
    required String productId,
    required String alias,
    required String normalizedAlias,
    this.languageCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       alias = Value(alias),
       normalizedAlias = Value(normalizedAlias);
  static Insertable<ProductAliase> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? alias,
    Expression<String>? normalizedAlias,
    Expression<String>? languageCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (alias != null) 'alias': alias,
      if (normalizedAlias != null) 'normalized_alias': normalizedAlias,
      if (languageCode != null) 'language_code': languageCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductAliasesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? alias,
    Value<String>? normalizedAlias,
    Value<String?>? languageCode,
    Value<int>? rowid,
  }) {
    return ProductAliasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      alias: alias ?? this.alias,
      normalizedAlias: normalizedAlias ?? this.normalizedAlias,
      languageCode: languageCode ?? this.languageCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (normalizedAlias.present) {
      map['normalized_alias'] = Variable<String>(normalizedAlias.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductAliasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('alias: $alias, ')
          ..write('normalizedAlias: $normalizedAlias, ')
          ..write('languageCode: $languageCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductConversionsTable extends ProductConversions
    with TableInfo<$ProductConversionsTable, ProductConversion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductConversionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromUnitIdMeta = const VerificationMeta(
    'fromUnitId',
  );
  @override
  late final GeneratedColumn<String> fromUnitId = GeneratedColumn<String>(
    'from_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toUnitIdMeta = const VerificationMeta(
    'toUnitId',
  );
  @override
  late final GeneratedColumn<String> toUnitId = GeneratedColumn<String>(
    'to_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<double> factor = GeneratedColumn<double>(
    'factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    fromUnitId,
    toUnitId,
    factor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_conversions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductConversion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('from_unit_id')) {
      context.handle(
        _fromUnitIdMeta,
        fromUnitId.isAcceptableOrUnknown(
          data['from_unit_id']!,
          _fromUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromUnitIdMeta);
    }
    if (data.containsKey('to_unit_id')) {
      context.handle(
        _toUnitIdMeta,
        toUnitId.isAcceptableOrUnknown(data['to_unit_id']!, _toUnitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toUnitIdMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(
        _factorMeta,
        factor.isAcceptableOrUnknown(data['factor']!, _factorMeta),
      );
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductConversion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductConversion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      fromUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_unit_id'],
      )!,
      toUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_unit_id'],
      )!,
      factor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}factor'],
      )!,
    );
  }

  @override
  $ProductConversionsTable createAlias(String alias) {
    return $ProductConversionsTable(attachedDatabase, alias);
  }
}

class ProductConversion extends DataClass
    implements Insertable<ProductConversion> {
  final String id;
  final String productId;
  final String fromUnitId;
  final String toUnitId;
  final double factor;
  const ProductConversion({
    required this.id,
    required this.productId,
    required this.fromUnitId,
    required this.toUnitId,
    required this.factor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['from_unit_id'] = Variable<String>(fromUnitId);
    map['to_unit_id'] = Variable<String>(toUnitId);
    map['factor'] = Variable<double>(factor);
    return map;
  }

  ProductConversionsCompanion toCompanion(bool nullToAbsent) {
    return ProductConversionsCompanion(
      id: Value(id),
      productId: Value(productId),
      fromUnitId: Value(fromUnitId),
      toUnitId: Value(toUnitId),
      factor: Value(factor),
    );
  }

  factory ProductConversion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductConversion(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      fromUnitId: serializer.fromJson<String>(json['fromUnitId']),
      toUnitId: serializer.fromJson<String>(json['toUnitId']),
      factor: serializer.fromJson<double>(json['factor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'fromUnitId': serializer.toJson<String>(fromUnitId),
      'toUnitId': serializer.toJson<String>(toUnitId),
      'factor': serializer.toJson<double>(factor),
    };
  }

  ProductConversion copyWith({
    String? id,
    String? productId,
    String? fromUnitId,
    String? toUnitId,
    double? factor,
  }) => ProductConversion(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    fromUnitId: fromUnitId ?? this.fromUnitId,
    toUnitId: toUnitId ?? this.toUnitId,
    factor: factor ?? this.factor,
  );
  ProductConversion copyWithCompanion(ProductConversionsCompanion data) {
    return ProductConversion(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      fromUnitId: data.fromUnitId.present
          ? data.fromUnitId.value
          : this.fromUnitId,
      toUnitId: data.toUnitId.present ? data.toUnitId.value : this.toUnitId,
      factor: data.factor.present ? data.factor.value : this.factor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductConversion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('factor: $factor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, fromUnitId, toUnitId, factor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductConversion &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.fromUnitId == this.fromUnitId &&
          other.toUnitId == this.toUnitId &&
          other.factor == this.factor);
}

class ProductConversionsCompanion extends UpdateCompanion<ProductConversion> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> fromUnitId;
  final Value<String> toUnitId;
  final Value<double> factor;
  final Value<int> rowid;
  const ProductConversionsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.fromUnitId = const Value.absent(),
    this.toUnitId = const Value.absent(),
    this.factor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductConversionsCompanion.insert({
    required String id,
    required String productId,
    required String fromUnitId,
    required String toUnitId,
    required double factor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       fromUnitId = Value(fromUnitId),
       toUnitId = Value(toUnitId),
       factor = Value(factor);
  static Insertable<ProductConversion> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? fromUnitId,
    Expression<String>? toUnitId,
    Expression<double>? factor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (fromUnitId != null) 'from_unit_id': fromUnitId,
      if (toUnitId != null) 'to_unit_id': toUnitId,
      if (factor != null) 'factor': factor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductConversionsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? fromUnitId,
    Value<String>? toUnitId,
    Value<double>? factor,
    Value<int>? rowid,
  }) {
    return ProductConversionsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      fromUnitId: fromUnitId ?? this.fromUnitId,
      toUnitId: toUnitId ?? this.toUnitId,
      factor: factor ?? this.factor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (fromUnitId.present) {
      map['from_unit_id'] = Variable<String>(fromUnitId.value);
    }
    if (toUnitId.present) {
      map['to_unit_id'] = Variable<String>(toUnitId.value);
    }
    if (factor.present) {
      map['factor'] = Variable<double>(factor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductConversionsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('factor: $factor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceDzdMeta = const VerificationMeta(
    'priceDzd',
  );
  @override
  late final GeneratedColumn<int> priceDzd = GeneratedColumn<int>(
    'price_dzd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnitPriceMeta = const VerificationMeta(
    'isUnitPrice',
  );
  @override
  late final GeneratedColumn<bool> isUnitPrice = GeneratedColumn<bool>(
    'is_unit_price',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unit_price" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalDzdMeta = const VerificationMeta(
    'totalDzd',
  );
  @override
  late final GeneratedColumn<int> totalDzd = GeneratedColumn<int>(
    'total_dzd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedBaseQuantityMeta =
      const VerificationMeta('normalizedBaseQuantity');
  @override
  late final GeneratedColumn<double> normalizedBaseQuantity =
      GeneratedColumn<double>(
        'normalized_base_quantity',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _normalizedDzdPerBaseUnitMeta =
      const VerificationMeta('normalizedDzdPerBaseUnit');
  @override
  late final GeneratedColumn<double> normalizedDzdPerBaseUnit =
      GeneratedColumn<double>(
        'normalized_dzd_per_base_unit',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    storeId,
    tripId,
    quantity,
    unitId,
    priceDzd,
    isUnitPrice,
    totalDzd,
    normalizedBaseQuantity,
    normalizedDzdPerBaseUnit,
    purchasedAt,
    localDate,
    note,
    expiryDate,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('price_dzd')) {
      context.handle(
        _priceDzdMeta,
        priceDzd.isAcceptableOrUnknown(data['price_dzd']!, _priceDzdMeta),
      );
    } else if (isInserting) {
      context.missing(_priceDzdMeta);
    }
    if (data.containsKey('is_unit_price')) {
      context.handle(
        _isUnitPriceMeta,
        isUnitPrice.isAcceptableOrUnknown(
          data['is_unit_price']!,
          _isUnitPriceMeta,
        ),
      );
    }
    if (data.containsKey('total_dzd')) {
      context.handle(
        _totalDzdMeta,
        totalDzd.isAcceptableOrUnknown(data['total_dzd']!, _totalDzdMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDzdMeta);
    }
    if (data.containsKey('normalized_base_quantity')) {
      context.handle(
        _normalizedBaseQuantityMeta,
        normalizedBaseQuantity.isAcceptableOrUnknown(
          data['normalized_base_quantity']!,
          _normalizedBaseQuantityMeta,
        ),
      );
    }
    if (data.containsKey('normalized_dzd_per_base_unit')) {
      context.handle(
        _normalizedDzdPerBaseUnitMeta,
        normalizedDzdPerBaseUnit.isAcceptableOrUnknown(
          data['normalized_dzd_per_base_unit']!,
          _normalizedDzdPerBaseUnitMeta,
        ),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      ),
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      priceDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_dzd'],
      )!,
      isUnitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unit_price'],
      )!,
      totalDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_dzd'],
      )!,
      normalizedBaseQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normalized_base_quantity'],
      ),
      normalizedDzdPerBaseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normalized_dzd_per_base_unit'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final String id;
  final String productId;
  final String? storeId;
  final String? tripId;
  final double quantity;
  final String unitId;
  final int priceDzd;
  final bool isUnitPrice;
  final int totalDzd;
  final double? normalizedBaseQuantity;
  final double? normalizedDzdPerBaseUnit;
  final DateTime purchasedAt;
  final String localDate;
  final String? note;
  final DateTime? expiryDate;
  final DateTime? deletedAt;
  const Purchase({
    required this.id,
    required this.productId,
    this.storeId,
    this.tripId,
    required this.quantity,
    required this.unitId,
    required this.priceDzd,
    required this.isUnitPrice,
    required this.totalDzd,
    this.normalizedBaseQuantity,
    this.normalizedDzdPerBaseUnit,
    required this.purchasedAt,
    required this.localDate,
    this.note,
    this.expiryDate,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<String>(storeId);
    }
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<String>(tripId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit_id'] = Variable<String>(unitId);
    map['price_dzd'] = Variable<int>(priceDzd);
    map['is_unit_price'] = Variable<bool>(isUnitPrice);
    map['total_dzd'] = Variable<int>(totalDzd);
    if (!nullToAbsent || normalizedBaseQuantity != null) {
      map['normalized_base_quantity'] = Variable<double>(
        normalizedBaseQuantity,
      );
    }
    if (!nullToAbsent || normalizedDzdPerBaseUnit != null) {
      map['normalized_dzd_per_base_unit'] = Variable<double>(
        normalizedDzdPerBaseUnit,
      );
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      productId: Value(productId),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      tripId: tripId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripId),
      quantity: Value(quantity),
      unitId: Value(unitId),
      priceDzd: Value(priceDzd),
      isUnitPrice: Value(isUnitPrice),
      totalDzd: Value(totalDzd),
      normalizedBaseQuantity: normalizedBaseQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedBaseQuantity),
      normalizedDzdPerBaseUnit: normalizedDzdPerBaseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedDzdPerBaseUnit),
      purchasedAt: Value(purchasedAt),
      localDate: Value(localDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      storeId: serializer.fromJson<String?>(json['storeId']),
      tripId: serializer.fromJson<String?>(json['tripId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitId: serializer.fromJson<String>(json['unitId']),
      priceDzd: serializer.fromJson<int>(json['priceDzd']),
      isUnitPrice: serializer.fromJson<bool>(json['isUnitPrice']),
      totalDzd: serializer.fromJson<int>(json['totalDzd']),
      normalizedBaseQuantity: serializer.fromJson<double?>(
        json['normalizedBaseQuantity'],
      ),
      normalizedDzdPerBaseUnit: serializer.fromJson<double?>(
        json['normalizedDzdPerBaseUnit'],
      ),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
      note: serializer.fromJson<String?>(json['note']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'storeId': serializer.toJson<String?>(storeId),
      'tripId': serializer.toJson<String?>(tripId),
      'quantity': serializer.toJson<double>(quantity),
      'unitId': serializer.toJson<String>(unitId),
      'priceDzd': serializer.toJson<int>(priceDzd),
      'isUnitPrice': serializer.toJson<bool>(isUnitPrice),
      'totalDzd': serializer.toJson<int>(totalDzd),
      'normalizedBaseQuantity': serializer.toJson<double?>(
        normalizedBaseQuantity,
      ),
      'normalizedDzdPerBaseUnit': serializer.toJson<double?>(
        normalizedDzdPerBaseUnit,
      ),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'localDate': serializer.toJson<String>(localDate),
      'note': serializer.toJson<String?>(note),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Purchase copyWith({
    String? id,
    String? productId,
    Value<String?> storeId = const Value.absent(),
    Value<String?> tripId = const Value.absent(),
    double? quantity,
    String? unitId,
    int? priceDzd,
    bool? isUnitPrice,
    int? totalDzd,
    Value<double?> normalizedBaseQuantity = const Value.absent(),
    Value<double?> normalizedDzdPerBaseUnit = const Value.absent(),
    DateTime? purchasedAt,
    String? localDate,
    Value<String?> note = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Purchase(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    storeId: storeId.present ? storeId.value : this.storeId,
    tripId: tripId.present ? tripId.value : this.tripId,
    quantity: quantity ?? this.quantity,
    unitId: unitId ?? this.unitId,
    priceDzd: priceDzd ?? this.priceDzd,
    isUnitPrice: isUnitPrice ?? this.isUnitPrice,
    totalDzd: totalDzd ?? this.totalDzd,
    normalizedBaseQuantity: normalizedBaseQuantity.present
        ? normalizedBaseQuantity.value
        : this.normalizedBaseQuantity,
    normalizedDzdPerBaseUnit: normalizedDzdPerBaseUnit.present
        ? normalizedDzdPerBaseUnit.value
        : this.normalizedDzdPerBaseUnit,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    localDate: localDate ?? this.localDate,
    note: note.present ? note.value : this.note,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      priceDzd: data.priceDzd.present ? data.priceDzd.value : this.priceDzd,
      isUnitPrice: data.isUnitPrice.present
          ? data.isUnitPrice.value
          : this.isUnitPrice,
      totalDzd: data.totalDzd.present ? data.totalDzd.value : this.totalDzd,
      normalizedBaseQuantity: data.normalizedBaseQuantity.present
          ? data.normalizedBaseQuantity.value
          : this.normalizedBaseQuantity,
      normalizedDzdPerBaseUnit: data.normalizedDzdPerBaseUnit.present
          ? data.normalizedDzdPerBaseUnit.value
          : this.normalizedDzdPerBaseUnit,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      note: data.note.present ? data.note.value : this.note,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('storeId: $storeId, ')
          ..write('tripId: $tripId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('priceDzd: $priceDzd, ')
          ..write('isUnitPrice: $isUnitPrice, ')
          ..write('totalDzd: $totalDzd, ')
          ..write('normalizedBaseQuantity: $normalizedBaseQuantity, ')
          ..write('normalizedDzdPerBaseUnit: $normalizedDzdPerBaseUnit, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('localDate: $localDate, ')
          ..write('note: $note, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    storeId,
    tripId,
    quantity,
    unitId,
    priceDzd,
    isUnitPrice,
    totalDzd,
    normalizedBaseQuantity,
    normalizedDzdPerBaseUnit,
    purchasedAt,
    localDate,
    note,
    expiryDate,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.storeId == this.storeId &&
          other.tripId == this.tripId &&
          other.quantity == this.quantity &&
          other.unitId == this.unitId &&
          other.priceDzd == this.priceDzd &&
          other.isUnitPrice == this.isUnitPrice &&
          other.totalDzd == this.totalDzd &&
          other.normalizedBaseQuantity == this.normalizedBaseQuantity &&
          other.normalizedDzdPerBaseUnit == this.normalizedDzdPerBaseUnit &&
          other.purchasedAt == this.purchasedAt &&
          other.localDate == this.localDate &&
          other.note == this.note &&
          other.expiryDate == this.expiryDate &&
          other.deletedAt == this.deletedAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> storeId;
  final Value<String?> tripId;
  final Value<double> quantity;
  final Value<String> unitId;
  final Value<int> priceDzd;
  final Value<bool> isUnitPrice;
  final Value<int> totalDzd;
  final Value<double?> normalizedBaseQuantity;
  final Value<double?> normalizedDzdPerBaseUnit;
  final Value<DateTime> purchasedAt;
  final Value<String> localDate;
  final Value<String?> note;
  final Value<DateTime?> expiryDate;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.tripId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.priceDzd = const Value.absent(),
    this.isUnitPrice = const Value.absent(),
    this.totalDzd = const Value.absent(),
    this.normalizedBaseQuantity = const Value.absent(),
    this.normalizedDzdPerBaseUnit = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.note = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    required String productId,
    this.storeId = const Value.absent(),
    this.tripId = const Value.absent(),
    required double quantity,
    required String unitId,
    required int priceDzd,
    this.isUnitPrice = const Value.absent(),
    required int totalDzd,
    this.normalizedBaseQuantity = const Value.absent(),
    this.normalizedDzdPerBaseUnit = const Value.absent(),
    required DateTime purchasedAt,
    required String localDate,
    this.note = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       quantity = Value(quantity),
       unitId = Value(unitId),
       priceDzd = Value(priceDzd),
       totalDzd = Value(totalDzd),
       purchasedAt = Value(purchasedAt),
       localDate = Value(localDate);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? storeId,
    Expression<String>? tripId,
    Expression<double>? quantity,
    Expression<String>? unitId,
    Expression<int>? priceDzd,
    Expression<bool>? isUnitPrice,
    Expression<int>? totalDzd,
    Expression<double>? normalizedBaseQuantity,
    Expression<double>? normalizedDzdPerBaseUnit,
    Expression<DateTime>? purchasedAt,
    Expression<String>? localDate,
    Expression<String>? note,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (storeId != null) 'store_id': storeId,
      if (tripId != null) 'trip_id': tripId,
      if (quantity != null) 'quantity': quantity,
      if (unitId != null) 'unit_id': unitId,
      if (priceDzd != null) 'price_dzd': priceDzd,
      if (isUnitPrice != null) 'is_unit_price': isUnitPrice,
      if (totalDzd != null) 'total_dzd': totalDzd,
      if (normalizedBaseQuantity != null)
        'normalized_base_quantity': normalizedBaseQuantity,
      if (normalizedDzdPerBaseUnit != null)
        'normalized_dzd_per_base_unit': normalizedDzdPerBaseUnit,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (localDate != null) 'local_date': localDate,
      if (note != null) 'note': note,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String?>? storeId,
    Value<String?>? tripId,
    Value<double>? quantity,
    Value<String>? unitId,
    Value<int>? priceDzd,
    Value<bool>? isUnitPrice,
    Value<int>? totalDzd,
    Value<double?>? normalizedBaseQuantity,
    Value<double?>? normalizedDzdPerBaseUnit,
    Value<DateTime>? purchasedAt,
    Value<String>? localDate,
    Value<String?>? note,
    Value<DateTime?>? expiryDate,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      tripId: tripId ?? this.tripId,
      quantity: quantity ?? this.quantity,
      unitId: unitId ?? this.unitId,
      priceDzd: priceDzd ?? this.priceDzd,
      isUnitPrice: isUnitPrice ?? this.isUnitPrice,
      totalDzd: totalDzd ?? this.totalDzd,
      normalizedBaseQuantity:
          normalizedBaseQuantity ?? this.normalizedBaseQuantity,
      normalizedDzdPerBaseUnit:
          normalizedDzdPerBaseUnit ?? this.normalizedDzdPerBaseUnit,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      localDate: localDate ?? this.localDate,
      note: note ?? this.note,
      expiryDate: expiryDate ?? this.expiryDate,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (priceDzd.present) {
      map['price_dzd'] = Variable<int>(priceDzd.value);
    }
    if (isUnitPrice.present) {
      map['is_unit_price'] = Variable<bool>(isUnitPrice.value);
    }
    if (totalDzd.present) {
      map['total_dzd'] = Variable<int>(totalDzd.value);
    }
    if (normalizedBaseQuantity.present) {
      map['normalized_base_quantity'] = Variable<double>(
        normalizedBaseQuantity.value,
      );
    }
    if (normalizedDzdPerBaseUnit.present) {
      map['normalized_dzd_per_base_unit'] = Variable<double>(
        normalizedDzdPerBaseUnit.value,
      );
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('storeId: $storeId, ')
          ..write('tripId: $tripId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('priceDzd: $priceDzd, ')
          ..write('isUnitPrice: $isUnitPrice, ')
          ..write('totalDzd: $totalDzd, ')
          ..write('normalizedBaseQuantity: $normalizedBaseQuantity, ')
          ..write('normalizedDzdPerBaseUnit: $normalizedDzdPerBaseUnit, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('localDate: $localDate, ')
          ..write('note: $note, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LaterBuyItemsTable extends LaterBuyItems
    with TableInfo<$LaterBuyItemsTable, LaterBuyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LaterBuyItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observedPriceDzdMeta = const VerificationMeta(
    'observedPriceDzd',
  );
  @override
  late final GeneratedColumn<int> observedPriceDzd = GeneratedColumn<int>(
    'observed_price_dzd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observedQuantityMeta = const VerificationMeta(
    'observedQuantity',
  );
  @override
  late final GeneratedColumn<double> observedQuantity = GeneratedColumn<double>(
    'observed_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observedUnitIdMeta = const VerificationMeta(
    'observedUnitId',
  );
  @override
  late final GeneratedColumn<String> observedUnitId = GeneratedColumn<String>(
    'observed_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPriceDzdMeta = const VerificationMeta(
    'targetPriceDzd',
  );
  @override
  late final GeneratedColumn<int> targetPriceDzd = GeneratedColumn<int>(
    'target_price_dzd',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expensive'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolvedPurchaseIdMeta =
      const VerificationMeta('resolvedPurchaseId');
  @override
  late final GeneratedColumn<String> resolvedPurchaseId =
      GeneratedColumn<String>(
        'resolved_purchase_id',
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    observedPriceDzd,
    observedQuantity,
    observedUnitId,
    targetPriceDzd,
    storeId,
    reason,
    status,
    reminderAt,
    resolvedPurchaseId,
    createdAt,
    updatedAt,
    resolvedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'later_buy_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LaterBuyItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('observed_price_dzd')) {
      context.handle(
        _observedPriceDzdMeta,
        observedPriceDzd.isAcceptableOrUnknown(
          data['observed_price_dzd']!,
          _observedPriceDzdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observedPriceDzdMeta);
    }
    if (data.containsKey('observed_quantity')) {
      context.handle(
        _observedQuantityMeta,
        observedQuantity.isAcceptableOrUnknown(
          data['observed_quantity']!,
          _observedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observedQuantityMeta);
    }
    if (data.containsKey('observed_unit_id')) {
      context.handle(
        _observedUnitIdMeta,
        observedUnitId.isAcceptableOrUnknown(
          data['observed_unit_id']!,
          _observedUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observedUnitIdMeta);
    }
    if (data.containsKey('target_price_dzd')) {
      context.handle(
        _targetPriceDzdMeta,
        targetPriceDzd.isAcceptableOrUnknown(
          data['target_price_dzd']!,
          _targetPriceDzdMeta,
        ),
      );
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('resolved_purchase_id')) {
      context.handle(
        _resolvedPurchaseIdMeta,
        resolvedPurchaseId.isAcceptableOrUnknown(
          data['resolved_purchase_id']!,
          _resolvedPurchaseIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LaterBuyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LaterBuyItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      observedPriceDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}observed_price_dzd'],
      )!,
      observedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}observed_quantity'],
      )!,
      observedUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observed_unit_id'],
      )!,
      targetPriceDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_price_dzd'],
      ),
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      resolvedPurchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolved_purchase_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LaterBuyItemsTable createAlias(String alias) {
    return $LaterBuyItemsTable(attachedDatabase, alias);
  }
}

class LaterBuyItem extends DataClass implements Insertable<LaterBuyItem> {
  final String id;
  final String productId;
  final int observedPriceDzd;
  final double observedQuantity;
  final String observedUnitId;
  final int? targetPriceDzd;
  final String? storeId;
  final String reason;
  final String status;
  final DateTime? reminderAt;
  final String? resolvedPurchaseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final DateTime? deletedAt;
  const LaterBuyItem({
    required this.id,
    required this.productId,
    required this.observedPriceDzd,
    required this.observedQuantity,
    required this.observedUnitId,
    this.targetPriceDzd,
    this.storeId,
    required this.reason,
    required this.status,
    this.reminderAt,
    this.resolvedPurchaseId,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['observed_price_dzd'] = Variable<int>(observedPriceDzd);
    map['observed_quantity'] = Variable<double>(observedQuantity);
    map['observed_unit_id'] = Variable<String>(observedUnitId);
    if (!nullToAbsent || targetPriceDzd != null) {
      map['target_price_dzd'] = Variable<int>(targetPriceDzd);
    }
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<String>(storeId);
    }
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    if (!nullToAbsent || resolvedPurchaseId != null) {
      map['resolved_purchase_id'] = Variable<String>(resolvedPurchaseId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LaterBuyItemsCompanion toCompanion(bool nullToAbsent) {
    return LaterBuyItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      observedPriceDzd: Value(observedPriceDzd),
      observedQuantity: Value(observedQuantity),
      observedUnitId: Value(observedUnitId),
      targetPriceDzd: targetPriceDzd == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPriceDzd),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      reason: Value(reason),
      status: Value(status),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      resolvedPurchaseId: resolvedPurchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedPurchaseId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LaterBuyItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LaterBuyItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      observedPriceDzd: serializer.fromJson<int>(json['observedPriceDzd']),
      observedQuantity: serializer.fromJson<double>(json['observedQuantity']),
      observedUnitId: serializer.fromJson<String>(json['observedUnitId']),
      targetPriceDzd: serializer.fromJson<int?>(json['targetPriceDzd']),
      storeId: serializer.fromJson<String?>(json['storeId']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      resolvedPurchaseId: serializer.fromJson<String?>(
        json['resolvedPurchaseId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'observedPriceDzd': serializer.toJson<int>(observedPriceDzd),
      'observedQuantity': serializer.toJson<double>(observedQuantity),
      'observedUnitId': serializer.toJson<String>(observedUnitId),
      'targetPriceDzd': serializer.toJson<int?>(targetPriceDzd),
      'storeId': serializer.toJson<String?>(storeId),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'resolvedPurchaseId': serializer.toJson<String?>(resolvedPurchaseId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LaterBuyItem copyWith({
    String? id,
    String? productId,
    int? observedPriceDzd,
    double? observedQuantity,
    String? observedUnitId,
    Value<int?> targetPriceDzd = const Value.absent(),
    Value<String?> storeId = const Value.absent(),
    String? reason,
    String? status,
    Value<DateTime?> reminderAt = const Value.absent(),
    Value<String?> resolvedPurchaseId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LaterBuyItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    observedPriceDzd: observedPriceDzd ?? this.observedPriceDzd,
    observedQuantity: observedQuantity ?? this.observedQuantity,
    observedUnitId: observedUnitId ?? this.observedUnitId,
    targetPriceDzd: targetPriceDzd.present
        ? targetPriceDzd.value
        : this.targetPriceDzd,
    storeId: storeId.present ? storeId.value : this.storeId,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    resolvedPurchaseId: resolvedPurchaseId.present
        ? resolvedPurchaseId.value
        : this.resolvedPurchaseId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LaterBuyItem copyWithCompanion(LaterBuyItemsCompanion data) {
    return LaterBuyItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      observedPriceDzd: data.observedPriceDzd.present
          ? data.observedPriceDzd.value
          : this.observedPriceDzd,
      observedQuantity: data.observedQuantity.present
          ? data.observedQuantity.value
          : this.observedQuantity,
      observedUnitId: data.observedUnitId.present
          ? data.observedUnitId.value
          : this.observedUnitId,
      targetPriceDzd: data.targetPriceDzd.present
          ? data.targetPriceDzd.value
          : this.targetPriceDzd,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      resolvedPurchaseId: data.resolvedPurchaseId.present
          ? data.resolvedPurchaseId.value
          : this.resolvedPurchaseId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LaterBuyItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('observedPriceDzd: $observedPriceDzd, ')
          ..write('observedQuantity: $observedQuantity, ')
          ..write('observedUnitId: $observedUnitId, ')
          ..write('targetPriceDzd: $targetPriceDzd, ')
          ..write('storeId: $storeId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('resolvedPurchaseId: $resolvedPurchaseId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    observedPriceDzd,
    observedQuantity,
    observedUnitId,
    targetPriceDzd,
    storeId,
    reason,
    status,
    reminderAt,
    resolvedPurchaseId,
    createdAt,
    updatedAt,
    resolvedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LaterBuyItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.observedPriceDzd == this.observedPriceDzd &&
          other.observedQuantity == this.observedQuantity &&
          other.observedUnitId == this.observedUnitId &&
          other.targetPriceDzd == this.targetPriceDzd &&
          other.storeId == this.storeId &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.reminderAt == this.reminderAt &&
          other.resolvedPurchaseId == this.resolvedPurchaseId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.resolvedAt == this.resolvedAt &&
          other.deletedAt == this.deletedAt);
}

class LaterBuyItemsCompanion extends UpdateCompanion<LaterBuyItem> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> observedPriceDzd;
  final Value<double> observedQuantity;
  final Value<String> observedUnitId;
  final Value<int?> targetPriceDzd;
  final Value<String?> storeId;
  final Value<String> reason;
  final Value<String> status;
  final Value<DateTime?> reminderAt;
  final Value<String?> resolvedPurchaseId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> resolvedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LaterBuyItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.observedPriceDzd = const Value.absent(),
    this.observedQuantity = const Value.absent(),
    this.observedUnitId = const Value.absent(),
    this.targetPriceDzd = const Value.absent(),
    this.storeId = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.resolvedPurchaseId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LaterBuyItemsCompanion.insert({
    required String id,
    required String productId,
    required int observedPriceDzd,
    required double observedQuantity,
    required String observedUnitId,
    this.targetPriceDzd = const Value.absent(),
    this.storeId = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.resolvedPurchaseId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.resolvedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       observedPriceDzd = Value(observedPriceDzd),
       observedQuantity = Value(observedQuantity),
       observedUnitId = Value(observedUnitId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LaterBuyItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? observedPriceDzd,
    Expression<double>? observedQuantity,
    Expression<String>? observedUnitId,
    Expression<int>? targetPriceDzd,
    Expression<String>? storeId,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? reminderAt,
    Expression<String>? resolvedPurchaseId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? resolvedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (observedPriceDzd != null) 'observed_price_dzd': observedPriceDzd,
      if (observedQuantity != null) 'observed_quantity': observedQuantity,
      if (observedUnitId != null) 'observed_unit_id': observedUnitId,
      if (targetPriceDzd != null) 'target_price_dzd': targetPriceDzd,
      if (storeId != null) 'store_id': storeId,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (resolvedPurchaseId != null)
        'resolved_purchase_id': resolvedPurchaseId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LaterBuyItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<int>? observedPriceDzd,
    Value<double>? observedQuantity,
    Value<String>? observedUnitId,
    Value<int?>? targetPriceDzd,
    Value<String?>? storeId,
    Value<String>? reason,
    Value<String>? status,
    Value<DateTime?>? reminderAt,
    Value<String?>? resolvedPurchaseId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? resolvedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LaterBuyItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      observedPriceDzd: observedPriceDzd ?? this.observedPriceDzd,
      observedQuantity: observedQuantity ?? this.observedQuantity,
      observedUnitId: observedUnitId ?? this.observedUnitId,
      targetPriceDzd: targetPriceDzd ?? this.targetPriceDzd,
      storeId: storeId ?? this.storeId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      reminderAt: reminderAt ?? this.reminderAt,
      resolvedPurchaseId: resolvedPurchaseId ?? this.resolvedPurchaseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (observedPriceDzd.present) {
      map['observed_price_dzd'] = Variable<int>(observedPriceDzd.value);
    }
    if (observedQuantity.present) {
      map['observed_quantity'] = Variable<double>(observedQuantity.value);
    }
    if (observedUnitId.present) {
      map['observed_unit_id'] = Variable<String>(observedUnitId.value);
    }
    if (targetPriceDzd.present) {
      map['target_price_dzd'] = Variable<int>(targetPriceDzd.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (resolvedPurchaseId.present) {
      map['resolved_purchase_id'] = Variable<String>(resolvedPurchaseId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LaterBuyItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('observedPriceDzd: $observedPriceDzd, ')
          ..write('observedQuantity: $observedQuantity, ')
          ..write('observedUnitId: $observedUnitId, ')
          ..write('targetPriceDzd: $targetPriceDzd, ')
          ..write('storeId: $storeId, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('resolvedPurchaseId: $resolvedPurchaseId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteTypeMeta = const VerificationMeta(
    'noteType',
  );
  @override
  late final GeneratedColumn<String> noteType = GeneratedColumn<String>(
    'note_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('food_diary'),
  );
  static const VerificationMeta _eventAtMeta = const VerificationMeta(
    'eventAt',
  );
  @override
  late final GeneratedColumn<DateTime> eventAt = GeneratedColumn<DateTime>(
    'event_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    noteType,
    eventAt,
    localDate,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('note_type')) {
      context.handle(
        _noteTypeMeta,
        noteType.isAcceptableOrUnknown(data['note_type']!, _noteTypeMeta),
      );
    }
    if (data.containsKey('event_at')) {
      context.handle(
        _eventAtMeta,
        eventAt.isAcceptableOrUnknown(data['event_at']!, _eventAtMeta),
      );
    } else if (isInserting) {
      context.missing(_eventAtMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      noteType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_type'],
      )!,
      eventAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_at'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String body;
  final String noteType;
  final DateTime eventAt;
  final String localDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.noteType,
    required this.eventAt,
    required this.localDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['note_type'] = Variable<String>(noteType);
    map['event_at'] = Variable<DateTime>(eventAt);
    map['local_date'] = Variable<String>(localDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      noteType: Value(noteType),
      eventAt: Value(eventAt),
      localDate: Value(localDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      noteType: serializer.fromJson<String>(json['noteType']),
      eventAt: serializer.fromJson<DateTime>(json['eventAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'noteType': serializer.toJson<String>(noteType),
      'eventAt': serializer.toJson<DateTime>(eventAt),
      'localDate': serializer.toJson<String>(localDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? body,
    String? noteType,
    DateTime? eventAt,
    String? localDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    noteType: noteType ?? this.noteType,
    eventAt: eventAt ?? this.eventAt,
    localDate: localDate ?? this.localDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      noteType: data.noteType.present ? data.noteType.value : this.noteType,
      eventAt: data.eventAt.present ? data.eventAt.value : this.eventAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('noteType: $noteType, ')
          ..write('eventAt: $eventAt, ')
          ..write('localDate: $localDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    noteType,
    eventAt,
    localDate,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.noteType == this.noteType &&
          other.eventAt == this.eventAt &&
          other.localDate == this.localDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> noteType;
  final Value<DateTime> eventAt;
  final Value<String> localDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.noteType = const Value.absent(),
    this.eventAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.noteType = const Value.absent(),
    required DateTime eventAt,
    required String localDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       body = Value(body),
       eventAt = Value(eventAt),
       localDate = Value(localDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? noteType,
    Expression<DateTime>? eventAt,
    Expression<String>? localDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (noteType != null) 'note_type': noteType,
      if (eventAt != null) 'event_at': eventAt,
      if (localDate != null) 'local_date': localDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String>? noteType,
    Value<DateTime>? eventAt,
    Value<String>? localDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      noteType: noteType ?? this.noteType,
      eventAt: eventAt ?? this.eventAt,
      localDate: localDate ?? this.localDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (noteType.present) {
      map['note_type'] = Variable<String>(noteType.value);
    }
    if (eventAt.present) {
      map['event_at'] = Variable<DateTime>(eventAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('noteType: $noteType, ')
          ..write('eventAt: $eventAt, ')
          ..write('localDate: $localDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteTagsTable extends NoteTags with TableInfo<$NoteTagsTable, NoteTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, noteId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $NoteTagsTable createAlias(String alias) {
    return $NoteTagsTable(attachedDatabase, alias);
  }
}

class NoteTag extends DataClass implements Insertable<NoteTag> {
  final String id;
  final String noteId;
  final String tag;
  const NoteTag({required this.id, required this.noteId, required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['note_id'] = Variable<String>(noteId);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  NoteTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteTagsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      tag: Value(tag),
    );
  }

  factory NoteTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTag(
      id: serializer.fromJson<String>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'noteId': serializer.toJson<String>(noteId),
      'tag': serializer.toJson<String>(tag),
    };
  }

  NoteTag copyWith({String? id, String? noteId, String? tag}) => NoteTag(
    id: id ?? this.id,
    noteId: noteId ?? this.noteId,
    tag: tag ?? this.tag,
  );
  NoteTag copyWithCompanion(NoteTagsCompanion data) {
    return NoteTag(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTag(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTag &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.tag == this.tag);
}

class NoteTagsCompanion extends UpdateCompanion<NoteTag> {
  final Value<String> id;
  final Value<String> noteId;
  final Value<String> tag;
  final Value<int> rowid;
  const NoteTagsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagsCompanion.insert({
    required String id,
    required String noteId,
    required String tag,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       noteId = Value(noteId),
       tag = Value(tag);
  static Insertable<NoteTag> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagsCompanion copyWith({
    Value<String>? id,
    Value<String>? noteId,
    Value<String>? tag,
    Value<int>? rowid,
  }) {
    return NoteTagsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteProductLinksTable extends NoteProductLinks
    with TableInfo<$NoteProductLinksTable, NoteProductLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteProductLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [noteId, productId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_product_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteProductLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, productId};
  @override
  NoteProductLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteProductLink(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
    );
  }

  @override
  $NoteProductLinksTable createAlias(String alias) {
    return $NoteProductLinksTable(attachedDatabase, alias);
  }
}

class NoteProductLink extends DataClass implements Insertable<NoteProductLink> {
  final String noteId;
  final String productId;
  const NoteProductLink({required this.noteId, required this.productId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['product_id'] = Variable<String>(productId);
    return map;
  }

  NoteProductLinksCompanion toCompanion(bool nullToAbsent) {
    return NoteProductLinksCompanion(
      noteId: Value(noteId),
      productId: Value(productId),
    );
  }

  factory NoteProductLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteProductLink(
      noteId: serializer.fromJson<String>(json['noteId']),
      productId: serializer.fromJson<String>(json['productId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'productId': serializer.toJson<String>(productId),
    };
  }

  NoteProductLink copyWith({String? noteId, String? productId}) =>
      NoteProductLink(
        noteId: noteId ?? this.noteId,
        productId: productId ?? this.productId,
      );
  NoteProductLink copyWithCompanion(NoteProductLinksCompanion data) {
    return NoteProductLink(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      productId: data.productId.present ? data.productId.value : this.productId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteProductLink(')
          ..write('noteId: $noteId, ')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, productId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteProductLink &&
          other.noteId == this.noteId &&
          other.productId == this.productId);
}

class NoteProductLinksCompanion extends UpdateCompanion<NoteProductLink> {
  final Value<String> noteId;
  final Value<String> productId;
  final Value<int> rowid;
  const NoteProductLinksCompanion({
    this.noteId = const Value.absent(),
    this.productId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteProductLinksCompanion.insert({
    required String noteId,
    required String productId,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       productId = Value(productId);
  static Insertable<NoteProductLink> custom({
    Expression<String>? noteId,
    Expression<String>? productId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (productId != null) 'product_id': productId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteProductLinksCompanion copyWith({
    Value<String>? noteId,
    Value<String>? productId,
    Value<int>? rowid,
  }) {
    return NoteProductLinksCompanion(
      noteId: noteId ?? this.noteId,
      productId: productId ?? this.productId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteProductLinksCompanion(')
          ..write('noteId: $noteId, ')
          ..write('productId: $productId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotePurchaseLinksTable extends NotePurchaseLinks
    with TableInfo<$NotePurchaseLinksTable, NotePurchaseLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotePurchaseLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [noteId, purchaseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_purchase_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotePurchaseLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, purchaseId};
  @override
  NotePurchaseLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotePurchaseLink(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
    );
  }

  @override
  $NotePurchaseLinksTable createAlias(String alias) {
    return $NotePurchaseLinksTable(attachedDatabase, alias);
  }
}

class NotePurchaseLink extends DataClass
    implements Insertable<NotePurchaseLink> {
  final String noteId;
  final String purchaseId;
  const NotePurchaseLink({required this.noteId, required this.purchaseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['purchase_id'] = Variable<String>(purchaseId);
    return map;
  }

  NotePurchaseLinksCompanion toCompanion(bool nullToAbsent) {
    return NotePurchaseLinksCompanion(
      noteId: Value(noteId),
      purchaseId: Value(purchaseId),
    );
  }

  factory NotePurchaseLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotePurchaseLink(
      noteId: serializer.fromJson<String>(json['noteId']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'purchaseId': serializer.toJson<String>(purchaseId),
    };
  }

  NotePurchaseLink copyWith({String? noteId, String? purchaseId}) =>
      NotePurchaseLink(
        noteId: noteId ?? this.noteId,
        purchaseId: purchaseId ?? this.purchaseId,
      );
  NotePurchaseLink copyWithCompanion(NotePurchaseLinksCompanion data) {
    return NotePurchaseLink(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotePurchaseLink(')
          ..write('noteId: $noteId, ')
          ..write('purchaseId: $purchaseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, purchaseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotePurchaseLink &&
          other.noteId == this.noteId &&
          other.purchaseId == this.purchaseId);
}

class NotePurchaseLinksCompanion extends UpdateCompanion<NotePurchaseLink> {
  final Value<String> noteId;
  final Value<String> purchaseId;
  final Value<int> rowid;
  const NotePurchaseLinksCompanion({
    this.noteId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotePurchaseLinksCompanion.insert({
    required String noteId,
    required String purchaseId,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       purchaseId = Value(purchaseId);
  static Insertable<NotePurchaseLink> custom({
    Expression<String>? noteId,
    Expression<String>? purchaseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotePurchaseLinksCompanion copyWith({
    Value<String>? noteId,
    Value<String>? purchaseId,
    Value<int>? rowid,
  }) {
    return NotePurchaseLinksCompanion(
      noteId: noteId ?? this.noteId,
      purchaseId: purchaseId ?? this.purchaseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotePurchaseLinksCompanion(')
          ..write('noteId: $noteId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    isArchived,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String title;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ShoppingList({
    required this.id,
    required this.title,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      title: Value(title),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ShoppingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ShoppingList copyWith({
    String? id,
    String? title,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ShoppingList(
    id: id ?? this.id,
    title: title ?? this.title,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, isArchived, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.title == this.title &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    required String title,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('piece'),
  );
  static const VerificationMeta _estimatedPriceDzdMeta = const VerificationMeta(
    'estimatedPriceDzd',
  );
  @override
  late final GeneratedColumn<int> estimatedPriceDzd = GeneratedColumn<int>(
    'estimated_price_dzd',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _convertedPurchaseIdMeta =
      const VerificationMeta('convertedPurchaseId');
  @override
  late final GeneratedColumn<String> convertedPurchaseId =
      GeneratedColumn<String>(
        'converted_purchase_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    productId,
    customName,
    quantity,
    unitId,
    estimatedPriceDzd,
    isCompleted,
    convertedPurchaseId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    } else if (isInserting) {
      context.missing(_customNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    }
    if (data.containsKey('estimated_price_dzd')) {
      context.handle(
        _estimatedPriceDzdMeta,
        estimatedPriceDzd.isAcceptableOrUnknown(
          data['estimated_price_dzd']!,
          _estimatedPriceDzdMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('converted_purchase_id')) {
      context.handle(
        _convertedPurchaseIdMeta,
        convertedPurchaseId.isAcceptableOrUnknown(
          data['converted_purchase_id']!,
          _convertedPurchaseIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      estimatedPriceDzd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_price_dzd'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      convertedPurchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}converted_purchase_id'],
      ),
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String listId;
  final String? productId;
  final String customName;
  final double quantity;
  final String unitId;
  final int? estimatedPriceDzd;
  final bool isCompleted;
  final String? convertedPurchaseId;
  const ShoppingListItem({
    required this.id,
    required this.listId,
    this.productId,
    required this.customName,
    required this.quantity,
    required this.unitId,
    this.estimatedPriceDzd,
    required this.isCompleted,
    this.convertedPurchaseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['custom_name'] = Variable<String>(customName);
    map['quantity'] = Variable<double>(quantity);
    map['unit_id'] = Variable<String>(unitId);
    if (!nullToAbsent || estimatedPriceDzd != null) {
      map['estimated_price_dzd'] = Variable<int>(estimatedPriceDzd);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || convertedPurchaseId != null) {
      map['converted_purchase_id'] = Variable<String>(convertedPurchaseId);
    }
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      customName: Value(customName),
      quantity: Value(quantity),
      unitId: Value(unitId),
      estimatedPriceDzd: estimatedPriceDzd == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPriceDzd),
      isCompleted: Value(isCompleted),
      convertedPurchaseId: convertedPurchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(convertedPurchaseId),
    );
  }

  factory ShoppingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      productId: serializer.fromJson<String?>(json['productId']),
      customName: serializer.fromJson<String>(json['customName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitId: serializer.fromJson<String>(json['unitId']),
      estimatedPriceDzd: serializer.fromJson<int?>(json['estimatedPriceDzd']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      convertedPurchaseId: serializer.fromJson<String?>(
        json['convertedPurchaseId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'productId': serializer.toJson<String?>(productId),
      'customName': serializer.toJson<String>(customName),
      'quantity': serializer.toJson<double>(quantity),
      'unitId': serializer.toJson<String>(unitId),
      'estimatedPriceDzd': serializer.toJson<int?>(estimatedPriceDzd),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'convertedPurchaseId': serializer.toJson<String?>(convertedPurchaseId),
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    Value<String?> productId = const Value.absent(),
    String? customName,
    double? quantity,
    String? unitId,
    Value<int?> estimatedPriceDzd = const Value.absent(),
    bool? isCompleted,
    Value<String?> convertedPurchaseId = const Value.absent(),
  }) => ShoppingListItem(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    productId: productId.present ? productId.value : this.productId,
    customName: customName ?? this.customName,
    quantity: quantity ?? this.quantity,
    unitId: unitId ?? this.unitId,
    estimatedPriceDzd: estimatedPriceDzd.present
        ? estimatedPriceDzd.value
        : this.estimatedPriceDzd,
    isCompleted: isCompleted ?? this.isCompleted,
    convertedPurchaseId: convertedPurchaseId.present
        ? convertedPurchaseId.value
        : this.convertedPurchaseId,
  );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      productId: data.productId.present ? data.productId.value : this.productId,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      estimatedPriceDzd: data.estimatedPriceDzd.present
          ? data.estimatedPriceDzd.value
          : this.estimatedPriceDzd,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      convertedPurchaseId: data.convertedPurchaseId.present
          ? data.convertedPurchaseId.value
          : this.convertedPurchaseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('estimatedPriceDzd: $estimatedPriceDzd, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('convertedPurchaseId: $convertedPurchaseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    productId,
    customName,
    quantity,
    unitId,
    estimatedPriceDzd,
    isCompleted,
    convertedPurchaseId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.productId == this.productId &&
          other.customName == this.customName &&
          other.quantity == this.quantity &&
          other.unitId == this.unitId &&
          other.estimatedPriceDzd == this.estimatedPriceDzd &&
          other.isCompleted == this.isCompleted &&
          other.convertedPurchaseId == this.convertedPurchaseId);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String?> productId;
  final Value<String> customName;
  final Value<double> quantity;
  final Value<String> unitId;
  final Value<int?> estimatedPriceDzd;
  final Value<bool> isCompleted;
  final Value<String?> convertedPurchaseId;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.productId = const Value.absent(),
    this.customName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.estimatedPriceDzd = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.convertedPurchaseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String listId,
    this.productId = const Value.absent(),
    required String customName,
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.estimatedPriceDzd = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.convertedPurchaseId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       customName = Value(customName);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? productId,
    Expression<String>? customName,
    Expression<double>? quantity,
    Expression<String>? unitId,
    Expression<int>? estimatedPriceDzd,
    Expression<bool>? isCompleted,
    Expression<String>? convertedPurchaseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (productId != null) 'product_id': productId,
      if (customName != null) 'custom_name': customName,
      if (quantity != null) 'quantity': quantity,
      if (unitId != null) 'unit_id': unitId,
      if (estimatedPriceDzd != null) 'estimated_price_dzd': estimatedPriceDzd,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (convertedPurchaseId != null)
        'converted_purchase_id': convertedPurchaseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String?>? productId,
    Value<String>? customName,
    Value<double>? quantity,
    Value<String>? unitId,
    Value<int?>? estimatedPriceDzd,
    Value<bool>? isCompleted,
    Value<String?>? convertedPurchaseId,
    Value<int>? rowid,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      productId: productId ?? this.productId,
      customName: customName ?? this.customName,
      quantity: quantity ?? this.quantity,
      unitId: unitId ?? this.unitId,
      estimatedPriceDzd: estimatedPriceDzd ?? this.estimatedPriceDzd,
      isCompleted: isCompleted ?? this.isCompleted,
      convertedPurchaseId: convertedPurchaseId ?? this.convertedPurchaseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (estimatedPriceDzd.present) {
      map['estimated_price_dzd'] = Variable<int>(estimatedPriceDzd.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (convertedPurchaseId.present) {
      map['converted_purchase_id'] = Variable<String>(
        convertedPurchaseId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('estimatedPriceDzd: $estimatedPriceDzd, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('convertedPurchaseId: $convertedPurchaseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedTypeMeta = const VerificationMeta(
    'relatedType',
  );
  @override
  late final GeneratedColumn<String> relatedType = GeneratedColumn<String>(
    'related_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedIdMeta = const VerificationMeta(
    'relatedId',
  );
  @override
  late final GeneratedColumn<String> relatedId = GeneratedColumn<String>(
    'related_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localNotificationIdMeta =
      const VerificationMeta('localNotificationId');
  @override
  late final GeneratedColumn<int> localNotificationId = GeneratedColumn<int>(
    'local_notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    relatedType,
    relatedId,
    scheduledAt,
    localNotificationId,
    isEnabled,
    deliveredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('related_type')) {
      context.handle(
        _relatedTypeMeta,
        relatedType.isAcceptableOrUnknown(
          data['related_type']!,
          _relatedTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedTypeMeta);
    }
    if (data.containsKey('related_id')) {
      context.handle(
        _relatedIdMeta,
        relatedId.isAcceptableOrUnknown(data['related_id']!, _relatedIdMeta),
      );
    } else if (isInserting) {
      context.missing(_relatedIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('local_notification_id')) {
      context.handle(
        _localNotificationIdMeta,
        localNotificationId.isAcceptableOrUnknown(
          data['local_notification_id']!,
          _localNotificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localNotificationIdMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      relatedType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_type'],
      )!,
      relatedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      localNotificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_notification_id'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String relatedType;
  final String relatedId;
  final DateTime scheduledAt;
  final int localNotificationId;
  final bool isEnabled;
  final DateTime? deliveredAt;
  const Reminder({
    required this.id,
    required this.relatedType,
    required this.relatedId,
    required this.scheduledAt,
    required this.localNotificationId,
    required this.isEnabled,
    this.deliveredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['related_type'] = Variable<String>(relatedType);
    map['related_id'] = Variable<String>(relatedId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['local_notification_id'] = Variable<int>(localNotificationId);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      relatedType: Value(relatedType),
      relatedId: Value(relatedId),
      scheduledAt: Value(scheduledAt),
      localNotificationId: Value(localNotificationId),
      isEnabled: Value(isEnabled),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      relatedType: serializer.fromJson<String>(json['relatedType']),
      relatedId: serializer.fromJson<String>(json['relatedId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      localNotificationId: serializer.fromJson<int>(
        json['localNotificationId'],
      ),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'relatedType': serializer.toJson<String>(relatedType),
      'relatedId': serializer.toJson<String>(relatedId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'localNotificationId': serializer.toJson<int>(localNotificationId),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
    };
  }

  Reminder copyWith({
    String? id,
    String? relatedType,
    String? relatedId,
    DateTime? scheduledAt,
    int? localNotificationId,
    bool? isEnabled,
    Value<DateTime?> deliveredAt = const Value.absent(),
  }) => Reminder(
    id: id ?? this.id,
    relatedType: relatedType ?? this.relatedType,
    relatedId: relatedId ?? this.relatedId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    localNotificationId: localNotificationId ?? this.localNotificationId,
    isEnabled: isEnabled ?? this.isEnabled,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      relatedType: data.relatedType.present
          ? data.relatedType.value
          : this.relatedType,
      relatedId: data.relatedId.present ? data.relatedId.value : this.relatedId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      localNotificationId: data.localNotificationId.present
          ? data.localNotificationId.value
          : this.localNotificationId,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('relatedType: $relatedType, ')
          ..write('relatedId: $relatedId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('localNotificationId: $localNotificationId, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    relatedType,
    relatedId,
    scheduledAt,
    localNotificationId,
    isEnabled,
    deliveredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.relatedType == this.relatedType &&
          other.relatedId == this.relatedId &&
          other.scheduledAt == this.scheduledAt &&
          other.localNotificationId == this.localNotificationId &&
          other.isEnabled == this.isEnabled &&
          other.deliveredAt == this.deliveredAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> relatedType;
  final Value<String> relatedId;
  final Value<DateTime> scheduledAt;
  final Value<int> localNotificationId;
  final Value<bool> isEnabled;
  final Value<DateTime?> deliveredAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.relatedType = const Value.absent(),
    this.relatedId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.localNotificationId = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String relatedType,
    required String relatedId,
    required DateTime scheduledAt,
    required int localNotificationId,
    this.isEnabled = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       relatedType = Value(relatedType),
       relatedId = Value(relatedId),
       scheduledAt = Value(scheduledAt),
       localNotificationId = Value(localNotificationId);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? relatedType,
    Expression<String>? relatedId,
    Expression<DateTime>? scheduledAt,
    Expression<int>? localNotificationId,
    Expression<bool>? isEnabled,
    Expression<DateTime>? deliveredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (relatedType != null) 'related_type': relatedType,
      if (relatedId != null) 'related_id': relatedId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (localNotificationId != null)
        'local_notification_id': localNotificationId,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? relatedType,
    Value<String>? relatedId,
    Value<DateTime>? scheduledAt,
    Value<int>? localNotificationId,
    Value<bool>? isEnabled,
    Value<DateTime?>? deliveredAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      relatedType: relatedType ?? this.relatedType,
      relatedId: relatedId ?? this.relatedId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      localNotificationId: localNotificationId ?? this.localNotificationId,
      isEnabled: isEnabled ?? this.isEnabled,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (relatedType.present) {
      map['related_type'] = Variable<String>(relatedType.value);
    }
    if (relatedId.present) {
      map['related_id'] = Variable<String>(relatedId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (localNotificationId.present) {
      map['local_notification_id'] = Variable<int>(localNotificationId.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('relatedType: $relatedType, ')
          ..write('relatedId: $relatedId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('localNotificationId: $localNotificationId, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $StoresTable stores = $StoresTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductAliasesTable productAliases = $ProductAliasesTable(this);
  late final $ProductConversionsTable productConversions =
      $ProductConversionsTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $LaterBuyItemsTable laterBuyItems = $LaterBuyItemsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $NoteTagsTable noteTags = $NoteTagsTable(this);
  late final $NoteProductLinksTable noteProductLinks = $NoteProductLinksTable(
    this,
  );
  late final $NotePurchaseLinksTable notePurchaseLinks =
      $NotePurchaseLinksTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    categories,
    stores,
    products,
    productAliases,
    productConversions,
    purchases,
    laterBuyItems,
    notes,
    noteTags,
    noteProductLinks,
    notePurchaseLinks,
    shoppingLists,
    shoppingListItems,
    reminders,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      Value<String> language,
      Value<int> monthlyBudgetDzd,
      Value<int?> householdSize,
      Value<int> firstDayOfWeek,
      Value<String> currencySymbol,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> language,
      Value<int> monthlyBudgetDzd,
      Value<int?> householdSize,
      Value<int> firstDayOfWeek,
      Value<String> currencySymbol,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
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
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
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

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> monthlyBudgetDzd = const Value.absent(),
                Value<int?> householdSize = const Value.absent(),
                Value<int> firstDayOfWeek = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                language: language,
                monthlyBudgetDzd: monthlyBudgetDzd,
                householdSize: householdSize,
                firstDayOfWeek: firstDayOfWeek,
                currencySymbol: currencySymbol,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> language = const Value.absent(),
                Value<int> monthlyBudgetDzd = const Value.absent(),
                Value<int?> householdSize = const Value.absent(),
                Value<int> firstDayOfWeek = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                language: language,
                monthlyBudgetDzd: monthlyBudgetDzd,
                householdSize: householdSize,
                firstDayOfWeek: firstDayOfWeek,
                currencySymbol: currencySymbol,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String nameEn,
      required String nameFr,
      required String nameAr,
      required String iconKey,
      required String colorHex,
      Value<int?> monthlyBudgetDzd,
      Value<int> sortOrder,
      Value<bool> isSystem,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> nameEn,
      Value<String> nameFr,
      Value<String> nameAr,
      Value<String> iconKey,
      Value<String> colorHex,
      Value<int?> monthlyBudgetDzd,
      Value<int> sortOrder,
      Value<bool> isSystem,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get monthlyBudgetDzd => $composableBuilder(
    column: $table.monthlyBudgetDzd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameFr = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int?> monthlyBudgetDzd = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                nameEn: nameEn,
                nameFr: nameFr,
                nameAr: nameAr,
                iconKey: iconKey,
                colorHex: colorHex,
                monthlyBudgetDzd: monthlyBudgetDzd,
                sortOrder: sortOrder,
                isSystem: isSystem,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameEn,
                required String nameFr,
                required String nameAr,
                required String iconKey,
                required String colorHex,
                Value<int?> monthlyBudgetDzd = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                nameEn: nameEn,
                nameFr: nameFr,
                nameAr: nameAr,
                iconKey: iconKey,
                colorHex: colorHex,
                monthlyBudgetDzd: monthlyBudgetDzd,
                sortOrder: sortOrder,
                isSystem: isSystem,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$StoresTableCreateCompanionBuilder =
    StoresCompanion Function({
      required String id,
      required String name,
      Value<String?> area,
      Value<String?> storeType,
      Value<int?> rating,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$StoresTableUpdateCompanionBuilder =
    StoresCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> area,
      Value<String?> storeType,
      Value<int?> rating,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeType => $composableBuilder(
    column: $table.storeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeType => $composableBuilder(
    column: $table.storeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get storeType =>
      $composableBuilder(column: $table.storeType, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          Store,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
          Store,
          PrefetchHooks Function()
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> storeType = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                name: name,
                area: area,
                storeType: storeType,
                rating: rating,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> area = const Value.absent(),
                Value<String?> storeType = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                name: name,
                area: area,
                storeType: storeType,
                rating: rating,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      Store,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
      Store,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String normalizedName,
      Value<String?> brand,
      Value<String?> variant,
      Value<String?> barcode,
      Value<String?> categoryId,
      Value<String> preferredUnitId,
      Value<double?> packageQuantity,
      Value<String?> packageUnitId,
      Value<int?> lastPriceDzd,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> normalizedName,
      Value<String?> brand,
      Value<String?> variant,
      Value<String?> barcode,
      Value<String?> categoryId,
      Value<String> preferredUnitId,
      Value<double?> packageQuantity,
      Value<String?> packageUnitId,
      Value<int?> lastPriceDzd,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredUnitId => $composableBuilder(
    column: $table.preferredUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageUnitId => $composableBuilder(
    column: $table.packageUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPriceDzd => $composableBuilder(
    column: $table.lastPriceDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredUnitId => $composableBuilder(
    column: $table.preferredUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageUnitId => $composableBuilder(
    column: $table.packageUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPriceDzd => $composableBuilder(
    column: $table.lastPriceDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredUnitId => $composableBuilder(
    column: $table.preferredUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageUnitId => $composableBuilder(
    column: $table.packageUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPriceDzd => $composableBuilder(
    column: $table.lastPriceDzd,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> preferredUnitId = const Value.absent(),
                Value<double?> packageQuantity = const Value.absent(),
                Value<String?> packageUnitId = const Value.absent(),
                Value<int?> lastPriceDzd = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                normalizedName: normalizedName,
                brand: brand,
                variant: variant,
                barcode: barcode,
                categoryId: categoryId,
                preferredUnitId: preferredUnitId,
                packageQuantity: packageQuantity,
                packageUnitId: packageUnitId,
                lastPriceDzd: lastPriceDzd,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String normalizedName,
                Value<String?> brand = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> preferredUnitId = const Value.absent(),
                Value<double?> packageQuantity = const Value.absent(),
                Value<String?> packageUnitId = const Value.absent(),
                Value<int?> lastPriceDzd = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                normalizedName: normalizedName,
                brand: brand,
                variant: variant,
                barcode: barcode,
                categoryId: categoryId,
                preferredUnitId: preferredUnitId,
                packageQuantity: packageQuantity,
                packageUnitId: packageUnitId,
                lastPriceDzd: lastPriceDzd,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$ProductAliasesTableCreateCompanionBuilder =
    ProductAliasesCompanion Function({
      required String id,
      required String productId,
      required String alias,
      required String normalizedAlias,
      Value<String?> languageCode,
      Value<int> rowid,
    });
typedef $$ProductAliasesTableUpdateCompanionBuilder =
    ProductAliasesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> alias,
      Value<String> normalizedAlias,
      Value<String?> languageCode,
      Value<int> rowid,
    });

class $$ProductAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );
}

class $$ProductAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductAliasesTable,
          ProductAliase,
          $$ProductAliasesTableFilterComposer,
          $$ProductAliasesTableOrderingComposer,
          $$ProductAliasesTableAnnotationComposer,
          $$ProductAliasesTableCreateCompanionBuilder,
          $$ProductAliasesTableUpdateCompanionBuilder,
          (
            ProductAliase,
            BaseReferences<_$AppDatabase, $ProductAliasesTable, ProductAliase>,
          ),
          ProductAliase,
          PrefetchHooks Function()
        > {
  $$ProductAliasesTableTableManager(
    _$AppDatabase db,
    $ProductAliasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<String> normalizedAlias = const Value.absent(),
                Value<String?> languageCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductAliasesCompanion(
                id: id,
                productId: productId,
                alias: alias,
                normalizedAlias: normalizedAlias,
                languageCode: languageCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String alias,
                required String normalizedAlias,
                Value<String?> languageCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductAliasesCompanion.insert(
                id: id,
                productId: productId,
                alias: alias,
                normalizedAlias: normalizedAlias,
                languageCode: languageCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductAliasesTable,
      ProductAliase,
      $$ProductAliasesTableFilterComposer,
      $$ProductAliasesTableOrderingComposer,
      $$ProductAliasesTableAnnotationComposer,
      $$ProductAliasesTableCreateCompanionBuilder,
      $$ProductAliasesTableUpdateCompanionBuilder,
      (
        ProductAliase,
        BaseReferences<_$AppDatabase, $ProductAliasesTable, ProductAliase>,
      ),
      ProductAliase,
      PrefetchHooks Function()
    >;
typedef $$ProductConversionsTableCreateCompanionBuilder =
    ProductConversionsCompanion Function({
      required String id,
      required String productId,
      required String fromUnitId,
      required String toUnitId,
      required double factor,
      Value<int> rowid,
    });
typedef $$ProductConversionsTableUpdateCompanionBuilder =
    ProductConversionsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> fromUnitId,
      Value<String> toUnitId,
      Value<double> factor,
      Value<int> rowid,
    });

class $$ProductConversionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductConversionsTable> {
  $$ProductConversionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromUnitId => $composableBuilder(
    column: $table.fromUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toUnitId => $composableBuilder(
    column: $table.toUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductConversionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductConversionsTable> {
  $$ProductConversionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromUnitId => $composableBuilder(
    column: $table.fromUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toUnitId => $composableBuilder(
    column: $table.toUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductConversionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductConversionsTable> {
  $$ProductConversionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get fromUnitId => $composableBuilder(
    column: $table.fromUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toUnitId =>
      $composableBuilder(column: $table.toUnitId, builder: (column) => column);

  GeneratedColumn<double> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);
}

class $$ProductConversionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductConversionsTable,
          ProductConversion,
          $$ProductConversionsTableFilterComposer,
          $$ProductConversionsTableOrderingComposer,
          $$ProductConversionsTableAnnotationComposer,
          $$ProductConversionsTableCreateCompanionBuilder,
          $$ProductConversionsTableUpdateCompanionBuilder,
          (
            ProductConversion,
            BaseReferences<
              _$AppDatabase,
              $ProductConversionsTable,
              ProductConversion
            >,
          ),
          ProductConversion,
          PrefetchHooks Function()
        > {
  $$ProductConversionsTableTableManager(
    _$AppDatabase db,
    $ProductConversionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductConversionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductConversionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductConversionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> fromUnitId = const Value.absent(),
                Value<String> toUnitId = const Value.absent(),
                Value<double> factor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductConversionsCompanion(
                id: id,
                productId: productId,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                factor: factor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String fromUnitId,
                required String toUnitId,
                required double factor,
                Value<int> rowid = const Value.absent(),
              }) => ProductConversionsCompanion.insert(
                id: id,
                productId: productId,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                factor: factor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductConversionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductConversionsTable,
      ProductConversion,
      $$ProductConversionsTableFilterComposer,
      $$ProductConversionsTableOrderingComposer,
      $$ProductConversionsTableAnnotationComposer,
      $$ProductConversionsTableCreateCompanionBuilder,
      $$ProductConversionsTableUpdateCompanionBuilder,
      (
        ProductConversion,
        BaseReferences<
          _$AppDatabase,
          $ProductConversionsTable,
          ProductConversion
        >,
      ),
      ProductConversion,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      required String id,
      required String productId,
      Value<String?> storeId,
      Value<String?> tripId,
      required double quantity,
      required String unitId,
      required int priceDzd,
      Value<bool> isUnitPrice,
      required int totalDzd,
      Value<double?> normalizedBaseQuantity,
      Value<double?> normalizedDzdPerBaseUnit,
      required DateTime purchasedAt,
      required String localDate,
      Value<String?> note,
      Value<DateTime?> expiryDate,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String?> storeId,
      Value<String?> tripId,
      Value<double> quantity,
      Value<String> unitId,
      Value<int> priceDzd,
      Value<bool> isUnitPrice,
      Value<int> totalDzd,
      Value<double?> normalizedBaseQuantity,
      Value<double?> normalizedDzdPerBaseUnit,
      Value<DateTime> purchasedAt,
      Value<String> localDate,
      Value<String?> note,
      Value<DateTime?> expiryDate,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceDzd => $composableBuilder(
    column: $table.priceDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnitPrice => $composableBuilder(
    column: $table.isUnitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDzd => $composableBuilder(
    column: $table.totalDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalizedBaseQuantity => $composableBuilder(
    column: $table.normalizedBaseQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalizedDzdPerBaseUnit => $composableBuilder(
    column: $table.normalizedDzdPerBaseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceDzd => $composableBuilder(
    column: $table.priceDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnitPrice => $composableBuilder(
    column: $table.isUnitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDzd => $composableBuilder(
    column: $table.totalDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalizedBaseQuantity => $composableBuilder(
    column: $table.normalizedBaseQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalizedDzdPerBaseUnit => $composableBuilder(
    column: $table.normalizedDzdPerBaseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get priceDzd =>
      $composableBuilder(column: $table.priceDzd, builder: (column) => column);

  GeneratedColumn<bool> get isUnitPrice => $composableBuilder(
    column: $table.isUnitPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDzd =>
      $composableBuilder(column: $table.totalDzd, builder: (column) => column);

  GeneratedColumn<double> get normalizedBaseQuantity => $composableBuilder(
    column: $table.normalizedBaseQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get normalizedDzdPerBaseUnit => $composableBuilder(
    column: $table.normalizedDzdPerBaseUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
          Purchase,
          PrefetchHooks Function()
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String?> tripId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int> priceDzd = const Value.absent(),
                Value<bool> isUnitPrice = const Value.absent(),
                Value<int> totalDzd = const Value.absent(),
                Value<double?> normalizedBaseQuantity = const Value.absent(),
                Value<double?> normalizedDzdPerBaseUnit = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                productId: productId,
                storeId: storeId,
                tripId: tripId,
                quantity: quantity,
                unitId: unitId,
                priceDzd: priceDzd,
                isUnitPrice: isUnitPrice,
                totalDzd: totalDzd,
                normalizedBaseQuantity: normalizedBaseQuantity,
                normalizedDzdPerBaseUnit: normalizedDzdPerBaseUnit,
                purchasedAt: purchasedAt,
                localDate: localDate,
                note: note,
                expiryDate: expiryDate,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                Value<String?> storeId = const Value.absent(),
                Value<String?> tripId = const Value.absent(),
                required double quantity,
                required String unitId,
                required int priceDzd,
                Value<bool> isUnitPrice = const Value.absent(),
                required int totalDzd,
                Value<double?> normalizedBaseQuantity = const Value.absent(),
                Value<double?> normalizedDzdPerBaseUnit = const Value.absent(),
                required DateTime purchasedAt,
                required String localDate,
                Value<String?> note = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                productId: productId,
                storeId: storeId,
                tripId: tripId,
                quantity: quantity,
                unitId: unitId,
                priceDzd: priceDzd,
                isUnitPrice: isUnitPrice,
                totalDzd: totalDzd,
                normalizedBaseQuantity: normalizedBaseQuantity,
                normalizedDzdPerBaseUnit: normalizedDzdPerBaseUnit,
                purchasedAt: purchasedAt,
                localDate: localDate,
                note: note,
                expiryDate: expiryDate,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
      Purchase,
      PrefetchHooks Function()
    >;
typedef $$LaterBuyItemsTableCreateCompanionBuilder =
    LaterBuyItemsCompanion Function({
      required String id,
      required String productId,
      required int observedPriceDzd,
      required double observedQuantity,
      required String observedUnitId,
      Value<int?> targetPriceDzd,
      Value<String?> storeId,
      Value<String> reason,
      Value<String> status,
      Value<DateTime?> reminderAt,
      Value<String?> resolvedPurchaseId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> resolvedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LaterBuyItemsTableUpdateCompanionBuilder =
    LaterBuyItemsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<int> observedPriceDzd,
      Value<double> observedQuantity,
      Value<String> observedUnitId,
      Value<int?> targetPriceDzd,
      Value<String?> storeId,
      Value<String> reason,
      Value<String> status,
      Value<DateTime?> reminderAt,
      Value<String?> resolvedPurchaseId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> resolvedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LaterBuyItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LaterBuyItemsTable> {
  $$LaterBuyItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get observedPriceDzd => $composableBuilder(
    column: $table.observedPriceDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get observedQuantity => $composableBuilder(
    column: $table.observedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observedUnitId => $composableBuilder(
    column: $table.observedUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPriceDzd => $composableBuilder(
    column: $table.targetPriceDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolvedPurchaseId => $composableBuilder(
    column: $table.resolvedPurchaseId,
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

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LaterBuyItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LaterBuyItemsTable> {
  $$LaterBuyItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get observedPriceDzd => $composableBuilder(
    column: $table.observedPriceDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get observedQuantity => $composableBuilder(
    column: $table.observedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observedUnitId => $composableBuilder(
    column: $table.observedUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPriceDzd => $composableBuilder(
    column: $table.targetPriceDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolvedPurchaseId => $composableBuilder(
    column: $table.resolvedPurchaseId,
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

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LaterBuyItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LaterBuyItemsTable> {
  $$LaterBuyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get observedPriceDzd => $composableBuilder(
    column: $table.observedPriceDzd,
    builder: (column) => column,
  );

  GeneratedColumn<double> get observedQuantity => $composableBuilder(
    column: $table.observedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observedUnitId => $composableBuilder(
    column: $table.observedUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetPriceDzd => $composableBuilder(
    column: $table.targetPriceDzd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolvedPurchaseId => $composableBuilder(
    column: $table.resolvedPurchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LaterBuyItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LaterBuyItemsTable,
          LaterBuyItem,
          $$LaterBuyItemsTableFilterComposer,
          $$LaterBuyItemsTableOrderingComposer,
          $$LaterBuyItemsTableAnnotationComposer,
          $$LaterBuyItemsTableCreateCompanionBuilder,
          $$LaterBuyItemsTableUpdateCompanionBuilder,
          (
            LaterBuyItem,
            BaseReferences<_$AppDatabase, $LaterBuyItemsTable, LaterBuyItem>,
          ),
          LaterBuyItem,
          PrefetchHooks Function()
        > {
  $$LaterBuyItemsTableTableManager(_$AppDatabase db, $LaterBuyItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LaterBuyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LaterBuyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LaterBuyItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> observedPriceDzd = const Value.absent(),
                Value<double> observedQuantity = const Value.absent(),
                Value<String> observedUnitId = const Value.absent(),
                Value<int?> targetPriceDzd = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<String?> resolvedPurchaseId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LaterBuyItemsCompanion(
                id: id,
                productId: productId,
                observedPriceDzd: observedPriceDzd,
                observedQuantity: observedQuantity,
                observedUnitId: observedUnitId,
                targetPriceDzd: targetPriceDzd,
                storeId: storeId,
                reason: reason,
                status: status,
                reminderAt: reminderAt,
                resolvedPurchaseId: resolvedPurchaseId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                resolvedAt: resolvedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required int observedPriceDzd,
                required double observedQuantity,
                required String observedUnitId,
                Value<int?> targetPriceDzd = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<String?> resolvedPurchaseId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LaterBuyItemsCompanion.insert(
                id: id,
                productId: productId,
                observedPriceDzd: observedPriceDzd,
                observedQuantity: observedQuantity,
                observedUnitId: observedUnitId,
                targetPriceDzd: targetPriceDzd,
                storeId: storeId,
                reason: reason,
                status: status,
                reminderAt: reminderAt,
                resolvedPurchaseId: resolvedPurchaseId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                resolvedAt: resolvedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LaterBuyItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LaterBuyItemsTable,
      LaterBuyItem,
      $$LaterBuyItemsTableFilterComposer,
      $$LaterBuyItemsTableOrderingComposer,
      $$LaterBuyItemsTableAnnotationComposer,
      $$LaterBuyItemsTableCreateCompanionBuilder,
      $$LaterBuyItemsTableUpdateCompanionBuilder,
      (
        LaterBuyItem,
        BaseReferences<_$AppDatabase, $LaterBuyItemsTable, LaterBuyItem>,
      ),
      LaterBuyItem,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String title,
      required String body,
      Value<String> noteType,
      required DateTime eventAt,
      required String localDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> body,
      Value<String> noteType,
      Value<DateTime> eventAt,
      Value<String> localDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventAt => $composableBuilder(
    column: $table.eventAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventAt => $composableBuilder(
    column: $table.eventAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get noteType =>
      $composableBuilder(column: $table.noteType, builder: (column) => column);

  GeneratedColumn<DateTime> get eventAt =>
      $composableBuilder(column: $table.eventAt, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> noteType = const Value.absent(),
                Value<DateTime> eventAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                body: body,
                noteType: noteType,
                eventAt: eventAt,
                localDate: localDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String body,
                Value<String> noteType = const Value.absent(),
                required DateTime eventAt,
                required String localDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                body: body,
                noteType: noteType,
                eventAt: eventAt,
                localDate: localDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$NoteTagsTableCreateCompanionBuilder =
    NoteTagsCompanion Function({
      required String id,
      required String noteId,
      required String tag,
      Value<int> rowid,
    });
typedef $$NoteTagsTableUpdateCompanionBuilder =
    NoteTagsCompanion Function({
      Value<String> id,
      Value<String> noteId,
      Value<String> tag,
      Value<int> rowid,
    });

class $$NoteTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$NoteTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteTagsTable,
          NoteTag,
          $$NoteTagsTableFilterComposer,
          $$NoteTagsTableOrderingComposer,
          $$NoteTagsTableAnnotationComposer,
          $$NoteTagsTableCreateCompanionBuilder,
          $$NoteTagsTableUpdateCompanionBuilder,
          (NoteTag, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag>),
          NoteTag,
          PrefetchHooks Function()
        > {
  $$NoteTagsTableTableManager(_$AppDatabase db, $NoteTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<String> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteTagsCompanion(
                id: id,
                noteId: noteId,
                tag: tag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String noteId,
                required String tag,
                Value<int> rowid = const Value.absent(),
              }) => NoteTagsCompanion.insert(
                id: id,
                noteId: noteId,
                tag: tag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteTagsTable,
      NoteTag,
      $$NoteTagsTableFilterComposer,
      $$NoteTagsTableOrderingComposer,
      $$NoteTagsTableAnnotationComposer,
      $$NoteTagsTableCreateCompanionBuilder,
      $$NoteTagsTableUpdateCompanionBuilder,
      (NoteTag, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag>),
      NoteTag,
      PrefetchHooks Function()
    >;
typedef $$NoteProductLinksTableCreateCompanionBuilder =
    NoteProductLinksCompanion Function({
      required String noteId,
      required String productId,
      Value<int> rowid,
    });
typedef $$NoteProductLinksTableUpdateCompanionBuilder =
    NoteProductLinksCompanion Function({
      Value<String> noteId,
      Value<String> productId,
      Value<int> rowid,
    });

class $$NoteProductLinksTableFilterComposer
    extends Composer<_$AppDatabase, $NoteProductLinksTable> {
  $$NoteProductLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteProductLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteProductLinksTable> {
  $$NoteProductLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteProductLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteProductLinksTable> {
  $$NoteProductLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);
}

class $$NoteProductLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteProductLinksTable,
          NoteProductLink,
          $$NoteProductLinksTableFilterComposer,
          $$NoteProductLinksTableOrderingComposer,
          $$NoteProductLinksTableAnnotationComposer,
          $$NoteProductLinksTableCreateCompanionBuilder,
          $$NoteProductLinksTableUpdateCompanionBuilder,
          (
            NoteProductLink,
            BaseReferences<
              _$AppDatabase,
              $NoteProductLinksTable,
              NoteProductLink
            >,
          ),
          NoteProductLink,
          PrefetchHooks Function()
        > {
  $$NoteProductLinksTableTableManager(
    _$AppDatabase db,
    $NoteProductLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteProductLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteProductLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteProductLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteProductLinksCompanion(
                noteId: noteId,
                productId: productId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String productId,
                Value<int> rowid = const Value.absent(),
              }) => NoteProductLinksCompanion.insert(
                noteId: noteId,
                productId: productId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteProductLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteProductLinksTable,
      NoteProductLink,
      $$NoteProductLinksTableFilterComposer,
      $$NoteProductLinksTableOrderingComposer,
      $$NoteProductLinksTableAnnotationComposer,
      $$NoteProductLinksTableCreateCompanionBuilder,
      $$NoteProductLinksTableUpdateCompanionBuilder,
      (
        NoteProductLink,
        BaseReferences<_$AppDatabase, $NoteProductLinksTable, NoteProductLink>,
      ),
      NoteProductLink,
      PrefetchHooks Function()
    >;
typedef $$NotePurchaseLinksTableCreateCompanionBuilder =
    NotePurchaseLinksCompanion Function({
      required String noteId,
      required String purchaseId,
      Value<int> rowid,
    });
typedef $$NotePurchaseLinksTableUpdateCompanionBuilder =
    NotePurchaseLinksCompanion Function({
      Value<String> noteId,
      Value<String> purchaseId,
      Value<int> rowid,
    });

class $$NotePurchaseLinksTableFilterComposer
    extends Composer<_$AppDatabase, $NotePurchaseLinksTable> {
  $$NotePurchaseLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotePurchaseLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $NotePurchaseLinksTable> {
  $$NotePurchaseLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotePurchaseLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotePurchaseLinksTable> {
  $$NotePurchaseLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );
}

class $$NotePurchaseLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotePurchaseLinksTable,
          NotePurchaseLink,
          $$NotePurchaseLinksTableFilterComposer,
          $$NotePurchaseLinksTableOrderingComposer,
          $$NotePurchaseLinksTableAnnotationComposer,
          $$NotePurchaseLinksTableCreateCompanionBuilder,
          $$NotePurchaseLinksTableUpdateCompanionBuilder,
          (
            NotePurchaseLink,
            BaseReferences<
              _$AppDatabase,
              $NotePurchaseLinksTable,
              NotePurchaseLink
            >,
          ),
          NotePurchaseLink,
          PrefetchHooks Function()
        > {
  $$NotePurchaseLinksTableTableManager(
    _$AppDatabase db,
    $NotePurchaseLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotePurchaseLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotePurchaseLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotePurchaseLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotePurchaseLinksCompanion(
                noteId: noteId,
                purchaseId: purchaseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String purchaseId,
                Value<int> rowid = const Value.absent(),
              }) => NotePurchaseLinksCompanion.insert(
                noteId: noteId,
                purchaseId: purchaseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotePurchaseLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotePurchaseLinksTable,
      NotePurchaseLink,
      $$NotePurchaseLinksTableFilterComposer,
      $$NotePurchaseLinksTableOrderingComposer,
      $$NotePurchaseLinksTableAnnotationComposer,
      $$NotePurchaseLinksTableCreateCompanionBuilder,
      $$NotePurchaseLinksTableUpdateCompanionBuilder,
      (
        NotePurchaseLink,
        BaseReferences<
          _$AppDatabase,
          $NotePurchaseLinksTable,
          NotePurchaseLink
        >,
      ),
      NotePurchaseLink,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      required String id,
      required String title,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingList,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (
            ShoppingList,
            BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList>,
          ),
          ShoppingList,
          PrefetchHooks Function()
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                title: title,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                title: title,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingList,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (
        ShoppingList,
        BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList>,
      ),
      ShoppingList,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      required String id,
      required String listId,
      Value<String?> productId,
      required String customName,
      Value<double> quantity,
      Value<String> unitId,
      Value<int?> estimatedPriceDzd,
      Value<bool> isCompleted,
      Value<String?> convertedPurchaseId,
      Value<int> rowid,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<String> id,
      Value<String> listId,
      Value<String?> productId,
      Value<String> customName,
      Value<double> quantity,
      Value<String> unitId,
      Value<int?> estimatedPriceDzd,
      Value<bool> isCompleted,
      Value<String?> convertedPurchaseId,
      Value<int> rowid,
    });

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPriceDzd => $composableBuilder(
    column: $table.estimatedPriceDzd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get convertedPurchaseId => $composableBuilder(
    column: $table.convertedPurchaseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPriceDzd => $composableBuilder(
    column: $table.estimatedPriceDzd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get convertedPurchaseId => $composableBuilder(
    column: $table.convertedPurchaseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get estimatedPriceDzd => $composableBuilder(
    column: $table.estimatedPriceDzd,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get convertedPurchaseId => $composableBuilder(
    column: $table.convertedPurchaseId,
    builder: (column) => column,
  );
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (
            ShoppingListItem,
            BaseReferences<
              _$AppDatabase,
              $ShoppingListItemsTable,
              ShoppingListItem
            >,
          ),
          ShoppingListItem,
          PrefetchHooks Function()
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> customName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int?> estimatedPriceDzd = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> convertedPurchaseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                listId: listId,
                productId: productId,
                customName: customName,
                quantity: quantity,
                unitId: unitId,
                estimatedPriceDzd: estimatedPriceDzd,
                isCompleted: isCompleted,
                convertedPurchaseId: convertedPurchaseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                Value<String?> productId = const Value.absent(),
                required String customName,
                Value<double> quantity = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int?> estimatedPriceDzd = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> convertedPurchaseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                listId: listId,
                productId: productId,
                customName: customName,
                quantity: quantity,
                unitId: unitId,
                estimatedPriceDzd: estimatedPriceDzd,
                isCompleted: isCompleted,
                convertedPurchaseId: convertedPurchaseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItem,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (
        ShoppingListItem,
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem
        >,
      ),
      ShoppingListItem,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String relatedType,
      required String relatedId,
      required DateTime scheduledAt,
      required int localNotificationId,
      Value<bool> isEnabled,
      Value<DateTime?> deliveredAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> relatedType,
      Value<String> relatedId,
      Value<DateTime> scheduledAt,
      Value<int> localNotificationId,
      Value<bool> isEnabled,
      Value<DateTime?> deliveredAt,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedType => $composableBuilder(
    column: $table.relatedType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localNotificationId => $composableBuilder(
    column: $table.localNotificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedType => $composableBuilder(
    column: $table.relatedType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedId => $composableBuilder(
    column: $table.relatedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localNotificationId => $composableBuilder(
    column: $table.localNotificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relatedType => $composableBuilder(
    column: $table.relatedType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedId =>
      $composableBuilder(column: $table.relatedId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localNotificationId => $composableBuilder(
    column: $table.localNotificationId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> relatedType = const Value.absent(),
                Value<String> relatedId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int> localNotificationId = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                relatedType: relatedType,
                relatedId: relatedId,
                scheduledAt: scheduledAt,
                localNotificationId: localNotificationId,
                isEnabled: isEnabled,
                deliveredAt: deliveredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String relatedType,
                required String relatedId,
                required DateTime scheduledAt,
                required int localNotificationId,
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                relatedType: relatedType,
                relatedId: relatedId,
                scheduledAt: scheduledAt,
                localNotificationId: localNotificationId,
                isEnabled: isEnabled,
                deliveredAt: deliveredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductAliasesTableTableManager get productAliases =>
      $$ProductAliasesTableTableManager(_db, _db.productAliases);
  $$ProductConversionsTableTableManager get productConversions =>
      $$ProductConversionsTableTableManager(_db, _db.productConversions);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$LaterBuyItemsTableTableManager get laterBuyItems =>
      $$LaterBuyItemsTableTableManager(_db, _db.laterBuyItems);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db, _db.noteTags);
  $$NoteProductLinksTableTableManager get noteProductLinks =>
      $$NoteProductLinksTableTableManager(_db, _db.noteProductLinks);
  $$NotePurchaseLinksTableTableManager get notePurchaseLinks =>
      $$NotePurchaseLinksTableTableManager(_db, _db.notePurchaseLinks);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
