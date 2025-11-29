# Architecture Guide

## Overview
Tractor Khata uses a **Clean Architecture** inspired structure combined with **Provider** for state management. The goal is to separate the UI from the business logic and data access layers, making the app testable, maintainable, and scalable.

## Layers

### 1. Presentation Layer (`lib/ui`)
- **Responsibility**: Renders the UI and handles user interactions.
- **Components**: Screens, Widgets, Themes.
- **State Management**: Consumes `Providers` to display data and trigger actions.
- **Rules**: 
  - Should not contain business logic.
  - Should not access the database directly.
  - Must use `AppTheme` for styling.

### 2. Domain/Core Layer (`lib/core`)
- **Responsibility**: Contains the business logic and state of the application.
- **Components**: Providers, Services, Models.
- **State Management**: `ChangeNotifier` classes (Providers) hold the state and notify listeners.
- **Rules**:
  - `Providers` interact with `Repositories` to fetch/save data.
  - `Services` handle external interactions (e.g., Localization).

### 3. Data Layer (`lib/data`)
- **Responsibility**: Manages data storage and retrieval.
- **Components**: Repositories, Local Database (Drift).
- **Rules**:
  - `Repositories` provide a clean API for the Domain layer.
  - `Database` handles the actual SQL operations.

## Data Flow
1. **User Action**: User taps a button in the UI (e.g., "Add Farmer").
2. **UI -> Provider**: The UI calls a method in the `FarmerProvider` (e.g., `addFarmer()`).
3. **Provider -> Repository**: The Provider calls the `FarmerRepository` (e.g., `insertFarmer()`).
4. **Repository -> Database**: The Repository executes the query on the `AppDatabase`.
5. **Database -> Repository**: Returns the result (e.g., new Farmer ID).
6. **Repository -> Provider**: Returns the result or updated list.
7. **Provider -> UI**: The Provider updates its state (e.g., `_farmers` list) and calls `notifyListeners()`.
8. **UI Update**: The UI rebuilds to show the new data.

## Key Technologies
- **Flutter**: UI Framework.
- **Provider**: State Management.
- **Drift**: SQLite ORM for local storage.
- **Firebase Auth**: Google Sign-In.
