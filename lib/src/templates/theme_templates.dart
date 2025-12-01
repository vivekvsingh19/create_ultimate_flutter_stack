import '../cli/questions.dart';

String generateThemeDart(ProjectConfig config) {
  if (config.theme == 'Neumorphic') {
    return _neumorphicTheme();
  } else if (config.theme == 'Glassmorphism') {
    return _glassmorphismTheme();
  } else if (config.theme == 'Minimal Clean') {
    return _minimalTheme();
  } else {
    return _material3Theme();
  }
}

String _material3Theme() {
  return '''
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
''';
}

String _minimalTheme() {
  return '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.grey,
      surface: Colors.white,
      // background: Colors.white, // Deprecated
    ),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.grey,
      surface: Colors.black,
      // background: Colors.black, // Deprecated
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
''';
}

String _neumorphicTheme() {
  // Real Neumorphism requires custom widgets/decorations usually, but we can set up colors to support it.
  return '''
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lightBg = Color(0xFFE0E5EC);
  static const Color _darkBg = Color(0xFF2E3236);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightBg,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, surface: _lightBg),
    cardTheme: CardThemeData(
      color: _lightBg,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _darkBg,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark, surface: _darkBg),
  );
}
''';
}

String _glassmorphismTheme() {
  // Glassmorphism is mostly about UI components with blur, but we can set a vibrant background.
  return '''
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    // Deep purple base for glass effects
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
    scaffoldBackgroundColor: Colors.deepPurple.shade50,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
  );
}
''';
}
