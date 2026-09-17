import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/locale_provider.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/widgets/mint_background_scaffold.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../settings/data/settings_repository.dart';
import '../data/onboarding_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  String _selectedLang = 'ar';
  final _budgetController = TextEditingController(text: '60000');
  int _householdSize = 4;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _finish() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final onboardingService = ref.read(onboardingServiceProvider);

    final budget = int.tryParse(_budgetController.text) ?? 60000;
    await settingsRepo.updateLanguage(_selectedLang);
    await settingsRepo.updateMonthlyBudget(budget);
    await settingsRepo.updateHouseholdSize(_householdSize);
    await onboardingService.setCompleted();

    ref.read(localeNotifierProvider.notifier).setLocale(_selectedLang);

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MintBackgroundScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'قفة · Qoffa',
                  style: TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: QoffaColors.brandGreen,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'مساعدك اليومي لمتابعة مصاريف التغذية والتسوق',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: QoffaColors.secondarySage,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Page Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildCurrentStep(),
                ),
              ),

              // Bottom Actions
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: QoffaColors.primaryNavy),
                      onPressed: () => setState(() => _currentStep--),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: QoffaButton(
                      label: _currentStep == 2 ? 'ابدأ الاستخدام الآن' : 'متابعة',
                      icon: _currentStep == 2 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                      onTap: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          _finish();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildLanguageStep();
      case 1:
        return _buildBudgetStep();
      case 2:
      default:
        return _buildPrivacyStep();
    }
  }

  Widget _buildLanguageStep() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر لغة التطبيق / Choisissez la langue',
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'يمكنك تغيير اللغة في أي وقت من الإعدادات لاحقاً.',
          style: TextStyle(fontFamily: 'Alexandria', fontSize: 13, color: QoffaColors.secondarySage),
        ),
        const SizedBox(height: 24),
        _buildLangCard('العربية (الجزائر)', 'ar'),
        const SizedBox(height: 12),
        _buildLangCard('Français', 'fr'),
        const SizedBox(height: 12),
        _buildLangCard('English', 'en'),
      ],
    );
  }

  Widget _buildLangCard(String label, String code) {
    final isSelected = _selectedLang == code;
    return InkWell(
      onTap: () => setState(() => _selectedLang = code),
      borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
          border: Border.all(
            color: isSelected ? QoffaColors.brandGreen : QoffaColors.softBorder,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? QoffaColors.brandGreen : QoffaColors.primaryNavy,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: QoffaColors.brandGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStep() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ميزانية التسوق الشهرية (اختيارية)',
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'تساعدك على معرفة وتيرة الصرف والتنبؤ بمصروف نهاية الشهر بدقة.',
          style: TextStyle(fontFamily: 'Alexandria', fontSize: 13, color: QoffaColors.secondarySage),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
            border: Border.all(color: QoffaColors.softBorder, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('الميزانية التقديرية للشهر', style: TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontFamily: 'Hero Sandwich Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: QoffaColors.brandGreen,
                ),
                decoration: InputDecoration(
                  suffixText: 'دج',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(QoffaTokens.radiusFields)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('عدد أفراد الأسرة', style: TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: QoffaColors.secondarySage),
                        onPressed: _householdSize > 1 ? () => setState(() => _householdSize--) : null,
                      ),
                      Text(
                        '$_householdSize',
                        style: const TextStyle(fontFamily: 'Hero Sandwich Pro', fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: QoffaColors.brandGreen),
                        onPressed: () => setState(() => _householdSize++),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyStep() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '100% محلي وبدون إنترنت',
          style: TextStyle(
            fontFamily: 'Hero Sandwich Pro',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: QoffaColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'أمان تام وخصوصية كاملة لمعلومات مشتريات أسرتك.',
          style: TextStyle(fontFamily: 'Alexandria', fontSize: 13, color: QoffaColors.secondarySage),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: QoffaColors.mintSurfaceTint,
            borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
            border: Border.all(color: QoffaColors.softBorder, width: 1.5),
          ),
          child: Column(
            children: [
              _buildFeatureRow(Icons.cloud_off_rounded, 'بياناتك لا تخرج من هاتفك أبداً ولا تتصل بأي خادم خارجي.'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.flash_on_rounded, 'سريع جداً وفوري ويعمل بدون شبكة وفي وضع الطيران.'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.lock_outline_rounded, 'إمكانية تصدير نسخة احتياطية من بياناتك في أي وقت بسهولة.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: QoffaColors.brandGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: QoffaColors.primaryNavy,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
