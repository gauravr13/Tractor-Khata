# Contributing to Tractor Khata

First off, thank you for considering contributing to Tractor Khata! This app is designed to help tractor drivers in India manage their business efficiently, and your contributions can make a real difference.

## 🎯 Project Goal

Our mission is to create a reliable, offline-first mobile application that helps tractor drivers track their work and payments with minimal technical knowledge required from end users.

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots** if applicable
- **Device information** (Android version, device model)
- **App version**

### Suggesting Features

Feature suggestions are welcome! Please:

- Use a clear and descriptive title
- Provide detailed description of the proposed feature
- Explain why this feature would be useful
- Consider the offline-first nature of the app

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 💻 Development Setup

### Prerequisites

- Flutter SDK 3.9.2+
- Android Studio or VS Code with Flutter extensions
- Firebase account (for authentication setup)
- Basic knowledge of Dart and Flutter

### Setup Steps

1. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/tractor-khata.git
cd tractor-khata
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate database code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Set up Firebase (see README.md for details)

5. Run the app:
```bash
flutter run
```

## 📝 Code Guidelines

### Dart Style

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues

### Code Organization

- Keep files focused and single-purpose
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and readable

### Commit Messages

- Use clear and meaningful commit messages
- Start with a verb in present tense (Add, Fix, Update, Remove)
- Reference issue numbers when applicable
- Examples:
  - `Add cloud backup feature`
  - `Fix date formatting in Hindi locale`
  - `Update README with installation steps`

### Testing

- Test thoroughly on real Android devices
- Test offline functionality
- Test data persistence
- Test with different Android versions
- Test Hindi and English languages
- Verify database migrations work correctly

## 🌍 Localization

- All UI text must be localized
- Add new strings to both `hi.json` and `en.json`
- Maintain consistency with existing translation patterns
- Test with both Hindi and English languages

## 🎨 UI/UX Guidelines

- Follow Material Design 3 principles
- Maintain consistency with existing UI
- Keep the interface simple and intuitive
- Remember the target audience (tractor drivers with varying technical skills)
- Test on devices with different screen sizes
- Ensure touch targets are appropriately sized

## ⚠️ Important Considerations

### Offline-First

- All core features must work without internet
- Database operations should be efficient
- Handle edge cases (empty states, errors)
- Test app behavior with network off

### Data Persistence

- Be extremely careful with database migrations
- Never delete user data without explicit consent
- Test data integrity thoroughly
- Document any breaking database changes

### Performance

- Keep the app lightweight
- Optimize ListView scrolling
- Minimize rebuilds
- Use const constructors where possible
- Profile performance regularly

## 🔍 Code Review Process

All pull requests will be reviewed for:

- Code quality and style compliance
- Functionality and correctness
- Performance impact
- Backward compatibility
- Documentation updates
- Test coverage

## 📚 Documentation

- Update README.md for new features
- Add code comments for complex logic
- Update CHANGELOG.md
- Include screenshots for UI changes

## 🐛 Bug Fix Checklist

- [ ] Issue is reproducible
- [ ] Root cause identified
- [ ] Fix implemented
- [ ] Tested on multiple devices
- [ ] No regression in existing features
- [ ] Code follows project guidelines
- [ ] Commit message is clear

## ✨ Feature Addition Checklist

- [ ] Feature aligns with project goals
- [ ] Design is discussed/approved
- [ ] Implementation is complete
- [ ] Feature works offline
- [ ] Localization added (Hindi + English)
- [ ] Documentation updated
- [ ] Tested thoroughly
- [ ] No breaking changes

## 📦 Release Process

Releases are managed by the project maintainer:

1. Version bump in `pubspec.yaml`
2. Update CHANGELOG.md
3. Build release APK
4. Create GitHub release
5. Upload APK to release

## 🙏 Recognition

Contributors will be:
- Listed in the project README
- Credited in release notes
- Appreciated for their valuable time and effort

## ❓ Questions?

Feel free to:
- Open an issue for questions
- Tag maintainers in discussions
- Ask for clarification on contribution guidelines

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making Tractor Khata better! 🚜🙏
