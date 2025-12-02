import '../cli/questions.dart';

class ProjectStructure {
  static List<String> getFolders(ProjectConfig config) {
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

    return folders;
  }
}
