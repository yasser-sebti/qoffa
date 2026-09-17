import 'package:drift/drift.dart';

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get language => text().withDefault(const Constant('ar'))();
  IntColumn get monthlyBudgetDzd =>
      integer().withDefault(const Constant(50000))();
  IntColumn get householdSize => integer().nullable()();
  IntColumn get firstDayOfWeek =>
      integer().withDefault(const Constant(7))(); // 7 = Sunday
  TextColumn get currencySymbol => text().withDefault(const Constant('DA'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameFr => text()();
  TextColumn get nameAr => text()();
  TextColumn get iconKey => text()();
  TextColumn get colorHex => text()();
  IntColumn get monthlyBudgetDzd => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Stores extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get area => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get normalizedName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get variant => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get preferredUnitId => text().withDefault(const Constant('kg'))();
  RealColumn get packageQuantity => real().nullable()();
  TextColumn get packageUnitId => text().nullable()();
  IntColumn get lastPriceDzd => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProductAliases extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get alias => text()();
  TextColumn get normalizedAlias => text()();
  TextColumn get languageCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProductConversions extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get fromUnitId => text()();
  TextColumn get toUnitId => text()();
  RealColumn get factor => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class Purchases extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get storeId => text().nullable().references(Stores, #id)();
  TextColumn get tripId => text().nullable()();
  RealColumn get quantity => real()();
  TextColumn get unitId => text()();
  IntColumn get priceDzd => integer()();
  BoolColumn get isUnitPrice => boolean().withDefault(const Constant(false))();
  IntColumn get totalDzd => integer()();
  RealColumn get normalizedBaseQuantity => real().nullable()();
  RealColumn get normalizedDzdPerBaseUnit => real().nullable()();
  DateTimeColumn get purchasedAt => dateTime()();
  TextColumn get localDate => text()(); // Format: YYYY-MM-DD
  TextColumn get note => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LaterBuyItems extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get observedPriceDzd => integer()();
  RealColumn get observedQuantity => real()();
  TextColumn get observedUnitId => text()();
  IntColumn get targetPriceDzd => integer().nullable()();
  TextColumn get storeId => text().nullable().references(Stores, #id)();
  TextColumn get reason => text().withDefault(
    const Constant('expensive'),
  )(); // expensive, not_urgent, compare_elsewhere
  TextColumn get status => text().withDefault(
    const Constant('active'),
  )(); // active, bought, skipped, dismissed, expired
  DateTimeColumn get reminderAt => dateTime().nullable()();
  TextColumn get resolvedPurchaseId =>
      text().nullable().references(Purchases, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get noteType => text().withDefault(const Constant('food_diary'))();
  DateTimeColumn get eventAt => dateTime()();
  TextColumn get localDate => text()(); // Format: YYYY-MM-DD
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteTags extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().references(Notes, #id)();
  TextColumn get tag => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteProductLinks extends Table {
  TextColumn get noteId => text().references(Notes, #id)();
  TextColumn get productId => text().references(Products, #id)();

  @override
  Set<Column> get primaryKey => {noteId, productId};
}

class NotePurchaseLinks extends Table {
  TextColumn get noteId => text().references(Notes, #id)();
  TextColumn get purchaseId => text().references(Purchases, #id)();

  @override
  Set<Column> get primaryKey => {noteId, purchaseId};
}

class ShoppingLists extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingListItems extends Table {
  TextColumn get id => text()();
  TextColumn get listId => text().references(ShoppingLists, #id)();
  TextColumn get productId => text().nullable().references(Products, #id)();
  TextColumn get customName => text()();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get unitId => text().withDefault(const Constant('piece'))();
  IntColumn get estimatedPriceDzd => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get convertedPurchaseId =>
      text().nullable().references(Purchases, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get relatedType =>
      text()(); // later_buy, recurring, budget, expiry
  TextColumn get relatedId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get localNotificationId => integer()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
