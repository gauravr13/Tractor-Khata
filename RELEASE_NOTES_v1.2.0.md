# Release Notes v1.2.0

## 🚀 Performance & Optimization
- **App Size Reduced**: Enabled resource shrinking and code minification (ProGuard/R8).
- **Optimized Build**: Removed unused resources and enabled tree-shaking.
- **Smooth 60 FPS**: Optimized list rendering and animations.

## ✨ UI & Animations
- **Global Transitions**: Implemented "Fade + Slide Up" (Material 3 style) for all screens.
- **Add Farmer**: Now opens in a modern **Bottom Sheet** with elastic animation.
- **Time Picker**: Rebuilt as a premium **iOS-style Picker** with:
  - Smooth scroll physics.
  - Live updates (Total Time updates instantly).
  - Localized AM/PM (Hindi/English).
- **Driver Profile**: Added **Image Cropping** and preview for profile photos.

## 🐛 Bug Fixes
- **Unknown Work Title**: Fixed issue where work types were not loading in Farmer Profile.
- **Column Conflict**: Resolved import conflict in Add Farmer screen.
- **Imports**: Fixed missing imports in Farmer List screen.

## 🛠 Internal Cleanup
- **Code Structure**: Refactored Time Picker and Add Farmer screens for modularity.
- **Dependencies**: Added `image_cropper` for profile photo editing.
