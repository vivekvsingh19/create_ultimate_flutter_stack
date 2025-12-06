import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:cufs/src/cli/questions.dart';
import 'package:cufs/src/core/generator.dart';
import 'package:cufs/src/utils/file_utils.dart';
import 'package:cufs/src/utils/process_runner.dart';

final logger = Logger();

void run(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Print this usage information.')
    ..addFlag('version',
        abbr: 'v', negatable: false, help: 'Print the current version.')
    ..addOption('test-config',
        help: 'JSON configuration for testing purposes.', hide: true);

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    logger.err(e.toString());
    logger.info('');
    logger.info('Usage: cufs <command> [arguments]');
    logger.info(parser.usage);
    exit(1);
  }

  if (argResults['help'] as bool) {
    logger.info('Create Ultimate Flutter Stack (CUFS) CLI');
    logger.info('');
    logger.info('Usage: cufs <command> [arguments]');
    logger.info(parser.usage);
    exit(0);
  }

  if (argResults['version'] as bool) {
    logger.info('cufs version 1.0.2');
    exit(0);
  }

  if (argResults.rest.isEmpty) {
    logger.err('No command provided.');
    logger.info('Try "cufs create <app_name>"');
    exit(1);
  }

  final command = argResults.rest.first;

  if (command == 'create') {
    if (argResults.rest.length < 2) {
      logger.err('No app name provided.');
      logger.info('Usage: cufs create <app_name>');
      exit(1);
    }
    final appName = argResults.rest[1];
    final testConfig = argResults['test-config'] as String?;
    await _createApp(appName, testConfig: testConfig);
  } else {
    logger.err('Unknown command: $command');
    exit(1);
  }
}

Future<void> _createApp(String appName, {String? testConfig}) async {
  // Print ASCII art banner
  _printBanner();

  logger.info('🚀 Welcome to CUFS! Let\'s build your ultimate Flutter stack.');
  logger.info('');

  ProjectConfig config;
  if (testConfig != null) {
    try {
      final json = jsonDecode(testConfig) as Map<String, dynamic>;
      config = ProjectConfig(
        stateManagement: json['stateManagement'] as String,
        backend: json['backend'] as String,
        router: json['router'] as String,
        theme: json['theme'] as String,
        screens: (json['screens'] as List).cast<String>(),
        initializeGit: json['initializeGit'] as bool? ?? false,
      );
      logger.info('🤖 Using test configuration.');
    } catch (e) {
      logger.err('Invalid test config: $e');
      exit(1);
    }
  } else {
    config = askQuestions();
  }

  logger.info('');
  logger.info('🔥 Generating $appName with the following configuration:');
  logger.info('   State Management: ${config.stateManagement}');
  logger.info('   Backend: ${config.backend}');
  logger.info('   Router: ${config.router}');
  logger.info('   Theme: ${config.theme}');
  logger.info('   Screens: ${config.screens.join(', ')}');
  logger.info('   Initialize Git: ${config.initializeGit ? "Yes" : "No"}');
  logger.info('');

  final generator = ProjectGenerator(
    appName: appName,
    config: config,
    logger: logger,
    processRunner: ProcessRunnerImpl(),
    fileUtils: FileUtilsImpl(),
  );

  await generator.generate();
}

