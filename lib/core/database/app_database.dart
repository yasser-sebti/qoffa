import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Profiles,
  Categories,
  Stores,
  Products,
  ProductAliases,
  ProductConversions,
  Purchases,
  LaterBuyItems,
  Notes,
  NoteTags,
  NoteProductLinks,
  NotePurchaseLinks,
  ShoppingLists,
  ShoppingListItems,
  Reminders,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'qoffa_local');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Seed default initial categories and profile
        await _seedInitialData();
      },
    );
  }

  Future<void> _seedInitialData() async {
    final now = DateTime.now().toUtc();
    const uuid = Uuid();

    // Default Profile
    await into(profiles).insert(
      ProfilesCompanion.insert(
        id: uuid.v4(),
        language: const Value('ar'),
        monthlyBudgetDzd: const Value(60000),
        firstDayOfWeek: const Value(7), // Sunday
        currencySymbol: const Value('DA'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Initial Categories
    final initialCategories = [
      (
        id: 'cat_produce',
        en: 'Fresh Produce',
        fr: 'Fruits & Légumes',
        ar: 'خضر وفواكه',
        icon: 'apple',
        color: '#22C98D',
        order: 1,
      ),
      (
        id: 'cat_meat',
        en: 'Meat & Poultry',
        fr: 'Viandes & Volailles',
        ar: 'لحوم ودواجن',
        icon: 'meat',
        color: '#FF6264',
        order: 2,
      ),
      (
        id: 'cat_dairy',
        en: 'Dairy & Eggs',
        fr: 'Produits Laitiers & Œufs',
        ar: 'حليب ومشتقاته وبيض',
        icon: 'egg',
        color: '#FFB416',
        order: 3,
      ),
      (
        id: 'cat_bakery',
        en: 'Bakery & Grains',
        fr: 'Boulangerie & Céréales',
        ar: 'مخبوزات وحبوب',
        icon: 'bread',
        color: '#D97706',
        order: 4,
      ),
      (
        id: 'cat_pantry',
        en: 'Pantry & Oil',
        fr: 'Épicerie & Huile',
        ar: 'بقالة وزيوت',
        icon: 'drop',
        color: '#0877EC',
        order: 5,
      ),
      (
        id: 'cat_beverages',
        en: 'Beverages',
        fr: 'Boissons',
        ar: 'مشروبات',
        icon: 'coffee',
        color: '#8B5CF6',
        order: 6,
      ),
      (
        id: 'cat_cleaning',
        en: 'Cleaning & Household',
        fr: 'Entretien & Ménage',
        ar: 'مواد التنظيف',
        icon: 'sparkle',
        color: '#06B6D4',
        order: 7,
      ),
      (
        id: 'cat_other',
        en: 'Other Essentials',
        fr: 'Autres Essentiels',
        ar: 'أخرى',
        icon: 'package',
        color: '#6E857A',
        order: 8,
      ),
    ];

    for (final c in initialCategories) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: c.id,
          nameEn: c.en,
          nameFr: c.fr,
          nameAr: c.ar,
          iconKey: c.icon,
          colorHex: c.color,
          sortOrder: Value(c.order),
          isSystem: const Value(true),
        ),
      );
    }
  }
}
