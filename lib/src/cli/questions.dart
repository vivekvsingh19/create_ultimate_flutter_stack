import 'package:interact/interact.dart';

class ProjectConfig {
  final String stateManagement;
  final String backend;
  final String router;
  final String theme;
  final List<String> screens;
  final bool initializeGit;

  ProjectConfig({
    required this.stateManagement,
    required this.backend,
    required this.router,
    required this.theme,
    required this.screens,
    required this.initializeGit,
  });
}

ProjectConfig askQuestions() {
  // 1. Choose State Management
  final stateManagementOptions = [
    'Provider',
    'GetX',
    'Riverpod',
    'Bloc',
    'MobX'
  ];
  final stateManagementIndex = Select(
    prompt: 'Choose State Management:',
    options: stateManagementOptions,
    initialIndex: 0,
  ).interact();
  final stateManagement = stateManagementOptions[stateManagementIndex];

  // 2. Choose Backend
  final backendOptions = ['Firebase', 'Supabase', 'Appwrite', 'None'];
  final backendIndex = Select(
    prompt: 'Choose Backend:',
    options: backendOptions,
    initialIndex: 0,
  ).interact();
  final backend = backendOptions[backendIndex];

  // 3. Choose Router
  final routerOptions = ['Flutter Navigator', 'GoRouter', 'GetX Routing'];
  // Filter GetX Routing if GetX is not selected as state management (optional, but good UX)
  // For simplicity, we'll keep all options but maybe warn or handle later.
  // Actually, if GetX is not selected, GetX Routing might not make sense unless they add GetX just for routing.
  // Let's keep it simple for now.
  final routerIndex = Select(
    prompt: 'Choose Router:',
    options: routerOptions,
    initialIndex: 1, // Default to GoRouter usually
  ).interact();
  final router = routerOptions[routerIndex];

  // 4. Choose UI Theme Style
  final themeOptions = [
    'Minimal Clean',
    'Material 3',
    'Neumorphic',
    'Glassmorphism'
  ];
  final themeIndex = Select(
    prompt: 'Choose UI Theme Style:',
    options: themeOptions,
    initialIndex: 1,
  ).interact();
  final theme = themeOptions[themeIndex];

  // 5. Choose default screens to include
  final screenOptions = [
    'Splash',
    'Login / Signup',
    'Home',
    'Profile',
    'Settings'
  ];
  final screenIndices = MultiSelect(
    prompt: 'Choose default screens to include:',
    options: screenOptions,
    defaults: [true, true, true, true, true], // Default all selected
  ).interact();
  final screens = screenIndices.map((index) => screenOptions[index]).toList();

  // 6. Initialize Git Repo?
  final initializeGit = Confirm(
    prompt: 'Initialize git repository?',
    defaultValue: true,
  ).interact();

  return ProjectConfig(
    stateManagement: stateManagement,
    backend: backend,
    router: router,
    theme: theme,
    screens: screens,
    initializeGit: initializeGit,
  );
}
