import '../cli/questions.dart';

String generateAppDart(ProjectConfig config) {
  final imports = StringBuffer();
  final buildBody = StringBuffer();

  imports.writeln("import 'package:flutter/material.dart';");

  if (config.router == 'GoRouter') {
    imports.writeln("import '../routes/app_router.dart';");
  }

  if (config.stateManagement == 'GetX' || config.router == 'GetX Routing') {
    imports.writeln("import 'package:get/get.dart';");
  }

  if (config.router == 'GetX Routing') {
    imports.writeln("import '../routes/app_pages.dart';");
  }

  // Theme imports
  imports.writeln("import '../core/themes/app_theme.dart';");

  String materialApp = 'MaterialApp';
  if (config.stateManagement == 'GetX' || config.router == 'GetX Routing') {
    materialApp = 'GetMaterialApp';
  }

  if (config.router == 'GoRouter') {
    materialApp += '.router';
  }

  buildBody.writeln('    return $materialApp(');
  buildBody.writeln("      title: 'Flutter Demo',");
  buildBody.writeln('      theme: AppTheme.lightTheme,');
  buildBody.writeln('      darkTheme: AppTheme.darkTheme,');
  buildBody.writeln('      themeMode: ThemeMode.system,');

  if (config.router == 'GetX Routing') {
    buildBody.writeln('      initialRoute: AppPages.initial,');
    buildBody.writeln('      getPages: AppPages.routes,');
  } else if (config.router == 'GoRouter') {
    if (materialApp.startsWith('GetMaterialApp')) {
      buildBody.writeln(
          '      routeInformationParser: router.routeInformationParser,');
      buildBody.writeln('      routerDelegate: router.routerDelegate,');
      buildBody.writeln(
          '      routeInformationProvider: router.routeInformationProvider,');
    } else {
      buildBody.writeln('      routerConfig: router,');
    }
  } else {
    // Default Navigator
    buildBody.writeln(
        '      home: const Scaffold(body: Center(child: Text("Home"))),');
  }

  buildBody.writeln('    );');

  return '''
${imports.toString()}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
${buildBody.toString()}
  }
}
''';
}
