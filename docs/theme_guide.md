# Theme Guide

## Overview
The application uses a centralized theme system to ensure consistency in colors, typography, and component styling.

## Files
- `lib/ui/theme/colors.dart`: Defines the `AppColors` palette.
- `lib/ui/theme/typography.dart`: Defines `AppTypography` text styles.
- `lib/ui/theme/app_theme.dart`: Configures the global `ThemeData`.

## Usage

### Colors
Always use `AppColors` or `Theme.of(context).colorScheme` instead of hardcoded colors.

```dart
// Good
color: AppColors.primary
color: Theme.of(context).colorScheme.primary

// Bad
color: Colors.green
color: Color(0xFF4CAF50)
```

### Typography
Use `Theme.of(context).textTheme` or `AppTypography` styles.

```dart
// Good
style: Theme.of(context).textTheme.headlineMedium
style: AppTypography.bodyLarge

// Bad
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
```

### Components
Standard Flutter widgets (Card, ElevatedButton, TextField) are automatically styled by `AppTheme`.

- **Buttons**: Use `ElevatedButton` for primary actions, `OutlinedButton` for secondary.
- **Inputs**: `TextFormField` has a consistent border and padding.
- **Cards**: `Card` has a standard elevation and rounded corners.
