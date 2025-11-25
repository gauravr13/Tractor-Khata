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

// --- Utils Imports ---
import 'utils/custom_page_transition.dart';

/// ---------------------------------------------------------------------------
/// Main Function
/// ---------------------------------------------------------------------------
void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize critical services in parallel to optimize startup time
  // 1. Firebase: For Authentication
  // 2. SharedPreferences: For storing local settings (Language, etc.)
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
        // Manages Language/Localization State
        ChangeNotifierProvider(create: (_) => LocaleProvider(initialLanguageCode: languageCode)),
        
        // Manages Driver Profile State
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        
        // Manages Authentication State (Google Sign-In)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Manages Farmer Data State
        ChangeNotifierProvider(create: (_) => FarmerProvider(farmerRepository)),
        
        // Manages Work & Payment Data State
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
    // Consumer2 listens to LocaleProvider and AuthProvider changes
    return Consumer2<LocaleProvider, AuthProvider>(
      builder: (context, localeProvider, authProvider, child) {
        return MaterialApp(
          title: 'Tractor Khata',
          
          // Disable the debug banner in top-right corner
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
            useMaterial3: true, // Enable Material Design 3
            scaffoldBackgroundColor: Colors.grey[100], // Light grey background for better contrast
            
            // Use Google Fonts (Poppins) for a modern look
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
            
            // Optimize Page Transitions
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ScaleFadePageTransitionsBuilder(),
                TargetPlatform.iOS: ScaleFadePageTransitionsBuilder(),
              },
            ),
            
            // AppBar Theme
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0, // Flat design
              scrolledUnderElevation: 2, // Slight elevation on scroll
              centerTitle: false,
              titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            
            // Elevated Button Theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            
            // Card Theme
            // cardTheme: CardTheme(
            //   elevation: 2,
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            //   color: Colors.white,
            //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // ),
            
            // Input Decoration Theme (Text Fields)
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
          // If user is authenticated, show FarmerListScreen, otherwise LoginScreen
          home: authProvider.isAuthenticated ? const FarmerListScreen() : const LoginScreen(),
          
          // Named Routes
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
