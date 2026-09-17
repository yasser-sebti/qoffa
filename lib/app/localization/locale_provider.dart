import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/settings_repository.dart';

final localeNotifierProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // Initial default is Arabic
    final settingsRepo = ref.watch(settingsRepositoryProvider);
    settingsRepo.getProfile().then((profile) {
      if (profile != null && profile.language.isNotEmpty) {
        state = Locale(profile.language);
      }
    });
    return const Locale('ar');
  }

  Future<void> setLocale(String langCode) async {
    state = Locale(langCode);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.updateLanguage(langCode);
  }
}
