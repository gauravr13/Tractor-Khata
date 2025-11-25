# 🚜 Tractor Khata

**Version:** 1.1.0  
**Language:** Hindi (हिंदी)  
**Platform:** Android  
**License:** MIT

---

## 📱 For End Users / उपयोगकर्ताओं के लिए

**हिंदी में App की पूरी जानकारी चाहिए?**  
👉 **[User Guide (Hindi) - ऐप की विस्तृत जानकारी](USER_GUIDE_HINDI.md)**

_Looking for the complete app guide in Hindi? Click the link above!_

---

## 📱 Overview

**Tractor Khata** is a comprehensive work and payment management mobile application designed specifically for tractor drivers in India. The app is fully localized in Hindi and helps drivers efficiently manage farmer accounts, work records, payment tracking, and financial transactions.

**Tractor Khata** is a Flutter-based Android application that addresses the unique needs of tractor drivers who work with multiple farmers. The app provides an intuitive interface for:

- Managing farmer/client profiles
- Recording work sessions with precise time tracking
- Calculating payments based on hourly rates
- Tracking pending and received payments
- Maintaining complete transaction history
- Managing custom work types and rate cards

The entire application is designed with a **Hindi-first approach**, featuring native language support for dates, numbers, and all UI elements.

---

## ✨ Features

### 👨‍🌾 Farmer Management
- Create and manage farmer profiles with contact information
- Quick search functionality by name or phone number
- Individual dashboards for each farmer showing transaction summaries
- Profile editing and deletion with confirmation dialogs

### 💼 Work Tracking
- Define custom work types (plowing, sowing, harvesting, etc.)
- Record work sessions with start and end times
- Automatic duration calculation in hours and minutes
- Set custom hourly rates per work type
- Auto-calculate total payment based on duration and rate
- Add notes and custom work descriptions
- Date-wise work history

### 💰 Payment Management
- Record payments received from farmers
- Track pending (outstanding) amounts
- Track total received payments
- Complete transaction timeline with work entries and payments
- Payment date tracking
- Optional notes for payment records

### 📊 Dashboard & Analytics
- Per-farmer dashboard with financial summary
- Total pending amount display
- Total received amount display
- Work count statistics
- Chronological transaction history
- Color-coded cards for different transaction types

### 📝 Rate Card System
- Create and manage work type categories
- Set custom hourly rates for each work type
- Edit and delete work types
- Reusable rate presets for quick work entry

### 👤 Driver Profile
- Personal profile management
- Profile photo upload from camera or gallery
- Contact information storage
- Email and phone number tracking

### 🌐 Localization
- **Full Hindi language support**
- Localized date formatting
- Hindi numerals for duration display
- Language toggle (Hindi/English)
- Persistent language preference

### 🎨 Modern UI/UX
- Material Design 3 implementation
- Clean and intuitive card-based interface
- Responsive layouts optimized for mobile
- Smooth 60 FPS animations
- Touch-friendly controls
- Contextual action buttons
- Safe delete workflows with confirmations

---

## 🏗️ Architecture & Technical Details

### Technology Stack

- **Framework:** Flutter 3.9+
- **Language:** Dart
- **Database:** SQLite with Drift ORM (v2.29.0)
- **State Management:** Provider pattern
- **Authentication:** Firebase Authentication + Google Sign-In
- **UI Framework:** Material Design 3
- **Fonts:** Google Fonts (Poppins)
- **Localization:** Flutter Intl with custom localization service

### Key Technical Features

**Database Architecture:**
- Local SQLite database for offline-first functionality
- Drift ORM for type-safe database operations
- Efficient query optimization
- Relationship management between farmers, works, and payments

**State Management:**
- Provider pattern for reactive state updates
- Separation of concerns with dedicated providers:
  - `FarmerProvider` - Farmer data management
  - `WorkProvider` - Work and payment transactions
  - `LocaleProvider` - Language preference
  - `AuthProvider` - Authentication state
  - `DriverProvider` - Driver profile management

**Performance Optimizations:**
- Parallel initialization to reduce startup time
- ListView with `cacheExtent` for smooth scrolling
- Hero animations for seamless transitions
- Lightweight widget trees
- Efficient rebuild optimization

**Code Organization:**
```
lib/
├── database/          # Drift database models and DAOs
├── providers/         # State management providers
├── repositories/      # Data access layer
├── screens/          # UI screens
├── services/         # Business logic services
├── widgets/          # Reusable custom widgets
└── main.dart         # App entry point
```

---

## ⚠️ Important Notes

### Offline-First Architecture

This application operates in **offline mode** by default:
- Internet connection required **only for initial Google Sign-In**
- All data stored locally in SQLite database
- No cloud backup or synchronization
- **Data will be permanently lost on app uninstall**

### Data Persistence Warning

> **⚠️ CRITICAL:** This is a local-only application. All farmer records, work history, and payment data are stored exclusively on the device. Uninstalling the app will result in complete data loss with no recovery option.
>
> **Future Versions:** Cloud backup and data export features are planned for upcoming releases.

