import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../data/calendar_repository.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  late DateTime _selectedDate = DateTime.now();

  String get _selectedLocalDate =>
      '${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calendarRepo = ref.watch(calendarRepositoryProvider);

    final monthSummariesAsync = ref.watch(
      StreamProvider((ref) => calendarRepo.watchMonthSummaries(
            _displayedMonth.year,
            _displayedMonth.month,
          )),
    );
    final dayTimelineAsync = ref.watch(
      StreamProvider((ref) => calendarRepo.watchDayTimeline(_selectedLocalDate)),
    );

    final summaries = monthSummariesAsync.value ?? {};
    final daySummary = summaries[_selectedLocalDate];

    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday; // 1 = Mon, 7 = Sun

    return MintBackgroundScaffold(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              Text(
                l10n.calendarTitle,
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.calendarSubtitle,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: QoffaColors.secondarySage,
                ),
              ),
              const SizedBox(height: 16),

              // Calendar Month Grid Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: QoffaColors.whiteSurface,
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                  border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: QoffaColors.primaryNavy.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Month Navigation Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded, size: 28),
                          onPressed: _previousMonth,
                        ),
                        Text(
                          DateFormat.yMMMM().format(_displayedMonth),
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded, size: 28),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Weekday headers (Mon - Sun)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                          .map((d) => SizedBox(
                                width: 36,
                                child: Center(
                                  child: Text(
                                    d,
                                    style: const TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: QoffaColors.secondarySage,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),

                    // Days Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (firstWeekday - 1) + daysInMonth,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 6,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        if (index < firstWeekday - 1) {
                          return const SizedBox.shrink();
                        }
                        final day = index - (firstWeekday - 2);
                        final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
                        final isSelected = date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day;

                        final dateKey = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                        final summary = summaries[dateKey];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? QoffaColors.actionGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  day.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Hero Sandwich Pro',
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                    color: isSelected ? QoffaColors.whiteSurface : QoffaColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (summary?.hasPurchases ?? false)
                                      _dot(isSelected ? Colors.white : QoffaColors.brandGreen),
                                    if (summary?.hasLaterBuy ?? false) ...[
                                      const SizedBox(width: 2),
                                      _dot(isSelected ? Colors.white : QoffaColors.warningCoral),
                                    ],
                                    if (summary?.hasNotes ?? false) ...[
                                      const SizedBox(width: 2),
                                      _dot(isSelected ? Colors.white : QoffaColors.noteYellow),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Legend Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _legendItem(QoffaColors.brandGreen, l10n.legendPurchase),
                        _legendItem(QoffaColors.warningCoral, l10n.legendLaterBuy),
                        _legendItem(QoffaColors.noteYellow, l10n.legendNote),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Day Summary Details Card: 4 metric pills
              Text(
                DateFormat('d MMMM').format(_selectedDate),
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.shopping_cart_outlined,
                      label: (daySummary?.totalSpent ?? DzdAmount.zero).format(),
                      subtitle: l10n.spent,
                      color: QoffaColors.skyBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.shopping_bag_outlined,
                      label: (daySummary?.purchaseCount ?? 0).toString(),
                      subtitle: l10n.productsCount,
                      color: QoffaColors.brandGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.watch_later_outlined,
                      label: (daySummary?.laterBuyCount ?? 0).toString(),
                      subtitle: 'Later Buy',
                      color: QoffaColors.warningCoral,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.note_alt_outlined,
                      label: (daySummary?.noteCount ?? 0).toString(),
                      subtitle: 'Notes',
                      color: QoffaColors.noteYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Today's Activity Vertical Timeline
              Text(
                l10n.todaysActivity,
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 14),

              dayTimelineAsync.when(
                data: (timelineItems) {
                  if (timelineItems.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: QoffaColors.whiteSurface,
                        borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                        border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'No events recorded on this date',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 14,
                            color: QoffaColors.secondarySage,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: timelineItems.map((item) {
                      return _TimelineEventRow(item: item);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _dot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  static Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(color),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: QoffaColors.secondarySage,
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: QoffaColors.primaryNavy,
              ),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 11,
              color: QoffaColors.secondarySage,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventRow extends StatelessWidget {
  const _TimelineEventRow({required this.item});

  final CalendarTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.Hm().format(item.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QoffaColors.whiteSurface,
        borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
        border: Border.all(color: QoffaColors.softBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Text(
            timeStr,
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: QoffaColors.secondarySage,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: QoffaColors.actionGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item is PurchaseTimelineItem
                      ? (item as PurchaseTimelineItem).productName
                      : item.title,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: QoffaColors.primaryNavy,
                  ),
                ),
                if (item is PurchaseTimelineItem)
                  Text(
                    (item as PurchaseTimelineItem).quantityStr,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 12,
                      color: QoffaColors.secondarySage,
                    ),
                  ),
              ],
            ),
          ),
          if (item is PurchaseTimelineItem)
            Text(
              (item as PurchaseTimelineItem).total.format(),
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: QoffaColors.primaryNavy,
              ),
            ),
        ],
      ),
    );
  }
}
