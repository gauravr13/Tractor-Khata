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
import 'data/local/database.dart';

// --- Provider Imports ---
import 'core/providers/auth_provider.dart';
import 'core/providers/farmer_provider.dart';
import 'core/providers/work_provider.dart';
import 'core/providers/driver_provider.dart';
import 'core/services/localization_service.dart';

// --- Repository Imports ---
import 'data/repository/farmer_repository.dart';
import 'data/repository/work_repository.dart';

// --- Screen Imports ---
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/dashboard/farmer_list_screen.dart';
import 'ui/screens/farmer/add_farmer_screen.dart';
import 'ui/screens/settings/settings_screen.dart';
import 'ui/screens/work/rate_card_screen.dart';
import 'ui/screens/work/add_work_type_screen.dart';

// --- Theme Import ---
import 'ui/theme/app_theme.dart';

/// ---------------------------------------------------------------------------
/// Main Function
/// ---------------------------------------------------------------------------
void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase safely
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize other services
  final prefs = await SharedPreferences.getInstance();
  await initializeDateFormatting(null, null);
  
  // Load saved language preference (Default: Hindi 'hi')
  final languageCode = prefs.getString('selected_locale') ?? 'hi';

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
          
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              primary: Colors.green,
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.poppinsTextTheme(),
            
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            
            cardTheme: CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              headerBackgroundColor: Colors.green,
              headerForegroundColor: Colors.white,
              dayStyle: GoogleFonts.poppins(),
              yearStyle: GoogleFonts.poppins(),
            ),
            
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dayPeriodColor: Colors.green.shade50,
              hourMinuteColor: Colors.grey.shade100,
              hourMinuteTextColor: Colors.black87,
              dialHandColor: Colors.green,
              dialBackgroundColor: Colors.grey.shade100,
            ),
            
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
            ),
            
            dropdownMenuTheme: const DropdownMenuThemeData(
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
              ),
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
