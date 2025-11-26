// =============================================================================
// PROJECT: Tractor Khata
// FILE: main.dart
// DESCRIPTION:
// This is the entry point of the Tractor Khata application.
// It handles:
// 1. App Initialization (Firebase, SharedPreferences, Database)
// 2. Provider Setup (State Management)
// 3. Theme Configuration (Material 3, Google Fonts)
// 4. Localization Setup (Hindi & English)
// 5. Navigation & Routing
// =============================================================================

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

// --- Database Imports ---
import 'database/database.dart';

// --- Provider Imports ---
import 'providers/auth_provider.dart';
import 'providers/farmer_provider.dart';
import 'providers/work_provider.dart';
import 'providers/driver_provider.dart';
import 'services/localization_service.dart';

// --- Repository Imports ---
import 'repositories/farmer_repository.dart';
import 'repositories/work_repository.dart';

// --- Screen Imports ---
import 'screens/login_screen.dart';
import 'screens/farmer_list_screen.dart';
import 'screens/add_farmer_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/rate_card_screen.dart';
import 'screens/add_work_type_screen.dart';

/// ---------------------------------------------------------------------------
/// Main Function
/// ---------------------------------------------------------------------------
void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize critical services in parallel to optimize startup time
  final initFutures = await Future.wait([
    Firebase.initializeApp(),
    SharedPreferences.getInstance(),
  ]);
  
  // Extract SharedPreferences instance
  final prefs = initFutures[1] as SharedPreferences;
  
  // Load saved language preference (Default: Hindi 'hi')
  final languageCode = prefs.getString('selected_locale') ?? 'hi';
  
  // Initialize date formatting for localization (Required for Hindi dates)
  await initializeDateFormatting(null, null);

  // Initialize Local Database (Drift/SQLite)
  final database = AppDatabase();
  
  // Initialize Repositories with Database instance
  final farmerRepository = FarmerRepository(database);
  final workRepository = WorkRepository(database);

  // Run the App with MultiProvider for State Management
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(initialLanguageCode: languageCode)),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FarmerProvider(farmerRepository)),
        ChangeNotifierProvider(create: (_) => WorkProvider(workRepository)),
      ],
      child: const TractorKhataApp(),
    ),
  );
}

/// ---------------------------------------------------------------------------
/// Root Widget: TractorKhataApp
/// ---------------------------------------------------------------------------
class TractorKhataApp extends StatelessWidget {
  const TractorKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, AuthProvider>(
      builder: (context, localeProvider, authProvider, child) {
        return MaterialApp(
          title: 'Tractor Khata',
          debugShowCheckedModeBanner: false,
          
          // --- Localization Configuration ---
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('hi', ''), // Hindi
            Locale('en', ''), // English
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // --- Theme Configuration ---
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50],
            
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
            
            // Global Page Transitions (Fade + Slide Up - Material 3 Style)
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeSlideUpTransitionBuilder(),
                TargetPlatform.iOS: FadeSlideUpTransitionBuilder(),
              },
            ),
            
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          
          // --- Routing Logic ---
          home: authProvider.isAuthenticated ? const FarmerListScreen() : const LoginScreen(),
          
          routes: {
            '/login': (context) => const LoginScreen(),
            '/farmer_list': (context) => const FarmerListScreen(),
            '/add_farmer': (context) => const AddFarmerScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/rate_card': (context) => const RateCardScreen(),
            '/add_work_type': (context) => const AddWorkTypeScreen(),
          },
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// Custom Page Transition Builder
/// Smooth Fade + Slide Up (Material 3 Style)
/// ---------------------------------------------------------------------------
class FadeSlideUpTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Slide up from 10% down
    const begin = Offset(0.0, 0.10);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(slideTween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child,
      ),
    );
  }
}
