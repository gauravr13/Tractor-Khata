# Tractor Khata - Complete Technical Documentation

**Version:** 2.0.0 (Optimized Release)  
**Platform:** Flutter (Android & iOS)  
**Last Updated:** November 25, 2025

---

## Table of Contents

1. Project Overview
2. Key Features & Optimizations
3. Complete File Structure
4. Screen-by-Screen Details
5. Providers / Controllers Explanation
6. Database Layer Documentation
7. Business Logic Mapping
8. Dependencies Documentation
9. Known Issues / Code Smells
10. Summary

---

## 1. Project Overview

### What This App Does

**Tractor Khata** is a high-performance work tracking and accounting application designed specifically for tractor drivers in India. It helps drivers manage farmers, track work sessions, calculate earnings, receive payments, and maintain a rate card.

### Main Features

1.  **Farmer Management** - Add, edit, delete, search farmers with smooth animations.
2.  **Work Tracking** - Record work with an optimized custom time picker, auto-calculate duration and earnings.
3.  **Payment Tracking** - Record payments received from farmers.
4.  **Rate Card System** - Define work types with hourly rates.
5.  **Dashboard** - View total earnings, pending amounts, and work count.
6.  **Driver Profile** - Manage personal profile with photo (synced with Google or local).
7.  **Localization** - Full Hindi & English support with instant switching.
8.  **Authentication** - Google Sign-In with session persistence.

### Architecture
-   **Pattern:** MVVM (Model-View-ViewModel) using Provider.
-   **Local-First:** All data stored in SQLite (Drift) for offline access.
-   **Performance-First:** 60 FPS target, optimized startup, lightweight widgets.

---

## 2. Key Features & Optimizations (v2.0)

### 🚀 Performance
-   **Instant Startup:** Parallel initialization of Firebase and SharedPreferences using `Future.wait`.
-   **60 FPS Animations:** Global `ZoomPageTransitionsBuilder` for smooth screen transitions.
-   **Fluid Scrolling:** `BouncingScrollPhysics` applied globally.
-   **List Optimization:** `cacheExtent` used in `ListView` to preload items and prevent jank.
-   **GPU Optimization:** Reduced shadow blur radii and used lightweight borders instead of heavy elevations where possible.
-   **Memory Management:** `const` widgets used extensively; `Hero` animations for efficient image transitions.

### 🎨 UI/UX
-   **Unified Design:** Consistent typography (`GoogleFonts`), rounded corners (12px), and color palette.
-   **Animated Search:** Smooth expanding search bar in Farmer List.
-   **Custom Time Picker:** High-performance 3D wheel picker with haptic feedback.
-   **Hero Transitions:** Avatar transitions between list and profile screens.

---

## 3. Complete File Structure

### lib/main.dart
-   **Purpose:** App entry point.
-   **Logic:** Parallel init, MultiProvider setup, Global Theme (CardThemeData, PageTransitions), LocaleProvider.

### lib/services/localization_service.dart
-   **Purpose:** Handles app localization.
-   **Logic:** Loads JSON files from `assets/translations/`, provides `translate()` method.

### lib/widgets/time_picker_popup.dart
-   **Purpose:** Reusable, optimized time picker widget.
-   **Logic:** ListWheelScrollView with FixedExtentScrollPhysics, AM/PM toggle.

### lib/database/tables.dart
-   **Purpose:** Database schema definitions.
-   **Contains:** Farmers, WorkTypes, Works, Payments table classes.

### lib/database/database.dart
-   **Purpose:** Main database class with DAO methods.
-   **Contains:** AppDatabase class, CRUD methods, Aggregate queries.

### lib/repositories/farmer_repository.dart
-   **Purpose:** Farmer data access layer.
-   **Methods:** getAllFarmers, addFarmer, updateFarmer, deleteFarmer, searchFarmers.

### lib/repositories/work_repository.dart
-   **Purpose:** Work & Payment data access layer.
-   **Methods:** Work types CRUD, work entries CRUD, payment CRUD, pending amount calculations.

### lib/providers/
-   **auth_provider.dart:** Google Sign-In state.
-   **farmer_provider.dart:** Farmer list management.
-   **work_provider.dart:** Work/Payment logic, calculations.
-   **driver_provider.dart:** Driver profile (photo, name) management.
-   **locale_provider.dart:** Language state management.

### lib/screens/
-   **login_screen.dart:** Google Sign-In.
-   **farmer_list_screen.dart:** Main dashboard, optimized list, search.
-   **add_farmer_screen.dart:** Add/Edit farmer.
-   **farmer_profile_screen.dart:** Detailed view, work history, payment history.
-   **add_work_screen.dart:** Add work entry with calculations.
-   **add_payment_screen.dart:** Record payment.
-   **settings_screen.dart:** App settings, language, profile link.
-   **rate_card_screen.dart:** Manage work rates.
-   **add_work_type_screen.dart:** Add work type.
-   **driver_profile_screen.dart:** View driver details.
-   **edit_driver_profile_screen.dart:** Edit driver details.

---

## 4. Database Layer

### Tables

**Farmers**
-   id (PK), name, phone, notes, createdAt

**WorkTypes**
-   id (PK), name, ratePerHour

**Works**
-   id (PK), farmerId (FK), workTypeId, customWorkName, startTime, endTime, durationInMinutes, ratePerHour, totalAmount, workDate, notes

**Payments**
-   id (PK), farmerId (FK), amount, date, notes

---

## 5. Business Logic

### Time & Amount Calculation
-   **Location:** `add_work_screen.dart`
-   **Logic:** 
    -   `Duration = EndTime - StartTime` (Handles overnight).
    -   `Amount = (Duration / 60) * Rate`.

### Pending Amount Calculation
-   **Location:** `work_repository.dart`
-   **Logic:** `Total Pending = Sum(Work Amounts) - Sum(Payment Amounts)`.
-   **Optimization:** Aggregated in SQL for performance.

### Localization
-   **Files:** `assets/translations/hi.json`, `en.json`.
-   **Logic:** Key-value pairs. `AppLocalizations.of(context).translate('key')`.

---

## 6. Dependencies

-   **firebase_core, firebase_auth, google_sign_in:** Authentication.
-   **drift, sqlite3_flutter_libs:** Database.
-   **provider:** State Management.
-   **intl:** Date Formatting.
-   **shared_preferences:** Settings persistence.
-   **image_picker, image:** Profile photo handling.
-   **google_fonts:** Typography.
-   **path_provider:** File storage.

---

## 7. Known Issues

1.  **R8 Compilation:** Release build requires `isMinifyEnabled = false` (Fixed in build.gradle).
2.  **Large Lists:** `cacheExtent` helps, but true pagination is not implemented (not needed for < 10k items).

---

## 8. Summary

**Tractor Khata v2.0** is a production-ready, optimized Flutter application. It demonstrates best practices in:
-   **Performance:** Parallel loading, 60 FPS animations.
-   **Architecture:** Clean MVVM with Repository pattern.
-   **UX:** Native-feel transitions and haptics.
-   **Localization:** Deep integration of Hindi/English.

The codebase is modular, type-safe, and designed for maintainability.