### Security & Privacy

- All data remains on the user's device
- No data transmission to external servers (except Google authentication)
- No analytics or tracking
- No advertisements
- Google Sign-In used only for user authentication

---

## 📥 Installation

### For End Users

1. Download the latest APK from [Releases](https://github.com/YOUR_USERNAME/tractor-khata/releases)
2. Enable "Install from Unknown Sources" in Android settings if prompted
3. Install the APK
4. Sign in with your Google account
5. Grant necessary permissions (camera, storage for profile photos)
6. Start managing your work records!

### For Developers

**Prerequisites:**
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0+
- Android Studio / VS Code with Flutter extensions
- Firebase project setup (for authentication)

**Setup:**

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/tractor-khata.git
cd tractor-khata
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Drift database code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Configure Firebase:
   - Create a Firebase project
   - Add Android app to Firebase project
   - Download `google-services.json`
   - Place in `android/app/` directory
   - Enable Google Sign-In in Firebase Authentication

5. Run the app:
```bash
flutter run
```

**Build Release APK:**
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🛠️ Development

### Project Structure

```
tractor-khata/
├── android/              # Android-specific code
├── assets/
│   ├── images/          # App logo and images
│   └── translations/    # i18n JSON files (hi.json, en.json)
├── lib/
│   ├── database/
│   │   └── database.dart          # Drift database schema
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── farmer_provider.dart
│   │   ├── work_provider.dart
│   │   ├── driver_provider.dart
│   │   └── locale_provider.dart
│   ├── repositories/
│   │   ├── farmer_repository.dart
│   │   └── work_repository.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── farmer_list_screen.dart
│   │   ├── farmer_profile_screen.dart
│   │   ├── add_farmer_screen.dart
│   │   ├── add_work_screen.dart
│   │   ├── add_payment_screen.dart
│   │   ├── rate_card_screen.dart
│   │   ├── settings_screen.dart
│   │   └── driver_profile_screen.dart
│   ├── services/
│   │   └── localization_service.dart
│   ├── widgets/
│   │   └── time_picker_popup.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

### Database Schema

**Tables:**
- `farmers` - Farmer profiles
- `work_types` - Predefined work categories with rates
- `works` - Individual work sessions
- `payments` - Payment records
- `driver_profile` - Driver information

**Relationships:**
- One-to-Many: Farmer → Works
- One-to-Many: Farmer → Payments
- Many-to-One: Work → WorkType (optional)

### Adding New Features

1. Create feature branch
2. Implement changes
3. Test thoroughly (especially data persistence)
4. Update relevant documentation
5. Submit pull request

---

## 📸 Screenshots

_Screenshots coming soon..._

---

## 🚀 Roadmap

### Planned Features (v1.2.0+)

- [ ] Cloud backup integration (Firebase/Google Drive)
- [ ] Data export to Excel/PDF
- [ ] WhatsApp sharing for invoices
- [ ] Fuel expense tracking
- [ ] Multiple language support (English, Punjabi, Marathi)
- [ ] Dark mode
- [ ] Calendar view for work history
- [ ] Advanced filtering and search
- [ ] Backup/Restore functionality
- [ ] Print functionality

### Known Issues

- None reported yet

---

## 🤝 Contributing

Contributions are welcome! This is an open-source project designed to help tractor drivers manage their business more efficiently.

**How to Contribute:**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

**Contribution Guidelines:**
- Follow Flutter/Dart style guidelines
- Maintain backward compatibility
- Add tests for new features
- Update documentation
- Ensure the app works offline
- Test on multiple Android versions

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Created with ❤️ for the tractor driver community of India.

---

## 📞 Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Check existing issues before creating new ones
- Provide detailed information for bug reports

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- Drift team for the excellent ORM
- All contributors and users

---

## 📊 Stats

- **Current Version:** 1.1.0
- **Downloads:** -
- **Stars:** -
- **Last Updated:** November 25, 2024

---

## 📝 Changelog

### Version 1.1.0 (November 25, 2024)
- ✨ Redesigned work and payment cards with improved spacing
- ✨ Enhanced Hindi localization (dates, duration text)
- ✨ Safer delete workflow (moved delete to edit screens)
- ✨ Better layout management for long text content
- ✨ Improved UI with larger icons and better typography
- ✨ Added dividers and visual hierarchy improvements
- 🐛 Fixed date formatting initialization
- 🐛 Fixed space management in cards

### Version 1.0.0 (November 24, 2024)
- 🎉 Initial release
- ✅ Farmer management
- ✅ Work tracking with time-based calculations
- ✅ Payment management
- ✅ Rate card system
- ✅ Driver profile
- ✅ Hindi localization
- ✅ Offline-first architecture
- ✅ Google Sign-In authentication

---

**Made in India 🇮🇳**

> **Note:** While the UI is in Hindi for end users, all code, comments, and documentation are in English for the developer community.
