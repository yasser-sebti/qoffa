import 'dart:async';
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
  Stream<Map<String, DayCalendarSummary>> watchMonthSummaries(
    int year,
    int month,
  );
  Stream<List<CalendarTimelineItem>> watchDayTimeline(String localDate);
}

class DriftCalendarRepository implements CalendarRepository {
  DriftCalendarRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Map<String, DayCalendarSummary>> watchMonthSummaries(
    int year,
    int month,
  ) {
    return _combineLatest4(
      _db.select(_db.purchases).watch(),
      _db.select(_db.laterBuyItems).watch(),
      _db.select(_db.notes).watch(),
      _db.select(_db.products).watch(),
      (purchases, laterBuyItems, notes, _) {
        final map = <String, DayCalendarSummary>{};
        final prefix = '$year-${month.toString().padLeft(2, '0')}-';

        for (final p in purchases) {
          if (p.deletedAt != null || !p.localDate.startsWith(prefix)) continue;
          final existing = map[p.localDate];
          final total =
              (existing?.totalSpent ?? DzdAmount.zero) + DzdAmount(p.totalDzd);
          final count = (existing?.purchaseCount ?? 0) + 1;

          map[p.localDate] = DayCalendarSummary(
            localDate: p.localDate,
            totalSpent: total,
            purchaseCount: count,
            laterBuyCount: existing?.laterBuyCount ?? 0,
            noteCount: existing?.noteCount ?? 0,
          );
        }

        for (final item in laterBuyItems) {
          if (item.deletedAt != null) continue;
          final local = item.createdAt.toLocal();
          if (local.year != year || local.month != month) continue;
          final key = _localDate(local);
          final existing = map[key];
          map[key] = DayCalendarSummary(
            localDate: key,
            totalSpent: existing?.totalSpent ?? DzdAmount.zero,
            purchaseCount: existing?.purchaseCount ?? 0,
            laterBuyCount: (existing?.laterBuyCount ?? 0) + 1,
            noteCount: existing?.noteCount ?? 0,
          );
        }

        for (final note in notes) {
          if (note.deletedAt != null || !note.localDate.startsWith(prefix)) {
            continue;
          }
          final existing = map[note.localDate];
          map[note.localDate] = DayCalendarSummary(
            localDate: note.localDate,
            totalSpent: existing?.totalSpent ?? DzdAmount.zero,
            purchaseCount: existing?.purchaseCount ?? 0,
            laterBuyCount: existing?.laterBuyCount ?? 0,
            noteCount: (existing?.noteCount ?? 0) + 1,
          );
        }
        return map;
      },
    );
  }

  @override
  Stream<List<CalendarTimelineItem>> watchDayTimeline(String localDate) {
    return _combineLatest4(
      _db.select(_db.purchases).watch(),
      _db.select(_db.laterBuyItems).watch(),
      _db.select(_db.notes).watch(),
      _db.select(_db.products).watch(),
      (purchases, laterBuyItems, notes, products) {
        final items = <CalendarTimelineItem>[];
        final productNames = {
          for (final product in products) product.id: product.name,
        };

        for (final p in purchases) {
          if (p.deletedAt != null || p.localDate != localDate) continue;
          items.add(
            PurchaseTimelineItem(
              id: p.id,
              timestamp: p.purchasedAt,
              title: 'purchase',
              productName: productNames[p.productId] ?? '—',
              quantityStr: '${p.quantity} ${p.unitId}',
              total: DzdAmount(p.totalDzd),
            ),
          );
        }

        for (final later in laterBuyItems) {
          if (later.deletedAt != null ||
              _localDate(later.createdAt.toLocal()) != localDate) {
            continue;
          }
          items.add(
            LaterBuyTimelineItem(
              id: later.id,
              timestamp: later.createdAt.toLocal(),
              title: productNames[later.productId] ?? '—',
              observedPrice: DzdAmount(later.observedPriceDzd),
              targetPrice: later.targetPriceDzd == null
                  ? null
                  : DzdAmount(later.targetPriceDzd!),
            ),
          );
        }

        for (final note in notes) {
          if (note.deletedAt != null || note.localDate != localDate) continue;
          items.add(
            NoteTimelineItem(
              id: note.id,
              timestamp: note.eventAt,
              title: note.title,
              bodyPreview: note.body,
              noteType: note.noteType,
            ),
          );
        }

        items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return items;
      },
    );
  }
}

String _localDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

Stream<R> _combineLatest4<A, B, C, D, R>(
  Stream<A> first,
  Stream<B> second,
  Stream<C> third,
  Stream<D> fourth,
  R Function(A, B, C, D) combine,
) {
  late StreamController<R> controller;
  final subscriptions = <StreamSubscription<dynamic>>[];
  A? a;
  B? b;
  C? c;
  D? d;
  var hasA = false;
  var hasB = false;
  var hasC = false;
  var hasD = false;

  void emit() {
    if (hasA && hasB && hasC && hasD) {
      controller.add(combine(a as A, b as B, c as C, d as D));
    }
  }

  controller = StreamController<R>.broadcast(
    onListen: () {
      subscriptions
        ..add(
          first.listen((value) {
            a = value;
            hasA = true;
            emit();
          }, onError: controller.addError),
        )
        ..add(
          second.listen((value) {
            b = value;
            hasB = true;
            emit();
          }, onError: controller.addError),
        )
        ..add(
          third.listen((value) {
            c = value;
            hasC = true;
            emit();
          }, onError: controller.addError),
        )
        ..add(
          fourth.listen((value) {
            d = value;
            hasD = true;
            emit();
          }, onError: controller.addError),
        );
    },
    onCancel: () {
      for (final subscription in subscriptions) {
        unawaited(subscription.cancel());
      }
      unawaited(controller.close());
    },
  );
  return controller.stream;
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftCalendarRepository(db);
});

final calendarMonthSummariesProvider =
    StreamProvider.family<
      Map<String, DayCalendarSummary>,
      ({int year, int month})
    >((ref, period) {
      return ref
          .watch(calendarRepositoryProvider)
          .watchMonthSummaries(period.year, period.month);
    });

final calendarDayTimelineProvider =
    StreamProvider.family<List<CalendarTimelineItem>, String>((ref, localDate) {
      return ref.watch(calendarRepositoryProvider).watchDayTimeline(localDate);
    });
