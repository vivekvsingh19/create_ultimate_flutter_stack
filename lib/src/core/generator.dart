import 'package:path/path.dart' as p;
import 'package:mason_logger/mason_logger.dart';
import '../cli/questions.dart';
import '../utils/file_utils.dart';
import '../utils/process_runner.dart';
import '../utils/project_structure.dart';
import '../templates/pubspec_template.dart';
import '../templates/main_file.dart';
import '../templates/app_file.dart';
import '../templates/theme_templates.dart';
import '../templates/screen_templates.dart';
import '../templates/widget_templates.dart';
import '../templates/backend_templates.dart';
import '../templates/router_templates.dart';

class ProjectGenerator {
  final String appName;
  final ProjectConfig config;
  final Logger logger;
  final ProcessRunner processRunner;
  final FileUtils fileUtils;

  ProjectGenerator({
    required this.appName,
    required this.config,
    required this.logger,
    required this.processRunner,
    required this.fileUtils,
  });

  Future<void> generate() async {
    // 1. Create Flutter Project
    var progress = logger.progress('Creating Flutter project...');
    final result = await processRunner.run(
      'flutter',
      ['create', appName, '--no-pub'],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail('Failed to create Flutter project: ${result.stderr}');
      return;
    }
    progress.complete('Flutter project created.');

    // 1.5 Initialize Git (or remove it)
    if (config.initializeGit) {
      final gitDirPath = p.join(appName, '.git');
      if (!await fileUtils.exists(gitDirPath)) {
        progress = logger.progress('Initializing git repository...');
        await processRunner.run('git', ['init'], workingDirectory: appName);
        progress.complete('Git repository initialized.');
      }
    } else {
      final gitDirPath = p.join(appName, '.git');
      if (await fileUtils.exists(gitDirPath)) {
        progress = logger.progress('Removing .git directory...');
        await fileUtils.delete(gitDirPath, recursive: true);
        progress.complete('.git directory removed.');
      }
    }

    // Delete broken widget_test.dart
    final widgetTestPath = p.join(appName, 'test/widget_test.dart');
    if (await fileUtils.exists(widgetTestPath)) {
      await fileUtils.delete(widgetTestPath);
    }

    // 2. Update pubspec.yaml
    progress = logger.progress('Updating pubspec.yaml...');
    final pubspecContent = generatePubspec(p.basename(appName), config);
    await fileUtils.writeFile(p.join(appName, 'pubspec.yaml'), pubspecContent);
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

    // 7.5 Update Android Build Configuration
    progress = logger.progress('Updating Android build configuration...');
    await _updateAndroidBuildConfiguration(appName);
    progress.complete();

    // 8. Run pub get
    progress = logger.progress('Running flutter pub get...');
    final pubGetResult = await processRunner.run(
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
    final folders = ProjectStructure.getFolders(config);

    for (final folder in folders) {
      await fileUtils.createDirectory(p.join(basePath, folder));
    }
  }

  Future<void> _generateCoreFiles(String basePath) async {
    // lib/main.dart
    await fileUtils.writeFile(
      p.join(basePath, 'lib/main.dart'),
      generateMainDart(config),
    );

    // lib/presentation/app.dart
    await fileUtils.writeFile(
      p.join(basePath, 'lib/presentation/app.dart'),
      generateAppDart(config),
    );

    // lib/core/themes/app_theme.dart
    await fileUtils.writeFile(
      p.join(basePath, 'lib/core/themes/app_theme.dart'),
      generateThemeDart(config),
    );

    // Router setup
    if (config.router == 'GoRouter') {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/routes/app_router.dart'),
        RouterTemplates.generateGoRouter(config),
      );
    } else if (config.router == 'GetX Routing') {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/routes/app_pages.dart'),
        RouterTemplates.generateGetXPages(config),
      );
    }
  }

  Future<void> _generateScreens(String basePath) async {
    if (config.screens.contains('Splash')) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/splash_screen.dart'),
        ScreenTemplates.generateSplashScreen(config),
      );
    }
    if (config.screens.contains('Login / Signup')) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/login_screen.dart'),
        ScreenTemplates.generateLoginScreen(config),
      );
    }
    if (config.screens.contains('Home')) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/home_screen.dart'),
        ScreenTemplates.generateHomeScreen(config),
      );
    }
    if (config.screens.contains('Profile')) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/profile_screen.dart'),
        ScreenTemplates.generateProfileScreen(config),
      );
    }
    if (config.screens.contains('Settings')) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/presentation/screens/settings_screen.dart'),
        ScreenTemplates.generateSettingsScreen(config),
      );
    }
  }

  Future<void> _generateWidgets(String basePath) async {
    // Generate common widgets
    await fileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_button.dart'),
      WidgetTemplates.generateCustomButton(),
    );
    await fileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_text_field.dart'),
      WidgetTemplates.generateCustomTextField(),
    );
    await fileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/loading_indicator.dart'),
      WidgetTemplates.generateLoadingIndicator(),
    );
    await fileUtils.writeFile(
      p.join(basePath, 'lib/presentation/widgets/custom_app_bar.dart'),
      WidgetTemplates.generateAppBarWidget(),
    );
  }

  Future<void> _generateBackendServices(String basePath) async {
    // Generate auth service
    final authService = BackendTemplates.generateAuthService(config);
    if (authService.isNotEmpty) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/core/services/auth_service.dart'),
        authService,
      );
    }

    // Generate database service
    final databaseService = BackendTemplates.generateDatabaseService(config);
    if (databaseService.isNotEmpty) {
      await fileUtils.writeFile(
        p.join(basePath, 'lib/core/services/database_service.dart'),
        databaseService,
      );
    }
  }

  Future<void> _updateAndroidBuildConfiguration(String basePath) async {
    // 1. Update android/build.gradle (Kotlin version)
    final buildGradlePath = p.join(basePath, 'android/build.gradle');
    if (await fileUtils.exists(buildGradlePath)) {
      var content = await fileUtils.readFile(buildGradlePath);
      // Update Kotlin version to 1.9.0
      content = content.replaceAll(
        RegExp(r"ext\.kotlin_version = '.*'"),
        "ext.kotlin_version = '1.9.0'",
      );
      await fileUtils.writeFile(buildGradlePath, content);
    }

    // 2. Update android/app/build.gradle (SDK versions)
    final appBuildGradlePath = p.join(basePath, 'android/app/build.gradle');
    if (await fileUtils.exists(appBuildGradlePath)) {
      var content = await fileUtils.readFile(appBuildGradlePath);
      // Update compileSdkVersion to 34
      content = content.replaceAll(
        RegExp(r'compileSdkVersion .*'),
        'compileSdkVersion 34',
      );
      // Update minSdkVersion to 23 (Flutter default is often lower, 23 is safer for modern plugins)
      content = content.replaceAll(
        RegExp(r'minSdkVersion .*'),
        'minSdkVersion 23',
      );
      // Update targetSdkVersion to 34
      content = content.replaceAll(
        RegExp(r'targetSdkVersion .*'),
        'targetSdkVersion 34',
      );
      await fileUtils.writeFile(appBuildGradlePath, content);
    }
  }
}