void _printBanner() {
  // Define gradient colors: pink -> purple -> blue -> cyan
  final pink = '\x1B[38;5;213m'; // Light magenta/pink
  final purple = '\x1B[38;5;141m'; // Purple
  final blue = '\x1B[38;5;69m'; // Blue
  final cyan = '\x1B[38;5;51m'; // Cyan
  final reset = '\x1B[0m';

  print('');
  print(
      '$cyan╔═══════════════════════════════════════════════════════════════════╗$reset');
  print(
      '$cyan║$reset                                                                   $cyan║$reset');
  print(
      '$cyan║$reset               $pink█████╗$reset  $purple██╗$reset   $purple██╗$reset $blue███████╗$reset $cyan███████╗$reset                 $cyan║$reset');

  print(
      '$cyan║$reset              $pink██╔══██╗$reset $purple██║$reset   $purple██║$reset $blue██╔════╝$reset $cyan██╔════╝$reset                 $cyan║$reset');

  print(
      '$cyan║$reset              $pink██║$reset  $pink╚═╝$reset $purple██║$reset   $purple██║$reset $blue█████╗$reset   $cyan███████╗$reset                 $cyan║$reset');

  print(
      '$cyan║$reset              $pink██║$reset  $pink██╗$reset $purple██║$reset   $purple██║$reset $blue██╔══╝$reset   $cyan╚════██║$reset                 $cyan║$reset');

  print(
      '$cyan║$reset              $pink╚█████╔╝$reset $purple╚██████╔╝$reset $blue██║$reset      $cyan███████║$reset                 $cyan║$reset');

  print(
      '$cyan║$reset               $pink╚════╝$reset   $purple╚═════╝$reset  $blue╚═╝$reset      $cyan╚══════╝$reset                 $cyan║$reset');

  print(
      '$cyan║$reset                                                                   $cyan║$reset');
  print(
      '$cyan║$reset                 ${pink}C${purple}r${blue}e${cyan}a${pink}t${purple}e$reset ${blue}U${cyan}l${pink}t${purple}i${blue}m${cyan}a${pink}t${purple}e$reset ${blue}F${cyan}l${pink}u${purple}t${blue}t${cyan}e${pink}r$reset ${purple}S${blue}t${cyan}a${pink}c${purple}k$reset                     $cyan║$reset');

  print(
      '$cyan║$reset                                                                   $cyan║$reset');
  print(
      '$cyan╚═══════════════════════════════════════════════════════════════════╝$reset');
  print('');
}

/// Prints a neon styled boxed title with gradient colors.
///
/// The title is split into up to two lines, centered within a box
/// surrounded by a double line border. Each character is colored
/// using a rotating gradient defined by `colors`.
///
/// Example usage:
/// ```dart
/// printNeonBoxedTitle('CREATE ULTIMATE FLUTTER STACK');
/// ```
void printNeonBoxedTitle(String text) {
  final colors = [
    lightMagenta, // pink
    magenta, // purple
    lightBlue, // blue
    lightCyan, // cyan
  ];

  // Split text into words
  final words = text.trim().split(' ');

  // Divide evenly across two lines
  List<String> lines;
  if (words.length <= 2) {
    lines = [text];
  } else {
    final mid = (words.length / 2).ceil();
    lines = [words.sublist(0, mid).join(' '), words.sublist(mid).join(' ')];
  }

  // Find longest line for box width
  final longest = lines.fold<int>(0, (p, e) => e.length > p ? e.length : p);
  final boxWidth = longest + 20; // padding left + right

  final border = '╔${'═' * boxWidth}╗';
  final bottom = '╚${'═' * boxWidth}╝';

  logger.info('');
  logger.info(darkGray.wrap(border) ?? border);

  for (var line in lines) {
    final buffer = StringBuffer();
    int index = 0;

    // Gradient per letter
    for (var char in line.split('')) {
      if (char == ' ') {
        buffer.write(' ');
      } else {
        buffer.write(colors[index % colors.length].wrap(char) ?? char);
        index++;
      }
    }

    // center alignment inside box
    final totalPadding = boxWidth - line.length;
    final leftPad = (totalPadding / 2).floor();
    final rightPad = totalPadding - leftPad;

    logger.info(
      (darkGray.wrap('║') ?? '║') +
          ' ' * leftPad +
          buffer.toString() +
          ' ' * rightPad +
          (darkGray.wrap('║') ?? '║'),
    );
  }

  logger.info(darkGray.wrap(bottom) ?? bottom);
  logger.info('');
}
