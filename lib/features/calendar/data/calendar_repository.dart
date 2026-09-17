import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/money/dzd_amount.dart';

class DayCalendarSummary {
  const DayCalendarSummary({
    required this.localDate,
    required this.totalSpent,
    required this.purchaseCount,
    required this.laterBuyCount,
    required this.noteCount,
  });

  final String localDate;
  final DzdAmount totalSpent;
  final int purchaseCount;
  final int laterBuyCount;
  final int noteCount;

  bool get hasPurchases => purchaseCount > 0;
  bool get hasLaterBuy => laterBuyCount > 0;
  bool get hasNotes => noteCount > 0;
}

sealed class CalendarTimelineItem {
  const CalendarTimelineItem({
    required this.id,
    required this.timestamp,
    required this.title,
  });

  final String id;
  final DateTime timestamp;
  final String title;
}

class PurchaseTimelineItem extends CalendarTimelineItem {
  const PurchaseTimelineItem({
    required super.id,
    required super.timestamp,
    required super.title,
    required this.productName,
    required this.quantityStr,
    required this.total,
    this.storeName,
  });

  final String productName;
  final String quantityStr;
  final DzdAmount total;
  final String? storeName;
}

class LaterBuyTimelineItem extends CalendarTimelineItem {
  const LaterBuyTimelineItem({
    required super.id,
    required super.timestamp,
    required super.title,
    required this.observedPrice,
    required this.targetPrice,
  });

  final DzdAmount observedPrice;
  final DzdAmount? targetPrice;
}

class NoteTimelineItem extends CalendarTimelineItem {
  const NoteTimelineItem({
    required super.id,
    required super.timestamp,
    required super.title,
    required this.bodyPreview,
    required this.noteType,
  });

  final String bodyPreview;
  final String noteType;
}

abstract class CalendarRepository {
  Stream<Map<String, DayCalendarSummary>> watchMonthSummaries(int year, int month);
  Stream<List<CalendarTimelineItem>> watchDayTimeline(String localDate);
}

class DriftCalendarRepository implements CalendarRepository {
  DriftCalendarRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Map<String, DayCalendarSummary>> watchMonthSummaries(int year, int month) {
    // Watches purchases and notes and aggregates by localDate
    return _db.select(_db.purchases).watch().map((purchases) {
      final map = <String, DayCalendarSummary>{};

      for (final p in purchases) {
        if (p.deletedAt != null) continue;
        final existing = map[p.localDate];
        final total = (existing?.totalSpent ?? DzdAmount.zero) + DzdAmount(p.totalDzd);
        final count = (existing?.purchaseCount ?? 0) + 1;

        map[p.localDate] = DayCalendarSummary(
          localDate: p.localDate,
          totalSpent: total,
          purchaseCount: count,
          laterBuyCount: existing?.laterBuyCount ?? 0,
          noteCount: existing?.noteCount ?? 0,
        );
      }
      return map;
    });
  }

  @override
  Stream<List<CalendarTimelineItem>> watchDayTimeline(String localDate) {
    return _db.select(_db.purchases).watch().map((purchases) {
      final items = <CalendarTimelineItem>[];

      for (final p in purchases) {
        if (p.deletedAt != null || p.localDate != localDate) continue;
        items.add(
          PurchaseTimelineItem(
            id: p.id,
            timestamp: p.purchasedAt,
            title: 'Purchase',
            productName: p.productId, // Will join product display name
            quantityStr: '${p.quantity} ${p.unitId}',
            total: DzdAmount(p.totalDzd),
          ),
        );
      }

      items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return items;
    });
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftCalendarRepository(db);
});
