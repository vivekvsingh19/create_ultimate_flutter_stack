# Contributing to CUFS

Thank you for your interest in contributing to CUFS (Create Ultimate Flutter Stack)! We welcome contributions from the community.

## 🌟 Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🎨 Add new themes
- 🔧 Fix issues
- 📦 Add new templates

## 🚀 Getting Started

### Prerequisites

- Dart SDK (>=3.0.0 <4.0.0)
- Flutter SDK
- Git

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/yourusername/create_ultimate_flutter_stack.git
cd create_ultimate_flutter_stack

# Install dependencies
dart pub get

# Run the CLI locally
dart bin/cufs.dart create test_app
```

## 📋 Development Guidelines

### Code Style

- Follow Dart's official style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

### Testing Your Changes

Before submitting a PR, ensure:

```bash
# Run analysis
dart analyze

# Test different configurations
dart bin/cufs.dart create test_provider --test-config '{"stateManagement": "Provider", "backend": "None", "router": "GoRouter", "theme": "Material 3", "screens": ["Home"]}'

# Verify generated project
cd test_provider
flutter analyze
```

### Project Structure

```
lib/
├── cufs.dart              # Main CLI entry point
├── src/
│   ├── cli/
│   │   └── questions.dart # Interactive prompts
│   ├── core/
│   │   └── generator.dart # Project generation logic
│   ├── templates/
│   │   ├── app_file.dart        # App widget template
│   │   ├── main_file.dart       # Main.dart template
│   │   ├── theme_templates.dart # Theme templates
│   │   ├── screen_templates.dart # Screen templates
│   │   ├── widget_templates.dart # Widget templates
│   │   ├── backend_templates.dart # Backend service templates
│   │   └── pubspec_template.dart # Pubspec.yaml template
│   └── utils/
│       └── file_utils.dart # File operations
```

## 🎨 Adding New Features

### Adding a New Theme

1. Open `lib/src/templates/theme_templates.dart`
2. Add your theme function:
```dart
String _yourTheme() {
  return '''
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    // Your theme configuration
  );

  static final darkTheme = ThemeData(
    // Your dark theme configuration
  );
}
''';
}
```
3. Update `generateThemeDart()` to include your theme
4. Add the option to `lib/src/cli/questions.dart`

### Adding a New Backend

1. Open `lib/src/templates/backend_templates.dart`
2. Add authentication and database service generators
3. Update `lib/src/templates/pubspec_template.dart` to include dependencies
4. Add the option to questions

## 📝 Pull Request Process

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### PR Guidelines

- Provide a clear description of changes
- Reference related issues
- Include screenshots for UI changes
- Ensure all tests pass
- Update documentation if needed

## 🐛 Reporting Bugs

When reporting bugs, please include:

- Your OS and version
- Dart/Flutter SDK versions
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## 💡 Feature Requests

We love new ideas! When suggesting features:

- Explain the use case
- Describe the expected behavior
- Consider backward compatibility
- Provide examples if possible

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community

## 🙏 Recognition

Contributors will be acknowledged in:
- The project README
- Release notes
- GitHub contributors page

## 📞 Questions?

Feel free to:
- Open an issue for discussion
- Join community discussions
- Reach out to maintainers

---

**Thank you for making CUFS better!** 🚀✨
