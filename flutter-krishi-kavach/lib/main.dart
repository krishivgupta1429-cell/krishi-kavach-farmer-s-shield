import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'l10n/l10n.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/about_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  
  runApp(KrishiKavachApp(storageService: storageService));
}

class KrishiKavachApp extends StatefulWidget {
  final StorageService storageService;
  
  const KrishiKavachApp({super.key, required this.storageService});

  @override
  State<KrishiKavachApp> createState() => _KrishiKavachAppState();
  
  /// Provides access to change locale from anywhere in the app
  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_KrishiKavachAppState>();
    state?.setLocale(newLocale);
  }
}

class _KrishiKavachAppState extends State<KrishiKavachApp> {
  Locale _locale = const Locale('en');
  
  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    final savedLang = widget.storageService.getLanguage();
    setState(() {
      _locale = Locale(savedLang);
    });
  }
  
  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
    widget.storageService.setLanguage(newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishi Kavach',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      
      // Localization
      locale: _locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Initial route based on auth state
      initialRoute: '/splash',
      
      // Route generation
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _getScreen(settings.name ?? '/splash', settings.arguments),
          settings: settings,
        );
      },
    );
  }
  
  Widget _getScreen(String routeName, Object? arguments) {
    switch (routeName) {
      case '/splash':
        return SplashScreen(storageService: widget.storageService);
      case '/login':
        return LoginScreen(storageService: widget.storageService);
      case '/signup':
        return SignupScreen(storageService: widget.storageService);
      case '/onboarding':
        return OnboardingScreen(storageService: widget.storageService);
      case '/home':
        return HomeScreen(storageService: widget.storageService);
      case '/result':
        return ResultScreen(
          storageService: widget.storageService,
          result: arguments as Map<String, dynamic>?,
        );
      case '/about':
        return const AboutScreen();
      case '/profile':
        return ProfileScreen(storageService: widget.storageService);
      default:
        return SplashScreen(storageService: widget.storageService);
    }
  }
}
