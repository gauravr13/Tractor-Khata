# Lessons Learned & Critical Rules

## 1. Deployment Verification
**Mistake:** Assuming a build/run command succeeded without checking the terminal output.
**Correction:** ALWAYS use `command_status` to verify that `flutter run` or `flutter build` has successfully completed (or reached the "Syncing files..." stage) before responding to the user.
**User Instruction:** "responce tb tl complete mt kiya karo jb taak run pura devise m n ho jy" (Do not complete response until run is fully on device).

## 2. Material 3 Card Theming
**Issue:** `CardTheme` in `main.dart` caused build failures (Gradle exit code 1) in this specific project environment.
**Issue:** Default Material 3 Cards have a surface tint (green/purple) based on the seed color.
**Solution:** 
- Do NOT use `CardTheme` in `main.dart` if it causes instability.
- Manually set `color: Colors.white` and `surfaceTintColor: Colors.transparent` on every `Card` widget to ensure a clean, professional white look without tints.

## 3. User Preferences
- **Theme:** Strict Green/Red/Blue palette. No Purple.
- **Summary Boxes:** Filled colors (Red/Green background) are preferred over white boxes with borders.
- **Workflow:** Fix one thing at a time, verify it works, then proceed.
