import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import '../../../data/local/database.dart';
import '../../../data/repository/farmer_repository.dart';
import '../../../data/repository/work_repository.dart';
import '../../../core/services/localization_service.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/farmer_provider.dart';
import '../../../core/providers/work_provider.dart';
import '../../../main.dart'; // To access TractorKhataApp

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Initialize Firebase & Prefs in parallel
    final initFutures = await Future.wait([
      Firebase.initializeApp(),
      SharedPreferences.getInstance(),
      initializeDateFormatting(null, null),
    ]);

    final prefs = initFutures[1] as SharedPreferences;
    final languageCode = prefs.getString('selected_locale') ?? 'hi';

    // 2. Initialize Database & Repositories
    final database = AppDatabase();
    final farmerRepository = FarmerRepository(database);
    final workRepository = WorkRepository(database);

    if (!mounted) return;

    // 3. Re-run the app with Providers and Main App
    // We use a callback or just replace the root widget
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green, // Brand color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Icon
              const Icon(
                Icons.agriculture,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tractor Khata',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
