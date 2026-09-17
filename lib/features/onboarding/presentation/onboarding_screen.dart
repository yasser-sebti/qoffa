import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/localization/locale_provider.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../../core/widgets/qoffa_layout.dart';
import '../../settings/data/settings_repository.dart';
import '../data/onboarding_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String _language = 'ar';
  final _budgetController = TextEditingController(text: '60000');
  int _householdSize = 4;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final settings = ref.read(settingsRepositoryProvider);
    await settings.updateLanguage(_language);
    await settings.updateMonthlyBudget(
      int.tryParse(_budgetController.text) ?? 60000,
    );
    await settings.updateHouseholdSize(_householdSize);
    await ref.read(onboardingServiceProvider).setCompleted();
    await ref.read(localeNotifierProvider.notifier).setLocale(_language);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(Locale(_language));
    final direction = _language == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    return MintBackgroundScaffold(
      child: SafeArea(
        child: Directionality(
          textDirection: direction,
          child: QoffaContentWidth(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
              child: Column(
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontFamily: 'Hero Sandwich Pro',
                      fontSize: 36,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: QoffaColors.actionGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 13,
                      height: 1.4,
                      color: QoffaColors.secondarySage,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: QoffaTokens.motionMedium,
                        width: index == _step ? 28 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _step
                              ? QoffaColors.actionGreen
                              : QoffaColors.softBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: QoffaTokens.motionMedium,
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: SingleChildScrollView(
                        key: ValueKey(_step),
                        child: _stepContent(l10n),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (_step > 0) ...[
                        IconButton.outlined(
                          onPressed: () => setState(() => _step--),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: QoffaButton(
                          label: _step == 2
                              ? l10n.startNow
                              : l10n.continueLabel,
                          icon: _step == 2
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          onTap: () {
                            if (_step < 2) {
                              setState(() => _step++);
                            } else {
                              _finish();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(AppLocalizations l10n) => switch (_step) {
    0 => _languageStep(l10n),
    1 => _budgetStep(l10n),
    _ => _privacyStep(l10n),
  };

  Widget _languageStep(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _StepTitle(title: l10n.chooseLanguage, subtitle: l10n.languageCanChange),
      const SizedBox(height: 20),
      _LanguageChoice(
        label: 'العربية (الجزائر)',
        selected: _language == 'ar',
        onTap: () => setState(() => _language = 'ar'),
      ),
      const SizedBox(height: 10),
      _LanguageChoice(
        label: 'Français',
        selected: _language == 'fr',
        onTap: () => setState(() => _language = 'fr'),
      ),
      const SizedBox(height: 10),
      _LanguageChoice(
        label: 'English',
        selected: _language == 'en',
        onTap: () => setState(() => _language = 'en'),
      ),
    ],
  );

  Widget _budgetStep(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _StepTitle(title: l10n.optionalBudget, subtitle: l10n.budgetHelp),
      const SizedBox(height: 20),
      QoffaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.estimatedBudget,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(suffixText: 'DA'),
              style: const TextStyle(
                fontFamily: 'Hero Sandwich Pro',
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.householdSize,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _householdSize > 1
                      ? () => setState(() => _householdSize--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
                Text(
                  '$_householdSize',
                  style: const TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _householdSize++),
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: QoffaColors.actionGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  Widget _privacyStep(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _StepTitle(title: l10n.privacyTitle, subtitle: l10n.privacySubtitle),
      const SizedBox(height: 20),
      QoffaCard(
        color: QoffaColors.mintSurfaceTint,
        child: Column(
          children: [
            _FeatureRow(icon: Icons.cloud_off_rounded, text: l10n.localFeature),
            const SizedBox(height: 16),
            _FeatureRow(icon: Icons.bolt_rounded, text: l10n.fastFeature),
            const SizedBox(height: 16),
            _FeatureRow(
              icon: Icons.file_download_outlined,
              text: l10n.backupFeature,
            ),
          ],
        ),
      ),
    ],
  );
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Hero Sandwich Pro',
          fontSize: 23,
          fontWeight: FontWeight.w900,
          color: QoffaColors.primaryNavy,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 13,
          height: 1.45,
          color: QoffaColors.secondarySage,
        ),
      ),
    ],
  );
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
      child: AnimatedContainer(
        duration: QoffaTokens.motionMedium,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? QoffaColors.mintSurfaceTint : Colors.white,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
          border: Border.all(
            color: selected ? QoffaColors.actionGreen : QoffaColors.softBorder,
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? QoffaColors.actionGreen
                      : QoffaColors.primaryNavy,
                ),
              ),
            ),
            AnimatedScale(
              scale: selected ? 1 : 0,
              duration: QoffaTokens.motionMedium,
              child: const Icon(
                Icons.check_circle_rounded,
                color: QoffaColors.actionGreen,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: QoffaColors.actionGreen,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: Colors.white, size: 21),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: QoffaColors.primaryNavy,
          ),
        ),
      ),
    ],
  );
}
