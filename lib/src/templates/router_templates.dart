import '../cli/questions.dart';

class RouterTemplates {
  static String generateGoRouter(ProjectConfig config) {
    final routes = StringBuffer();
    final imports = StringBuffer();

    imports.writeln("import 'package:go_router/go_router.dart';");
    if (!config.screens.contains('Home')) {
      imports.writeln("import 'package:flutter/material.dart';");
    }

    String initialLocation = '/';

    if (config.screens.contains('Splash')) {
      imports.writeln("import '../presentation/screens/splash_screen.dart';");
      routes.writeln('''
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),''');
      initialLocation = '/splash';
    }

    if (config.screens.contains('Login / Signup')) {
      imports.writeln("import '../presentation/screens/login_screen.dart';");
      routes.writeln('''
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),''');
    }

    if (config.screens.contains('Home')) {
      imports.writeln("import '../presentation/screens/home_screen.dart';");
      routes.writeln('''
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),''');
    } else {
      // Fallback home if not selected
      routes.writeln('''
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Home'))),
    ),''');
    }

    if (config.screens.contains('Profile')) {
      imports.writeln("import '../presentation/screens/profile_screen.dart';");
      routes.writeln('''
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),''');
    }

    if (config.screens.contains('Settings')) {
      imports.writeln("import '../presentation/screens/settings_screen.dart';");
      routes.writeln('''
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),''');
    }

    return '''
${imports.toString()}

final router = GoRouter(
  initialLocation: '$initialLocation',
  routes: [
${routes.toString()}
  ],
);
''';
  }

  static String generateGetXPages(ProjectConfig config) {
    final pages = StringBuffer();
    final imports = StringBuffer();

    imports.writeln("import 'package:get/get.dart';");
    if (!config.screens.contains('Home')) {
      imports.writeln("import 'package:flutter/material.dart';");
    }

    String initialRoute = '/';

    if (config.screens.contains('Splash')) {
      imports.writeln("import '../presentation/screens/splash_screen.dart';");
      pages.writeln('''
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
    ),''');
      initialRoute = '/splash';
    }

    if (config.screens.contains('Login / Signup')) {
      imports.writeln("import '../presentation/screens/login_screen.dart';");
      pages.writeln('''
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),''');
    }

    if (config.screens.contains('Home')) {
      imports.writeln("import '../presentation/screens/home_screen.dart';");
      pages.writeln('''
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
    ),''');
    } else {
      pages.writeln('''
    GetPage(
      name: '/',
      page: () => const Scaffold(body: Center(child: Text('Home'))),
    ),''');
    }

    if (config.screens.contains('Profile')) {
      imports.writeln("import '../presentation/screens/profile_screen.dart';");
      pages.writeln('''
    GetPage(
      name: '/profile',
      page: () => const ProfileScreen(),
    ),''');
    }

    if (config.screens.contains('Settings')) {
      imports.writeln("import '../presentation/screens/settings_screen.dart';");
      pages.writeln('''
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
    ),''');
    }

    return '''
${imports.toString()}

class AppPages {
  static const initial = '$initialRoute';

  static final routes = [
${pages.toString()}
  ];
}
''';
  }
}
