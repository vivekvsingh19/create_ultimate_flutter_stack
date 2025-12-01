import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:mason_logger/mason_logger.dart';
import '../cli/questions.dart';
import '../utils/file_utils.dart';
import '../templates/pubspec_template.dart';
import '../templates/main_file.dart';
import '../templates/app_file.dart';
import '../templates/theme_templates.dart';
import '../templates/screen_templates.dart';
import '../templates/widget_templates.dart';
import '../templates/backend_templates.dart';

class ProjectGenerator {
  final String appName;
  final ProjectConfig config;
  final Logger logger;

  ProjectGenerator({
    required this.appName,
    required this.config,
    required this.logger,
  });

  Future<void> generate() async {
    // 1. Create Flutter Project
    var progress = logger.progress('Creating Flutter project...');
    final result = await Process.run(
      'flutter',
      ['create', appName, '--no-pub'],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail('Failed to create Flutter project: ${result.stderr}');
      return;
    }
    progress.complete('Flutter project created.');

    // Delete broken widget_test.dart
    final widgetTest = File(p.join(appName, 'test/widget_test.dart'));
    if (await widgetTest.exists()) {
      await widgetTest.delete();
    }

    // 2. Update pubspec.yaml
    progress = logger.progress('Updating pubspec.yaml...');
    final pubspecContent = generatePubspec(appName, config);
    await FileUtils.writeFile(p.join(appName, 'pubspec.yaml'), pubspecContent);
    progress.complete();

    // 3. Create Folder Structure
    progress = logger.progress('Creating folder structure...');
    await _createFolders(appName);
    progress.complete();

    // 4. Generate Core Files
    progress = logger.progress('Generating core files...');
    await _generateCoreFiles(appName);
    progress.complete();

    // 5. Generate Screens
    progress = logger.progress('Generating screens...');
    await _generateScreens(appName);
    progress.complete();

    // 6. Generate Common Widgets
    progress = logger.progress('Generating common widgets...');
    await _generateWidgets(appName);
    progress.complete();

    // 7. Generate Backend Services
    if (config.backend != 'None') {
      progress = logger.progress('Generating backend services...');
      await _generateBackendServices(appName);
      progress.complete();
    }

    // 8. Run pub get
    progress = logger.progress('Running flutter pub get...');
    final pubGetResult = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: appName,
      runInShell: true,
    );

    if (pubGetResult.exitCode != 0) {
      progress
          .fail('flutter pub get failed. You might need to run it manually.');
    } else {
      progress.complete('Dependencies installed.');
    }

    logger.success('Project $appName generated successfully! 🚀');
    logger.info('cd $appName && flutter run');
  }

  Future<void> _createFolders(String basePath) async {
    final folders = [
      'lib/core/config',
      'lib/core/themes',
      'lib/core/services',
      'lib/core/utils',
      'lib/data/models',
      'lib/data/repositories',
      'lib/presentation/screens',
      'lib/presentation/widgets',
      'lib/routes',
    ];

    if (config.stateManagement == 'GetX') {
      folders.add('lib/presentation/controllers');
    } else if (config.stateManagement == 'Provider' ||
        config.stateManagement == 'Riverpod') {
      folders.add('lib/presentation/providers');
    } else if (config.stateManagement == 'Bloc') {
      folders.add('lib/presentation/blocs');
    }

    for (final folder in folders) {
      await FileUtils.createDirectory(p.join(basePath, folder));
    }
  }

  Future<void> _generateCoreFiles(String basePath) async {
    // lib/main.dart
    await FileUtils.writeFile(
      p.join(basePath, 'lib/main.dart'),
      generateMainDart(config),
    );

    // lib/presentation/app.dart
    await FileUtils.writeFile(
      p.join(basePath, 'lib/presentation/app.dart'),
      generateAppDart(config),
    );

    // lib/core/themes/app_theme.dart
    await FileUtils.writeFile(
      p.join(basePath, 'lib/core/themes/app_theme.dart'),
      generateThemeDart(config),
    );

    // Router setup
    if (config.router == 'GoRouter') {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/routes/app_router.dart'),
        _generateGoRouter(),
      );
    } else if (config.router == 'GetX Routing') {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/routes/app_pages.dart'),
        _generateGetXPages(),
      );
    }
  }

  Future<void> _generateScreens(String basePath) async {
    if (config.screens.contains('Splash')) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/splash_screen.dart'),
        ScreenTemplates.generateSplashScreen(config),
      );
    }
    if (config.screens.contains('Login / Signup')) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/login_screen.dart'),
        ScreenTemplates.generateLoginScreen(config),
      );
    }
    if (config.screens.contains('Home')) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/home_screen.dart'),
        ScreenTemplates.generateHomeScreen(config),
      );
    }
    if (config.screens.contains('Profile')) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/profile_screen.dart'),
        ScreenTemplates.generateProfileScreen(config),
      );
    }
    if (config.screens.contains('Settings')) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/settings_screen.dart'),
        ScreenTemplates.generateSettingsScreen(config),
      );
    }
  }

  Future<void> _generateWidgets(String basePath) async {
    // Generate common widgets
    await FileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_button.dart'),
      WidgetTemplates.generateCustomButton(),
    );
    await FileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_text_field.dart'),
      WidgetTemplates.generateCustomTextField(),
    );
    await FileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/loading_indicator.dart'),
      WidgetTemplates.generateLoadingIndicator(),
    );
    await FileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_app_bar.dart'),
      WidgetTemplates.generateAppBarWidget(),
    );
  }

  Future<void> _generateBackendServices(String basePath) async {
    // Generate auth service
    final authService = BackendTemplates.generateAuthService(config);
    if (authService.isNotEmpty) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/core/services/auth_service.dart'),
        authService,
      );
    }

    // Generate database service
    final databaseService = BackendTemplates.generateDatabaseService(config);
    if (databaseService.isNotEmpty) {
      await FileUtils.writeFile(
        p.join(basePath, 'lib/core/services/database_service.dart'),
        databaseService,
      );
    }
  }

  String _generateGoRouter() {
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

  String _generateGetXPages() {
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
