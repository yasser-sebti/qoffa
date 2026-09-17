import 'package:flutter/material.dart';
import '../../core/units/unit_registry.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      AppLocalizations(const Locale('ar'));

  static const supportedLocales = [Locale('ar'), Locale('fr'), Locale('en')];

  bool get isArabic => locale.languageCode == 'ar';
  String get languageCode => locale.languageCode;
  String _v(String ar, String fr, String en) =>
      isArabic ? ar : (locale.languageCode == 'fr' ? fr : en);

  String get appTitle => _v('قفة', 'Qoffa', 'Qoffa');
  String get cancel => _v('إلغاء', 'Annuler', 'Cancel');
  String get confirm => _v('تأكيد', 'Confirmer', 'Confirm');
  String get save => _v('حفظ', 'Enregistrer', 'Save');
  String get create => _v('إنشاء', 'Créer', 'Create');
  String get edit => _v('تعديل', 'Modifier', 'Edit');
  String get undo => _v('تراجع', 'Annuler', 'Undo');
  String get retry => _v('إعادة المحاولة', 'Réessayer', 'Try again');
  String get errorTitle =>
      _v('حدث خطأ', 'Un problème est survenu', 'Something went wrong');
  String get unknownProduct =>
      _v('منتج غير معروف', 'Produit inconnu', 'Unknown product');
  String errorMessage(Object error) => _v(
    'تعذر تحميل البيانات',
    'Impossible de charger les données',
    'Could not load the data',
  );

  String get navHome => _v('الرئيسية', 'Accueil', 'Home');
  String get navCalendar => _v('التقويم', 'Calendrier', 'Calendar');
  String get navAdd => _v('إضافة', 'Ajouter', 'Add');
  String get navLaterBuy => _v('لاحقاً', 'Plus tard', 'Later');
  String get navNotebook => _v('الدفتر', 'Carnet', 'Notebook');
  String get settingsTitle => _v('الإعدادات', 'Paramètres', 'Settings');
  String get shoppingListsTitle =>
      _v('قوائم التسوق', 'Listes de courses', 'Shopping lists');

  String greetingFor(DateTime date) {
    if (date.hour < 12) {
      return _v('صباح الخير', 'Bonjour', 'Good morning');
    }
    if (date.hour < 18) {
      return _v('نهارك مبروك', 'Bon après-midi', 'Good afternoon');
    }
    return _v('مساء الخير', 'Bonsoir', 'Good evening');
  }

  String get greetingMorning => greetingFor(DateTime.now());
  String get subtitleHome => _v(
    'قفتك ومصاريفك، بنظرة واحدة',
    'Vos courses en un coup d’œil',
    'Your groceries at a glance',
  );
  String get monthlyBudget =>
      _v('ميزانية الشهر', 'Budget du mois', 'Monthly budget');
  String get spent => _v('مصروف', 'dépensé', 'spent');
  String get remaining => _v('متبقي', 'restant', 'remaining');
  String get overBudget =>
      _v('فوق الميزانية', 'au-dessus du budget', 'over budget');
  String get used => _v('مستهلك', 'utilisé', 'used');
  String get keepItUp => _v('واصل هكذا!', 'Continuez !', 'Keep it up!');
  String get today => _v('اليوم', 'Aujourd’hui', 'Today');
  String get yesterday => _v('أمس', 'Hier', 'Yesterday');
  String get projected => _v('المتوقع:', 'Prévision :', 'Projected:');
  String get onTrack => _v(
    'أنت على المسار الصحيح',
    'Vous êtes sur la bonne voie',
    'You are on track',
  );
  String get watchYourPace => _v(
    'وتيرة الصرف مرتفعة هذا الشهر',
    'Le rythme est élevé ce mois-ci',
    'Spending is moving quickly this month',
  );
  String get recentActivity =>
      _v('آخر النشاطات', 'Activité récente', 'Recent activity');
  String get seeAll => _v('عرض الكل', 'Tout voir', 'See all');
  String get quickActions => _v('وصول سريع', 'Accès rapide', 'Quick actions');
  String get mostBoughtItem =>
      _v('الأكثر شراءً', 'Article le plus acheté', 'Most bought item');
  String get fasterThanLastMonth =>
      _v('أسرع من الشهر الماضي', 'plus rapide que le mois dernier', 'faster than last month');
  String get slowerThanLastMonth =>
      _v('أقل من الشهر الماضي', 'moins que le mois dernier', 'slower than last month');
  String get fasterThanBudget =>
      _v('أسرع من وتيرة الميزانية', 'plus rapide que prévu', 'faster than budget pace');
  String get slowerThanBudget =>
      _v('أقل من وتيرة الميزانية', 'sous le rythme prévu', 'under budget pace');
  String get onBudgetPace =>
      _v('على وتيرة الميزانية', 'au rythme du budget', 'on budget pace');
  String get noItemsYet =>
      _v('لا توجد مشتريات بعد', 'Aucun article encore', 'No purchases yet');
  String get addPurchaseTitle =>
      _v('إضافة شراء', 'Ajouter un achat', 'Add purchase');
  String get addPurchaseSubtitle => _v(
    'سجّلها في ثوانٍ',
    'Enregistrez-le en quelques secondes',
    'Record it in seconds',
  );
  String get laterBuyTitle =>
      _v('شراء لاحقاً', 'Acheter plus tard', 'Later Buy');
  String get notebookTitle =>
      _v('دفتر الأغذية', 'Carnet alimentaire', 'Food Notebook');
  String get noPurchasesYet => _v(
    'قفتك ما زالت فارغة',
    'Votre panier est encore vide',
    'Your basket is still empty',
  );
  String get noPurchasesMessage => _v(
    'أضف أول شراء لتظهر الميزانية والأسعار والنشاط هنا.',
    'Ajoutez votre premier achat pour suivre votre budget et vos prix.',
    'Add your first purchase to start tracking budgets, prices, and activity.',
  );
  String get addFirstPurchase =>
      _v('أضف أول شراء', 'Ajouter mon premier achat', 'Add first purchase');
  String get productFallback => _v('منتج', 'Produit', 'Product');
  String get productNotFound =>
      _v('المنتج غير موجود', 'Produit introuvable', 'Product not found');
  String get typicalRange =>
      _v('النطاق المعتاد', 'Fourchette habituelle', 'Typical range');
  String get notRecorded => _v('غير مسجل', 'Non enregistré', 'Not recorded');
  String get needsThreePurchases =>
      _v('يحتاج 3 مشتريات', '3 achats nécessaires', 'Needs 3 purchases');
  String get purchaseHistory =>
      _v('سجل الأسعار', 'Historique des prix', 'Price history');
  String get noPurchaseHistory => _v(
    'لا توجد مشتريات سابقة',
    'Aucun achat précédent',
    'No previous purchases',
  );
  String get addPurchaseForProduct => _v(
    'شراء جديد لهذا المنتج',
    'Nouvel achat de ce produit',
    'Buy this product again',
  );

  String get productName => _v('المنتج', 'Produit', 'Product');
  String get productSearchPlaceholder => _v(
    'ابحث أو اكتب اسم منتج...',
    'Rechercher ou saisir un produit…',
    'Search or type a product…',
  );
  String get lastPrice => _v('آخر سعر', 'Dernier prix', 'Last price');
  String get noPreviousPrice =>
      _v('لا يوجد سعر سابق', 'Aucun prix précédent', 'No previous price');
  String get todayDiff => _v('الفرق', 'Différence', 'Difference');
  String get quantity => _v('الكمية', 'Quantité', 'Quantity');
  String get unit => _v('الوحدة', 'Unité', 'Unit');
  String get pricePerUnit =>
      _v('سعر الوحدة', 'Prix unitaire', 'Price per unit');
  String get totalPrice => _v('السعر الإجمالي', 'Prix total', 'Total price');
  String get priceModeHint => _v(
    'اضغط للتبديل بين سعر الوحدة والإجمالي',
    'Touchez pour changer le mode de prix',
    'Tap to switch price mode',
  );
  String get store => _v('المتجر', 'Magasin', 'Store');
  String get storeDefault => _v('غير محدد', 'Non défini', 'Not selected');
  String get storeHint => _v(
    'اسم المحل أو السوق',
    'Nom du magasin ou du marché',
    'Store or market name',
  );
  String get date => _v('التاريخ', 'Date', 'Date');
  String get boughtAction => _v('تم الشراء', 'Acheté', 'Bought');
  String get buyLaterAction =>
      _v('شراء لاحقاً', 'Acheter plus tard', 'Buy later');
  String get addSomethingElse =>
      _v('إضافة شيء آخر؟', 'Ajouter autre chose ?', 'Add something else?');
  String get todaySpent =>
      _v('مصاريف اليوم', 'Dépensé aujourd\'hui', 'Today\'s spend');
  String get remainingBudget =>
      _v('المتبقي من الميزانية', 'Budget restant', 'Remaining budget');
  String get budgetUsed => _v('من الميزانية', 'du budget', 'of budget');
  String get quickAdd => _v('إضافة سريعة', 'Ajout rapide', 'Quick add');
  String get refresh => _v('تحديث', 'Actualiser', 'Refresh');
  String get addToListAction =>
      _v('إضافة للقائمة', 'Ajouter à la liste', 'Add to list');
  String get quickAddStaples => _v('منتجات سريعة', 'Ajout rapide', 'Quick add');
  String get foodName => _v('اسم المادة الغذائية', 'Nom de l\'aliment', 'Food name');
  String get addItem => _v('إضافة مادة غذائية', 'Ajouter un article', 'Add item');
  String get recentPickedFoods => _v('العناصر المختارة مؤخراً', 'Aliments récents', 'Recent picked foods');
  String addNewGroceryItem(String name) => _v(
    'إضافة "$name" كعنصر بقالة جديد',
    'Ajouter "$name" comme nouvel article',
    'Add "$name" as new grocery item',
  );
  String get scanBarcode =>
      _v('مسح الباركود', 'Scanner le code-barres', 'Scan barcode');
  String get scanBarcodeHint => _v(
    'وجّه الكاميرا نحو الباركود ليتم مسحه تلقائياً.',
    'Placez le code-barres devant la caméra.',
    'Point the camera at the barcode to scan it automatically.',
  );
  String get clearProduct =>
      _v('مسح المنتج', 'Effacer le produit', 'Clear product');
  String get productRequired => _v(
    'اكتب اسم المنتج أولاً',
    'Saisissez d’abord le produit',
    'Enter a product first',
  );
  String get validPriceRequired => _v(
    'أدخل سعراً صحيحاً',
    'Saisissez un prix valide',
    'Enter a valid price',
  );
  String get purchaseSaved =>
      _v('تم تسجيل الشراء', 'Achat enregistré', 'Purchase saved');
  String get purchaseUndone =>
      _v('تم التراجع عن الشراء', 'Achat annulé', 'Purchase undone');
  String get addedToLaterBuy => _v(
    'أُضيف إلى الشراء لاحقاً',
    'Ajouté à Acheter plus tard',
    'Added to Later Buy',
  );
  String get addedToShoppingList => _v(
    'أُضيف إلى قائمة التسوق',
    'Ajouté à la liste de courses',
    'Added to shopping list',
  );
  String get productFound =>
      _v('تم العثور على المنتج', 'Produit trouvé', 'Product found');
  String get newBarcode =>
      _v('باركود جديد', 'Nouveau code-barres', 'New barcode');

  String get storeName => _v('اسم المتجر', 'Nom du magasin', 'Store name');
  String get selectStore =>
      _v('اختر المتجر', 'Choisir un magasin', 'Select store');
  String get newStore =>
      _v('متجر جديد', 'Nouveau magasin', 'New store');
  String get newStoreDetails =>
      _v('تفاصيل متجر جديد', 'Détails du nouveau magasin', 'New store details');
  String get storeLocation => _v(
        'موقع المتجر (الحي / البلدية)',
        'Localisation (Quartier / Ville)',
        'Store location (Neighborhood / City)',
      );
  String get storeType => _v('نوع المتجر', 'Type de magasin', 'Store type');
  String get storeRating =>
      _v('تقييم المتجر', 'Évaluation du magasin', 'Store rating');
  String get recentPickedStores =>
      _v('المتاجر المستخدمة مؤخراً', 'Magasins récents', 'Recent picked stores');
  String get searchOrAddStore => _v(
        'ابحث أو أضف متجراً...',
        'Rechercher ou ajouter un magasin...',
        'Search or add store...',
      );
  String get storeNameRequired => _v(
        'اكتب اسم المتجر أولاً',
        'Saisissez d’abord le nom du magasin',
        'Enter store name first',
      );
  String addNewStoreNamed(String name) => _v(
        'إضافة متجر جديد "$name"',
        'Ajouter le magasin "$name"',
        'Add new store "$name"',
      );

  String quickProduct(String key) => switch (key) {
    'eggs' => _v('بيض', 'Œufs', 'Eggs'),
    'bread' => _v('خبز', 'Pain', 'Bread'),
    'tomatoes' => _v('طماطم', 'Tomates', 'Tomatoes'),
    'potatoes' => _v('بطاطا', 'Pommes de terre', 'Potatoes'),
    _ => key,
  };

  String unitName(String id) {
    final unit = UnitRegistry.fromIdOrFallback(id);
    if (isArabic) return unit.nameAr;
    if (locale.languageCode == 'fr') return unit.nameFr;
    return unit.nameEn;
  }

  String get laterBuySubtitle => _v(
    'انتظر سعراً أفضل بدون أن تنسى',
    'Attendez un meilleur prix sans oublier',
    'Wait for a better price without forgetting',
  );
  String get pendingCount => _v('قيد الانتظار', 'en attente', 'pending');
  String get tabActive => _v('نشطة', 'Actifs', 'Active');
  String get tabBought => _v('تم شراؤها', 'Achetés', 'Bought');
  String get tabSkipped => _v('متخطاة', 'Ignorés', 'Skipped');
  String get observedPrice =>
      _v('السعر المرصود', 'Prix observé', 'Observed price');
  String get targetPrice => _v('السعر المستهدف', 'Prix cible', 'Target price');
  String get reminder => _v('التذكير', 'Rappel', 'Reminder');
  String get wasItWorthWaiting => _v(
    'هل كان الانتظار يستحق؟',
    'L’attente en valait-elle la peine ?',
    'Was it worth waiting?',
  );
  String get confirmPurchase =>
      _v('تأكيد الشراء', 'Confirmer l’achat', 'Confirm purchase');
  String get noLaterBuyActive => _v(
    'لا شيء مؤجل الآن',
    'Aucun article reporté',
    'Nothing postponed right now',
  );
  String get noLaterBuyActiveMessage => _v(
    'إذا بدا السعر مرتفعاً، أضفه هنا وانتظر فرصة أفضل.',
    'Quand un prix semble élevé, gardez-le ici pour plus tard.',
    'When a price feels high, save it here and wait for a better one.',
  );
  String get noItemsInTab => _v(
    'لا توجد عناصر في هذا القسم',
    'Aucun article dans cette section',
    'No items in this section',
  );
  String waitedResult(int days, int difference, bool saved) => saved
      ? _v(
          'وفّرت $difference دج بعد انتظار $days يوم',
          'Vous avez économisé $difference DA après $days jours',
          'You saved $difference DA after waiting $days days',
        )
      : _v(
          'دفعت ${difference.abs()} دج إضافية بعد $days يوم',
          'Vous avez payé ${difference.abs()} DA de plus après $days jours',
          'You paid ${difference.abs()} DA more after $days days',
        );

  String get calendarTitle => _v('التقويم', 'Calendrier', 'Calendar');
  String get calendarSubtitle => _v(
    'كل نشاطات القفة في مكان واحد',
    'Toute l’activité de vos courses au même endroit',
    'All your grocery activity in one place',
  );
  String get legendPurchase => _v('شراء', 'Achat', 'Purchase');
  String get legendLaterBuy => _v('لاحقاً', 'Plus tard', 'Later Buy');
  String get legendNote => _v('ملاحظة', 'Note', 'Note');
  String get productsCount => _v('مشتريات', 'achats', 'purchases');
  String get notesCount => _v('ملاحظات', 'notes', 'notes');
  String get todaysActivity =>
      _v('نشاط اليوم', 'Activité du jour', 'Day activity');
  String get noEventsTitle =>
      _v('يوم هادئ', 'Une journée calme', 'A quiet day');
  String get noEventsMessage => _v(
    'لا توجد مشتريات أو ملاحظات مسجلة في هذا التاريخ.',
    'Aucun achat ni aucune note à cette date.',
    'No purchases or notes were recorded on this date.',
  );
  List<String> get weekdayShort => isArabic
      ? const ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح']
      : locale.languageCode == 'fr'
      ? const ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim']
      : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String get newNote => _v('ملاحظة جديدة', 'Nouvelle note', 'New note');
  String get saveNote => _v('حفظ الملاحظة', 'Enregistrer la note', 'Save note');
  String get noteTitlePlaceholder =>
      _v('عنوان الملاحظة', 'Titre de la note', 'Note title');
  String get noteBodyPlaceholder => _v(
    'ما الذي تريد تذكره؟',
    'Que souhaitez-vous retenir ?',
    'What would you like to remember?',
  );
  String get noteType => _v('نوع الملاحظة', 'Type de note', 'Note type');
  String get noteSaved =>
      _v('تم حفظ الملاحظة', 'Note enregistrée', 'Note saved');
  String get editNote => _v('تعديل الملاحظة', 'Modifier la note', 'Edit note');
  String get deleteNote => _v('حذف الملاحظة', 'Supprimer la note', 'Delete note');
  String get deleteNoteConfirmTitle =>
      _v('حذف الملاحظة؟', 'Supprimer cette note ?', 'Delete note?');
  String get deleteNoteConfirmMessage => _v(
    'هل أنت متأكد من رغبتك في حذف هذه الملاحظة؟ لا يمكن التراجع عن ذلك.',
    'Voulez-vous vraiment supprimer cette note ? Cette action est irréversible.',
    'Are you sure you want to delete this note? This cannot be undone.',
  );
  String get noteUpdated =>
      _v('تم تحديث الملاحظة', 'Note mise à jour', 'Note updated');
  String get noteDeleted =>
      _v('تم حذف الملاحظة', 'Note supprimée', 'Note deleted');
  String get lastEdited =>
      _v('آخر تعديل', 'Dernière modification', 'Last edited');
  String get createdAtLabel =>
      _v('تاريخ الإنشاء', 'Date de création', 'Created');
  String get allNotes => _v('الكل', 'Toutes', 'All');
  String get noNotesTitle =>
      _v('دفترك جاهز', 'Votre carnet est prêt', 'Your notebook is ready');
  String get noNotesMessage => _v(
    'دوّن فكرة وجبة أو ملاحظة سعر أو رأيك في منتج.',
    'Notez une idée de repas, un prix ou votre avis sur un produit.',
    'Save a meal idea, price observation, or product review.',
  );
  String noteTypeLabel(String type) => switch (type) {
    'food_diary' => _v('يوميات الطعام', 'Journal alimentaire', 'Food diary'),
    'shopping_note' => _v('ملاحظة تسوق', 'Note de courses', 'Shopping note'),
    'price_observation' => _v(
      'ملاحظة سعر',
      'Observation de prix',
      'Price observation',
    ),
    'product_review' => _v('تقييم منتج', 'Avis produit', 'Product review'),
    'meal_idea' => _v('فكرة وجبة', 'Idée de repas', 'Meal idea'),
    _ => _v('ملاحظة', 'Note', 'Note'),
  };

  String get newList => _v('قائمة جديدة', 'Nouvelle liste', 'New list');
  String get listName => _v('اسم القائمة', 'Nom de la liste', 'List name');
  String get createFirstList =>
      _v('أنشئ أول قائمة', 'Créer ma première liste', 'Create first list');
  String get noShoppingLists => _v(
    'لا توجد قوائم بعد',
    'Aucune liste pour le moment',
    'No shopping lists yet',
  );
  String get noShoppingListsMessage => _v(
    'رتّب ما تحتاجه قبل رحلة التسوق القادمة.',
    'Préparez ce qu’il vous faut avant vos prochaines courses.',
    'Plan what you need before your next grocery trip.',
  );
  String get addListItemHint =>
      _v('أضف منتجاً...', 'Ajouter un produit…', 'Add an item…');
  String get emptyShoppingList => _v(
    'القائمة فارغة. أضف ما تحتاجه للرحلة القادمة.',
    'La liste est vide. Ajoutez ce qu’il vous faut.',
    'The list is empty. Add what you need next.',
  );
  String get defaultShoppingList =>
      _v('قائمة التسوق', 'Liste de courses', 'Shopping list');

  String get language => _v('اللغة', 'Langue', 'Language');
  String get localOnlyMode => _v(
    'بيانات محلية وآمنة',
    'Données locales et privées',
    'Private local data',
  );
  String get localOnlyExplanation => _v(
    'كل معلوماتك محفوظة على هذا الجهاز ولا تُرسل إلى أي خادم.',
    'Toutes vos données restent sur cet appareil et ne sont envoyées à aucun serveur.',
    'Everything stays on this device and is never sent to a server.',
  );
  String get householdSize =>
      _v('عدد أفراد الأسرة', 'Taille du foyer', 'Household size');
  String get monthlyShoppingBudget => _v(
    'ميزانية التسوق الشهرية',
    'Budget mensuel des courses',
    'Monthly grocery budget',
  );
  String get dataAndBackup => _v(
    'البيانات والنسخ الاحتياطي',
    'Données et sauvegarde',
    'Data and backup',
  );
  String get exportBackup =>
      _v('تصدير نسخة احتياطية', 'Exporter une sauvegarde', 'Export backup');
  String get backupExplanation => _v(
    'انسخ بياناتك محلياً للاحتفاظ بها أو نقلها إلى جهاز آخر.',
    'Copiez vos données pour les conserver ou les transférer.',
    'Copy your data to keep it safe or move it to another device.',
  );
  String get exportJson =>
      _v('نسخ النسخة الاحتياطية', 'Copier la sauvegarde', 'Copy backup');
  String get exportCsv =>
      _v('نسخ المشتريات CSV', 'Copier les achats CSV', 'Copy purchases CSV');
  String get importBackup =>
      _v('استيراد نسخة احتياطية', 'Importer une sauvegarde', 'Import backup');
  String get pasteBackup => _v(
    'الصق بيانات النسخة الاحتياطية هنا. سيتم دمجها دون حذف البيانات الحالية.',
    'Collez la sauvegarde ici. Elle sera fusionnée sans supprimer vos données actuelles.',
    'Paste the backup here. It will merge without deleting current data.',
  );
  String get importNow =>
      _v('استيراد الآن', 'Importer maintenant', 'Import now');
  String get backupCopied =>
      _v('تم نسخ النسخة الاحتياطية', 'Sauvegarde copiée', 'Backup copied');
  String get csvCopied => _v(
    'تم نسخ جدول المشتريات',
    'Tableau des achats copié',
    'Purchases CSV copied',
  );
  String get importSuccess =>
      _v('تم استيراد البيانات', 'Données importées', 'Data imported');
  String get importFailure => _v(
    'الملف غير صالح',
    'Le fichier n’est pas valide',
    'The backup is not valid',
  );
  String get budgetUpdated =>
      _v('تم تحديث الميزانية', 'Budget mis à jour', 'Budget updated');
  String get aboutTagline => _v(
    'صُممت للأسر الجزائرية وتعمل بدون إنترنت',
    'Pensée pour les foyers algériens, même hors ligne',
    'Built for Algerian households, even offline',
  );

  String get onboardingTagline => _v(
    'مساعدك اليومي لقفة أوضح ومصاريف أذكى',
    'Votre compagnon pour des courses plus simples',
    'Your companion for simpler, smarter groceries',
  );
  String get chooseLanguage =>
      _v('اختر لغة التطبيق', 'Choisissez la langue', 'Choose your language');
  String get languageCanChange => _v(
    'يمكنك تغييرها في أي وقت من الإعدادات.',
    'Vous pourrez la changer à tout moment.',
    'You can change it any time in Settings.',
  );
  String get optionalBudget => _v(
    'ميزانية التسوق الشهرية',
    'Budget mensuel des courses',
    'Monthly grocery budget',
  );
  String get budgetHelp => _v(
    'اختيارية، وتساعد قفة على حساب وتيرة الصرف والتوقعات.',
    'Facultatif, mais utile pour suivre le rythme de vos dépenses.',
    'Optional, but useful for tracking spending pace and projections.',
  );
  String get estimatedBudget =>
      _v('الميزانية التقديرية', 'Budget estimé', 'Estimated budget');
  String get privacyTitle =>
      _v('محلي وبدون إنترنت', 'Local et hors ligne', 'Local and offline');
  String get privacySubtitle => _v(
    'مشتريات أسرتك تبقى على جهازك.',
    'Les courses de votre foyer restent sur votre appareil.',
    'Your household data stays on your device.',
  );
  String get localFeature => _v(
    'لا تُرسل بياناتك إلى أي خادم خارجي.',
    'Vos données ne sont envoyées à aucun serveur.',
    'Your data is never sent to an external server.',
  );
  String get fastFeature => _v(
    'سريع وفوري ويعمل في وضع الطيران.',
    'Rapide, instantané et disponible en mode avion.',
    'Fast, instant, and available in airplane mode.',
  );
  String get backupFeature => _v(
    'يمكنك تصدير نسخة احتياطية في أي وقت.',
    'Exportez une sauvegarde à tout moment.',
    'Export a backup whenever you need one.',
  );
  String get continueLabel => _v('متابعة', 'Continuer', 'Continue');
  String get startNow => _v('ابدأ الآن', 'Commencer', 'Get started');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ar', 'fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
