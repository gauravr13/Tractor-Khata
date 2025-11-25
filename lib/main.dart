import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'database/database.dart';
import 'providers/auth_provider.dart';
import 'providers/farmer_provider.dart';
import 'providers/work_provider.dart';
import 'providers/driver_provider.dart';
import 'repositories/farmer_repository.dart';
import 'repositories/work_repository.dart';
import 'services/localization_service.dart';
import 'screens/login_screen.dart';
import 'screens/farmer_list_screen.dart';
import 'screens/add_farmer_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/rate_card_screen.dart';
import 'screens/add_work_type_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Parallelize initialization to reduce startup time
  final initFutures = await Future.wait([
    Firebase.initializeApp(),
    SharedPreferences.getInstance(),
  ]);
  
  final prefs = initFutures[1] as SharedPreferences;
  final languageCode = prefs.getString('selected_locale') ?? 'hi';
  
  await initializeDateFormatting(null, null);


  final database = AppDatabase();
  final farmerRepository = FarmerRepository(database);
  final workRepository = WorkRepository(database);

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

class TractorKhataApp extends StatelessWidget {
  const TractorKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, AuthProvider>(
      builder: (context, localeProvider, authProvider, child) {
        return MaterialApp(
          title: 'Tractor Khata',
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('hi', ''),
            Locale('en', ''),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[100],
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0, // Reduced elevation for performance
              scrolledUnderElevation: 2, // Material 3 optimization
              centerTitle: false,
              titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Smoother corners
                ),
                elevation: 2, // Low elevation for performance
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))), // Consistent rounding
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Comfortable touch target
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            cardTheme: const CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
            ),
          ),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollbars: false,
          ),
          home: authProvider.isLoggedIn ? const FarmerListScreen() : const LoginScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const FarmerListScreen(),
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
