import '../cli/questions.dart';

class ScreenTemplates {
  static String generateHomeScreen(ProjectConfig config) {
    return '''
import 'package:flutter/material.dart';
${config.router == 'GoRouter' ? "import 'package:go_router/go_router.dart';" : ""}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home Screen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ${config.router == 'GoRouter' ? "context.push('/profile');" : "Navigator.pushNamed(context, '/profile');"}
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
''';
  }

  static String generateProfileScreen(ProjectConfig config) {
    return '''
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
''';
  }

  static String generateLoginScreen(ProjectConfig config) {
    return '''
import 'package:flutter/material.dart';
${config.router == 'GoRouter' ? "import 'package:go_router/go_router.dart';" : ""}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ${config.router == 'GoRouter' ? "context.go('/');" : "Navigator.pushReplacementNamed(context, '/');"}
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }

  static String generateSettingsScreen(ProjectConfig config) {
    return '''
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
''';
  }

  static String generateSplashScreen(ProjectConfig config) {
    return '''
import 'package:flutter/material.dart';
${config.router == 'GoRouter' ? "import 'package:go_router/go_router.dart';" : ""}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ${config.router == 'GoRouter' ? "context.go('/login');" : "Navigator.pushReplacementNamed(context, '/login');"}
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }
}
''';
  }
}
