import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/localization/locale_provider.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/top_toast_notification.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsRepo = ref.watch(settingsRepositoryProvider);
    final profileAsync = ref.watch(StreamProvider((ref) => settingsRepo.watchProfile()));
    final currentLocale = ref.watch(localeNotifierProvider);

    final profile = profileAsync.value;
    final budgetDzd = profile?.monthlyBudgetDzd ?? 60000;
    final householdSize = profile?.householdSize ?? 4;

    return MintBackgroundScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: QoffaColors.primaryNavy),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.settingsTitle,
                    style: const TextStyle(
                      fontFamily: 'Hero Sandwich Pro',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: QoffaColors.primaryNavy,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // 1. Local-Only Mode Badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: QoffaColors.mintSurfaceTint,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                      border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: QoffaColors.brandGreen,
                            borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                          ),
                          child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.localOnlyMode,
                                style: const TextStyle(
                                  fontFamily: 'Hero Sandwich Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: QoffaColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.localOnlyExplanation,
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: QoffaColors.primaryNavy.withValues(alpha: 0.8),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Budget & Household Settings
                  _SectionHeader(title: l10n.monthlyBudget),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                      border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ميزانية التسوق الشهرية',
                                  style: TextStyle(
                                    fontFamily: 'Alexandria',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: QoffaColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DzdAmount(budgetDzd).format(locale: l10n.locale.languageCode),
                                  style: const TextStyle(
                                    fontFamily: 'Hero Sandwich Pro',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: QoffaColors.brandGreen,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: QoffaColors.paleMintBackground,
                                foregroundColor: QoffaColors.actionGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(QoffaTokens.radiusControls),
                                ),
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text(
                                'تعديل',
                                style: TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700),
                              ),
                              onPressed: () => _showBudgetEditDialog(context, ref, budgetDzd),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: QoffaColors.softBorder),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'عدد أفراد الأسرة',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: QoffaColors.primaryNavy,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: QoffaColors.secondarySage),
                                  onPressed: householdSize > 1
                                      ? () => settingsRepo.updateHouseholdSize(householdSize - 1)
                                      : null,
                                ),
                                Text(
                                  '$householdSize',
                                  style: const TextStyle(
                                    fontFamily: 'Hero Sandwich Pro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: QoffaColors.primaryNavy,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: QoffaColors.brandGreen),
                                  onPressed: householdSize < 20
                                      ? () => settingsRepo.updateHouseholdSize(householdSize + 1)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Language Selection
                  _SectionHeader(title: l10n.language),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                      border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        _LanguageTile(
                          title: 'العربية (الجزائر)',
                          code: 'ar',
                          isSelected: currentLocale.languageCode == 'ar',
                          onTap: () => ref.read(localeNotifierProvider.notifier).setLocale('ar'),
                        ),
                        const Divider(height: 1, color: QoffaColors.softBorder),
                        _LanguageTile(
                          title: 'Français',
                          code: 'fr',
                          isSelected: currentLocale.languageCode == 'fr',
                          onTap: () => ref.read(localeNotifierProvider.notifier).setLocale('fr'),
                        ),
                        const Divider(height: 1, color: QoffaColors.softBorder),
                        _LanguageTile(
                          title: 'English',
                          code: 'en',
                          isSelected: currentLocale.languageCode == 'en',
                          onTap: () => ref.read(localeNotifierProvider.notifier).setLocale('en'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Data Backup & Export
                  _SectionHeader(title: 'البيانات والنسخ الاحتياطي'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
                      border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.exportBackup,
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'احفظ نسخة احتياطية من جميع مشترياتك وقوائمك بتنسيق JSON مفتوح للاحتفاظ ببياناتك أو نقلها لهاتف آخر.',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 12,
                            color: QoffaColors.secondarySage,
                            height: 1.4,
                          ),
                        ),
                        QoffaButton(
                          label: 'تصدير نسخة احتياطية (.qoffa JSON)',
                          icon: Icons.file_download_outlined,
                          onTap: () async {
                            final json = await settingsRepo.exportDataAsJson();
                            await Clipboard.setData(ClipboardData(text: json));
                            QoffaToast.show(
                              message: 'تم نسخ بيانات النسخة الاحتياطية إلى الحافظة بنجاح!',
                              icon: Icons.check_circle_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        QoffaButton(
                          label: 'تصدير المشتريات (CSV)',
                          icon: Icons.table_chart_outlined,
                          variant: QoffaButtonVariant.secondary,
                          onTap: () async {
                            final csv = await settingsRepo.exportPurchasesAsCsv();
                            await Clipboard.setData(ClipboardData(text: csv));
                            QoffaToast.show(
                              message: 'تم نسخ جدول المشتريات CSV للحافظة!',
                              icon: Icons.check_circle_rounded,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        QoffaButton(
                          label: 'استعادة نسخة احتياطية (Import)',
                          icon: Icons.file_upload_outlined,
                          variant: QoffaButtonVariant.secondary,
                          onTap: () => _showImportDialog(context, settingsRepo),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 5. About App Footer
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'قفة · Qoffa v1.0.0',
                          style: TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'مبني بالكامل ليعمل بدون إنترنت للأسر الجزائرية 🇩🇿',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 12,
                            color: QoffaColors.primaryNavy.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBudgetEditDialog(BuildContext context, WidgetRef ref, int currentBudget) {
    final controller = TextEditingController(text: currentBudget.toString());
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor)),
          title: const Text(
            'تعديل الميزانية الشهرية',
            style: TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              suffixText: 'دج',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusFields)),
            ),
            style: const TextStyle(
              fontFamily: 'Hero Sandwich Pro',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: QoffaColors.primaryNavy,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('إلغاء', style: TextStyle(color: QoffaColors.secondarySage)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: QoffaColors.brandGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusControls)),
              ),
              onPressed: () {
                final newBudget = int.tryParse(controller.text) ?? currentBudget;
                ref.read(settingsRepositoryProvider).updateMonthlyBudget(newBudget);
                Navigator.of(dialogCtx).pop();
                QoffaToast.show(
                  message: 'تم تحديث الميزانية بنجاح',
                  icon: Icons.check_circle_rounded,
                );
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showImportDialog(BuildContext context, SettingsRepository repo) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor)),
        title: const Text('استيراد نسخة احتياطية', style: TextStyle(fontFamily: 'Hero Sandwich Pro', fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الصق بيانات ملف JSON للنسخة الاحتياطية هنا. سيتم دمج المنتجات والمشتريات بأمان دون حذف بياناتك الحالية.',
              style: TextStyle(fontFamily: 'Alexandria', fontSize: 12, color: QoffaColors.secondarySage),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '{"version": "1.0.0", ...}',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: QoffaColors.brandGreen),
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              final success = await repo.importDataFromJson(text);
              if (ctx.mounted) Navigator.pop(ctx);
              if (success) {
                QoffaToast.show(message: 'تم استيراد البيانات بنجاح!', icon: Icons.check_circle_rounded);
              } else {
                QoffaToast.show(message: 'فشل استيراد البيانات: ملف غير صالح', color: QoffaColors.warningCoral);
              }
            },
            child: const Text('استيراد الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Hero Sandwich Pro',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: QoffaColors.primaryNavy,
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          color: isSelected ? QoffaColors.brandGreen : QoffaColors.primaryNavy,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: QoffaColors.brandGreen)
          : null,
      onTap: onTap,
      ),
    );
  }
}
