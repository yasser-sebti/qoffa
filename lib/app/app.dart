import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/widgets/top_toast_notification.dart';
import 'localization/app_localizations.dart';
import 'localization/locale_provider.dart';
import 'router/app_router.dart';
import 'theme/qoffa_theme.dart';

class QoffaApp extends ConsumerWidget {
  const QoffaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'قفة · Qoffa',
      debugShowCheckedModeBanner: false,
      theme: QoffaTheme.lightTheme,
      darkTheme: QoffaTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return TopToastLayer(child: child ?? const SizedBox());
      },
    );
  }
}
