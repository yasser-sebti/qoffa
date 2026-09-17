import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class OnboardingService {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/.qoffa_onboarding.json');
  }

  Future<bool> hasCompletedOnboarding() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return false;
      final content = await file.readAsString();
      final map = jsonDecode(content) as Map<String, dynamic>;
      return map['completed'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setCompleted() async {
    try {
      final file = await _getFile();
      await file.writeAsString(
        jsonEncode({'completed': true, 'at': DateTime.now().toIso8601String()}),
      );
    } catch (_) {}
  }
}

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});
