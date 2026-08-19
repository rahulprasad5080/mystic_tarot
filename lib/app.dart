import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/reading_types.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'state/providers/auth_provider.dart';
import 'state/providers/locale_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/language_selection_screen.dart';
import 'presentation/screens/reading_input_screen.dart';
import 'presentation/screens/reading_detail_screen.dart';
import 'presentation/screens/card_select_screen.dart';
import 'presentation/screens/compatibility_input_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/daily_tarot_screen.dart';
import 'presentation/screens/horoscope_screen.dart';
import 'state/providers/connectivity_provider.dart';
import 'presentation/widgets/no_internet_widget.dart';
import 'presentation/widgets/divine_loading_widget.dart';

class MysticTarotApp extends ConsumerWidget {
  const MysticTarotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isFirstLaunch = ref.watch(isFirstLaunchProvider);
    final authService = ref.watch(authServiceProvider);
    final authState = ref.watch(authStateProvider);
    final currentUser = authService.currentUser;
    final networkStatus = ref.watch(networkStatusProvider);

    final String initialRoute = isFirstLaunch
        ? '/language'
        : (currentUser != null
            ? '/home'
            : authState.when(
                data: (user) => user != null ? '/home' : '/login',
                loading: () => '/home', // default to home while checking if token exists
                error: (_, st) => '/login',
              ));

    return MaterialApp(
      title: 'Ably Tarot Card Reading',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: initialRoute,
      builder: (context, child) {
        final isOnline = networkStatus.valueOrNull ?? true;
        if (!isOnline) {
          return const NoInternetWidget();
        }
        return child ?? const SizedBox.shrink();
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );
          case '/language':
            return MaterialPageRoute(
              builder: (_) => const LanguageSelectionScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (_) => const MainScreen(initialIndex: 0),
            );
          case '/saved':
            return MaterialPageRoute(
              builder: (_) => const MainScreen(initialIndex: 1),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => const MainScreen(initialIndex: 2),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            );
          case '/daily-tarot':
            return MaterialPageRoute(
              builder: (_) => const DailyTarotScreen(),
            );
          case '/horoscope':
            final signArg = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => HoroscopeScreen(initialSign: signArg),
            );
          case '/loading':
            return MaterialPageRoute(
              builder: (_) => const DivineLoadingWidget(),
            );
          case '/reading-input':
            final readingType = settings.arguments as ReadingType;
            return MaterialPageRoute(
              builder: (_) => ReadingInputScreen(readingType: readingType),
            );
          case '/reading-detail':
            final args = settings.arguments;
            if (args is ReadingType) {
              return MaterialPageRoute(
                builder: (_) => ReadingDetailScreen(readingType: args),
              );
            } else if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => ReadingDetailScreen(
                  readingType: args['readingType'] as ReadingType,
                  cardImage: args['cardImage'] as String?,
                  sign1: args['sign1'] as String?,
                  sign2: args['sign2'] as String?,
                ),
              );
            }
            return MaterialPageRoute(builder: (_) => const MainScreen());
          case '/card-select':
            final readingType = settings.arguments as ReadingType;
            return MaterialPageRoute(
              builder: (_) => CardSelectScreen(readingType: readingType),
            );
          case '/compatibility-input':
            final readingType = settings.arguments as ReadingType;
            return MaterialPageRoute(
              builder: (_) => CompatibilityInputScreen(readingType: readingType),
            );
          default:
            return MaterialPageRoute(builder: (_) => const MainScreen());
        }
      },
    );
  }
}
