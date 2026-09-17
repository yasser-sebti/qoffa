import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  static const supportedLocales = [
    Locale('ar'),
    Locale('fr'),
    Locale('en'),
  ];

  String get appTitle => _localizedValue('Qoffa · قفة', 'Qoffa', 'Qoffa');

  // Bottom Navigation
  String get navHome => _localizedValue('الرئيسية', 'Accueil', 'Home');
  String get navCalendar => _localizedValue('التقويم', 'Calendrier', 'Calendar');
  String get navAdd => _localizedValue('إضافة', 'Ajouter', 'Add');
  String get navLaterBuy => _localizedValue('شراء لاحقاً', 'Acheter Plus Tard', 'Later Buy');
  String get navNotebook => _localizedValue('الملاحظات', 'Carnet', 'Notebook');

  // Home Screen
  String get greetingMorning => _localizedValue('صباح الخير،', 'Bonjour,', 'Good morning,');
  String get subtitleHome => _localizedValue('دعنا نتابع مصاريف قفتك اليوم', 'Suivons vos courses aujourd\'hui', 'Let\'s keep track of your groceries');
  String get monthlyBudget => _localizedValue('ميزانية الشهر', 'Budget Mensuel', 'Monthly Budget');
  String get spent => _localizedValue('المصروف', 'dépensé', 'spent');
  String get remaining => _localizedValue('المتبقي', 'restant', 'remaining');
  String get projected => _localizedValue('المتوقع نهاية الشهر:', 'Projeté à la fin du mois :', 'Projected month-end:');
  String get fasterThanLastMonth => _localizedValue('أسرع من الشهر الماضي', 'plus rapide que le mois dernier', 'faster than last month');
  String get highestCategory => _localizedValue('الفئة الأعلى استهلاكاً', 'Catégorie principale', 'highest category');
  String get ofYourSpending => _localizedValue('من مجموع المصاريف', 'de vos dépenses', 'of your spending');
  String get recentActivity => _localizedValue('آخر المشتريات', 'Activité Récente', 'Recent Activity');
  String get seeAll => _localizedValue('عرض الكل', 'Voir tout', 'See All');
  String get noPurchasesYet => _localizedValue('لم تسجل أي مشتريات هذا الشهر بعد', 'Aucun achat enregistré ce mois-ci', 'No purchases recorded this month yet');
  String get addFirstPurchase => _localizedValue('أضف أول شراء', 'Ajouter un premier achat', 'Add first purchase');

  // Add Purchase
  String get addPurchaseTitle => _localizedValue('تسجيل شراء', 'Ajouter un achat', 'Add purchase');
  String get addPurchaseSubtitle => _localizedValue('سجله في ثوانٍ معدودة', 'Enregistrez-le en quelques secondes', 'Record it in seconds');
  String get productName => _localizedValue('اسم المنتج', 'Nom du produit', 'Product name');
  String get productSearchPlaceholder => _localizedValue('ابحث أو اكتب منتجاً جديداً...', 'Rechercher ou nouveau produit...', 'Search or type new product...');
  String get lastPrice => _localizedValue('آخر سعر', 'Dernier prix', 'Last price');
  String get todayDiff => _localizedValue('اليوم', 'Aujourd\'hui', 'Today');
  String get quantity => _localizedValue('الكمية', 'Quantité', 'Quantity');
  String get unit => _localizedValue('الوحدة', 'Unité', 'Unit');
  String get pricePerUnit => _localizedValue('سعر الوحدة', 'Prix unitaire', 'Price per unit');
  String get totalPrice => _localizedValue('السعر الإجمالي', 'Prix total', 'Total price');
  String get store => _localizedValue('المحل / السوق', 'Magasin / Marché', 'Store');
  String get storeDefault => _localizedValue('محل الحي', 'Épicerie du quartier', 'Local shop');
  String get date => _localizedValue('التاريخ', 'Date', 'Date');
  String get boughtAction => _localizedValue('تم الشراء', 'Acheté', 'Bought');
  String get buyLaterAction => _localizedValue('شراء لاحقاً', 'Acheter plus tard', 'Buy later');
  String get addToListAction => _localizedValue('إضافة للقائمة', 'Ajouter à la liste', 'Add to list');
  String get quickAddStaples => _localizedValue('منتجات شائعة', 'Produits fréquents', 'Add something else? Quick add');

  // Later Buy
  String get laterBuyTitle => _localizedValue('شراء لاحقاً', 'Acheter plus tard', 'Later Buy');
  String get laterBuySubtitle => _localizedValue('انتظر سعراً أفضل', 'Attendez un meilleur prix', 'Wait for a better price');
  String get pendingCount => _localizedValue('قيد الانتظار', 'en attente', 'pending');
  String get tabActive => _localizedValue('النشطة', 'Actif', 'Active');
  String get tabBought => _localizedValue('تم شراؤها', 'Acheté', 'Bought');
  String get tabSkipped => _localizedValue('تم التخطي', 'Ignoré', 'Skipped');
  String get observedPrice => _localizedValue('السعر المرصود', 'Prix observé', 'Observed Price');
  String get targetPrice => _localizedValue('السعر المستهدف', 'Prix cible', 'Target Price');
  String get reminder => _localizedValue('تذكير', 'Rappel', 'Reminder');
  String get wasItWorthWaiting => _localizedValue('هل كان الانتظار مجدياً؟', 'Attendre valait-il la peine ?', 'Was it worth waiting?');

  // Calendar
  String get calendarTitle => _localizedValue('التقويم', 'Calendrier', 'Calendar');
  String get calendarSubtitle => _localizedValue('متابعة مصاريف الشهر يوماً بيوم', 'Suivez vos dépenses au jour le jour', 'Track your grocery spending');
  String get legendPurchase => _localizedValue('شراء', 'Achat', 'Purchase');
  String get legendLaterBuy => _localizedValue('شراء لاحقاً', 'Plus tard', 'Later Buy');
  String get legendNote => _localizedValue('ملاحظة', 'Note', 'Note');
  String get productsCount => _localizedValue('منتجات', 'produits', 'products');
  String get todaysActivity => _localizedValue('نشاط هذا اليوم', 'Activité du jour', 'Today\'s Activity');

  // Notebook
  String get notebookTitle => _localizedValue('دفتر الملاحظات', 'Carnet d\'alimentation', 'Food Notebook');
  String get newNote => _localizedValue('ملاحظة جديدة', 'Nouvelle note', 'New note');
  String get noteTitlePlaceholder => _localizedValue('عنوان الملاحظة...', 'Titre de la note...', 'Note title...');
  String get noteBodyPlaceholder => _localizedValue('اكتب ملاحظتك الغذائية أو ملاحظة الشراء هنا...', 'Écrivez vos observations...', 'Write food or shopping notes here...');

  // Shopping Lists
  String get shoppingListsTitle => _localizedValue('قوائم التسوق', 'Listes de courses', 'Shopping Lists');
  String get newList => _localizedValue('قائمة جديدة', 'Nouvelle liste', 'New list');

  // Settings
  String get settingsTitle => _localizedValue('الإعدادات', 'Paramètres', 'Settings');
  String get language => _localizedValue('اللغة', 'Langue', 'Language');
  String get localOnlyMode => _localizedValue('وضع محلي فقط (بدون إنترنت)', 'Mode 100% Hors-ligne', 'Local-only mode (Offline)');
  String get localOnlyExplanation => _localizedValue('بياناتك محفوظة بأمان على هاتفك فقط دون أي خادم خارجي.', 'Vos données restent uniquement sur votre appareil.', 'Your data is securely stored on your device only.');
  String get exportBackup => _localizedValue('تصدير نسخة احتياطية (.qoffa)', 'Exporter sauvegarde (.qoffa)', 'Export backup (.qoffa)');
  String get dataExportSuccess => _localizedValue('تم تصدير البيانات بنجاح', 'Données exportées avec succès', 'Data exported successfully');

  String _localizedValue(String ar, String fr, String en) {
    if (locale.languageCode == 'ar') return ar;
    if (locale.languageCode == 'fr') return fr;
    return en;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
