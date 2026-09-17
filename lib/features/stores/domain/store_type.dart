import 'package:flutter/material.dart';

enum StoreType {
  grocery(
    id: 'grocery',
    nameEn: 'Grocery / General store',
    nameFr: 'Alimentation générale',
    nameAr: 'بقالة - مواد غذائية',
    icon: Icons.storefront_rounded,
  ),
  vegetablesFruits(
    id: 'vegetables_fruits',
    nameEn: 'Vegetables & Fruits',
    nameFr: 'Fruits & Légumes',
    nameAr: 'خضار وفواكه',
    icon: Icons.eco_rounded,
  ),
  butcher(
    id: 'butcher',
    nameEn: 'Butcher shop',
    nameFr: 'Boucherie',
    nameAr: 'جزار - قصاب',
    icon: Icons.restaurant_menu_rounded,
  ),
  supermarket(
    id: 'supermarket',
    nameEn: 'Supermarket / Supérette',
    nameFr: 'Supermarché / Supérette',
    nameAr: 'سوبرماركت - سوبيرات',
    icon: Icons.shopping_cart_rounded,
  ),
  bakery(
    id: 'bakery',
    nameEn: 'Bakery & Pastry',
    nameFr: 'Boulangerie - Pâtisserie',
    nameAr: 'مخبزة وحلويات',
    icon: Icons.bakery_dining_rounded,
  ),
  dairy(
    id: 'dairy',
    nameEn: 'Dairy & Creamery',
    nameFr: 'Crèmerie - Mahlaba',
    nameAr: 'ألبان وأجبان - محلبة',
    icon: Icons.egg_rounded,
  ),
  fishmonger(
    id: 'fishmonger',
    nameEn: 'Fishmonger',
    nameFr: 'Poissonnerie',
    nameAr: 'سماك - بيع الأسماك',
    icon: Icons.set_meal_rounded,
  ),
  poultry(
    id: 'poultry',
    nameEn: 'Poultry & Eggs',
    nameFr: 'Volailler & Œufs',
    nameAr: 'دواجن وبيض',
    icon: Icons.egg_alt_rounded,
  ),
  spices(
    id: 'spices',
    nameEn: 'Spices & Herbs (Attar)',
    nameFr: 'Épices & Attar',
    nameAr: 'عطار - توابل وأعشاب',
    icon: Icons.spa_rounded,
  ),
  wholesale(
    id: 'wholesale',
    nameEn: 'Wholesale / Semi-wholesale',
    nameFr: 'Semi-grossiste / Gros',
    nameAr: 'نصف الجملة - جملة',
    icon: Icons.inventory_2_rounded,
  ),
  roastery(
    id: 'roastery',
    nameEn: 'Nuts & Roastery',
    nameFr: 'Torréfaction & Fruits secs',
    nameAr: 'محمصة ومكسرات',
    icon: Icons.grain_rounded,
  );

  const StoreType({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.nameAr,
    required this.icon,
  });

  final String id;
  final String nameEn;
  final String nameFr;
  final String nameAr;
  final IconData icon;

  String localizedName(String langCode) {
    switch (langCode) {
      case 'fr':
        return nameFr;
      case 'en':
        return nameEn;
      case 'ar':
      default:
        return nameAr;
    }
  }

  static StoreType? fromId(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final type in StoreType.values) {
      if (type.id == id) return type;
    }
    return null;
  }

  static StoreType fromIdOrFallback(String? id) {
    return fromId(id) ?? StoreType.grocery;
  }
}
