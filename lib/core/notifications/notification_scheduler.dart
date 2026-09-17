import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class NotificationScheduler {
  Future<void> initialize();
  Future<bool> requestPermissionsIfNeeded();
  Future<void> scheduleLaterBuyReminder({
    required int id,
    required String itemId,
    required String productName,
    required DateTime scheduledAt,
    required int targetPriceDzd,
    String languageCode = 'ar',
  });
  Future<void> scheduleRepurchaseReminder({
    required int id,
    required String productId,
    required String productName,
    required DateTime scheduledAt,
    String languageCode = 'ar',
  });
  Future<void> cancelReminder(int id);
}

class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermissionsIfNeeded() async {
    await initialize();

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      final granted = await androidImplementation
          .requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Adjusts [scheduledAt] so it falls outside quiet hours (22:00–08:00)
  DateTime _applyQuietHours(DateTime scheduledAt) {
    final hour = scheduledAt.hour;
    if (hour >= 22 || hour < 8) {
      // Shift to 09:00 on the morning of scheduled date or next day
      final nextDay = hour >= 22
          ? scheduledAt.add(const Duration(days: 1))
          : scheduledAt;
      return DateTime(nextDay.year, nextDay.month, nextDay.day, 9, 0);
    }
    return scheduledAt;
  }

  @override
  Future<void> scheduleLaterBuyReminder({
    required int id,
    required String itemId,
    required String productName,
    required DateTime scheduledAt,
    required int targetPriceDzd,
    String languageCode = 'ar',
  }) async {
    await requestPermissionsIfNeeded();

    final effectiveDate = _applyQuietHours(scheduledAt);
    if (effectiveDate.isBefore(DateTime.now())) return;

    // Show or schedule
    const androidDetails = AndroidNotificationDetails(
      'qoffa_later_buy',
      'Later Buy Reminders',
      channelDescription: 'Reminders for postponed purchases and target prices',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // If due in under 2 minutes, show notification
    if (effectiveDate.difference(DateTime.now()).inMinutes <= 2) {
      final copy = _laterBuyCopy(languageCode, productName, targetPriceDzd);
      await _plugin.show(id, copy.$1, copy.$2, details);
    }
  }

  @override
  Future<void> scheduleRepurchaseReminder({
    required int id,
    required String productId,
    required String productName,
    required DateTime scheduledAt,
    String languageCode = 'ar',
  }) async {
    await requestPermissionsIfNeeded();

    final effectiveDate = _applyQuietHours(scheduledAt);
    if (effectiveDate.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'qoffa_repurchase',
      'Repurchase Habits',
      channelDescription: 'Reminders for routine staple replenishments',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    if (effectiveDate.difference(DateTime.now()).inMinutes <= 2) {
      final copy = _repurchaseCopy(languageCode, productName);
      await _plugin.show(id, copy.$1, copy.$2, details);
    }
  }

  @override
  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  (String, String) _laterBuyCopy(
    String languageCode,
    String productName,
    int targetPriceDzd,
  ) {
    return switch (languageCode) {
      'fr' => (
        'Rappel Acheter plus tard · Qoffa',
        'Vérifiez le prix de $productName (objectif : $targetPriceDzd DA)',
      ),
      'en' => (
        'Later Buy reminder · Qoffa',
        'Check the price of $productName (target: $targetPriceDzd DA)',
      ),
      _ => (
        'تذكير شراء لاحقاً · قفة',
        'حان وقت تفقد سعر $productName (السعر المستهدف: $targetPriceDzd دج)',
      ),
    };
  }

  (String, String) _repurchaseCopy(String languageCode, String productName) {
    return switch (languageCode) {
      'fr' => (
        'Réapprovisionnement prévu · Qoffa',
        'Selon votre rythme, vous pourriez bientôt devoir racheter $productName.',
      ),
      'en' => (
        'Expected restock · Qoffa',
        'Based on your routine, you may need to buy $productName again soon.',
      ),
      _ => (
        'نفاد متوقع · قفة',
        'بناءً على وتيرة استهلاكك، قد تحتاج لإعادة شراء $productName قريباً',
      ),
    };
  }
}

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return LocalNotificationScheduler();
});
