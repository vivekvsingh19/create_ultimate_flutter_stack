# Changelog

All notable changes to the CUFS (Create Ultimate Flutter Stack) CLI tool will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-01

### Added
- ✨ Initial release of CUFS CLI tool
- 🎨 Interactive CLI with beautiful gradient banner
- 📦 Support for 5 state management solutions:
  - Provider
  - GetX
  - Riverpod
  - Bloc
  - MobX
- 🔐 Backend integration support:
  - Firebase (Auth + Firestore)
  - Supabase
  - Appwrite
  - None (frontend only)
- 🧭 Multiple routing options:
  - GoRouter (recommended)
  - GetX Routing
  - Flutter Navigator
- 🎨 4 theme options:
  - Material 3
  - Minimal Clean
  - Neumorphic
  - Glassmorphism
- 🖼️ Automatic screen generation:
  - Splash Screen
  - Login/Signup Screen
  - Home Screen
  - Profile Screen
  - Settings Screen
- 🧩 Common widget templates:
  - Custom Button with loading states
  - Custom TextField with validation
  - Loading Indicator
  - Custom AppBar
- 🏗️ Clean Architecture folder structure
- 📝 Comprehensive README with examples
- ✅ All generated projects pass `flutter analyze`
- 🚀 Global CLI activation support

### Technical Details
- Proper progress indicator completion (no hanging)
- Conditional dependency management (no duplicates)
- Theme templates with modern Material 3 support
- Router-specific code generation
- Null-safe code generation
- Automated test cleanup

---

## Future Releases

### [Unreleased]
Planned features for future releases:
- [ ] More theme options
- [ ] Additional backend services
- [ ] API integration templates
- [ ] Deep linking support
- [ ] Internationalization setup
- [ ] Testing boilerplate
- [ ] CI/CD templates
