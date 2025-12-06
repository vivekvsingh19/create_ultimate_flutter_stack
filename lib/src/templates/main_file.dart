import '../cli/questions.dart';

String generateMainDart(ProjectConfig config) {
  final imports = StringBuffer();
  final mainBody = StringBuffer();
  final runAppWidget = StringBuffer();

  imports.writeln("import 'package:flutter/material.dart';");

  if (config.backend == 'Firebase') {
    imports.writeln("import 'package:firebase_core/firebase_core.dart';");
    // imports.writeln("import 'firebase_options.dart';"); // Assuming generated
  } else if (config.backend == 'Supabase') {
    imports
        .writeln("// import 'package:supabase_flutter/supabase_flutter.dart';");
  }

  if (config.stateManagement == 'Riverpod') {
    imports.writeln("import 'package:flutter_riverpod/flutter_riverpod.dart';");
  }

  // imports.writeln("import 'core/config/app_config.dart';"); // Example
  imports.writeln("import 'presentation/app.dart';");

  mainBody.writeln('  WidgetsFlutterBinding.ensureInitialized();');

  if (config.backend == 'Firebase') {
    mainBody.writeln('  await Firebase.initializeApp();');
    mainBody.writeln('  // options: DefaultFirebaseOptions.currentPlatform,');
  } else if (config.backend == 'Supabase') {
    mainBody.writeln(
        "  // await Supabase.initialize(url: 'YOUR_URL', anonKey: 'YOUR_KEY');");
  }

  if (config.stateManagement == 'Riverpod') {
    runAppWidget.write('const ProviderScope(child: MyApp())');
  } else if (config.stateManagement == 'Provider') {
    imports.writeln("import 'package:provider/provider.dart';");
    runAppWidget
        .write('MultiProvider(providers: const [], child: const MyApp())');
  } else {
    runAppWidget.write('const MyApp()');
  }

  return '''
${imports.toString()}

void main() async {
${mainBody.toString()}
  runApp(${runAppWidget.toString()});
}
''';
}
