# Project Folder Structure

This project follows a Clean Architecture approach, separating concerns into distinct layers: UI, Core, and Data.

## Root Directory
- `lib/`: Contains all Dart code.
- `assets/`: Images, translations, and other static assets.
- `test/`: Unit and widget tests.

## `lib/` Directory Structure

### `core/` (Business Logic & Utilities)
Contains core business logic, providers, services, and utilities that are used across the application.
- `providers/`: State management using the Provider package (e.g., `auth_provider.dart`, `farmer_provider.dart`).
- `services/`: External services and helpers (e.g., `localization_service.dart`).
- `utils/`: Helper classes and extensions (e.g., `color_utils.dart`).
- `models/`: Data models (if separated from Drift entities).

### `data/` (Data Layer)
Handles data storage and retrieval.
- `local/`: Local database implementation (Drift/SQLite) (e.g., `database.dart`).
- `repository/`: Repositories that abstract data sources (e.g., `farmer_repository.dart`).

### `ui/` (Presentation Layer)
Contains all UI-related code, including screens, widgets, and themes.
- `screens/`: Application screens organized by feature.
  - `auth/`: Login and authentication screens.
  - `dashboard/`: Main dashboard and lists.
  - `farmer/`: Farmer management screens.
  - `work/`: Work and payment management screens.
  - `settings/`: Settings and profile screens.
- `components/`: Reusable UI components (widgets).
  - `buttons/`: Custom buttons (e.g., `scale_button.dart`).
  - `dialogs/`: Custom dialogs and bottom sheets.
  - `list_items/`: List item widgets.
- `theme/`: App theming configuration.
  - `app_theme.dart`: Main theme data.
  - `colors.dart`: Color palette.
  - `typography.dart`: Text styles.

### `docs/`
Project documentation.
