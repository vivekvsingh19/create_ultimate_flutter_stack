# CUFS - Create Ultimate Flutter Stack

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║               █████╗  ██╗   ██╗ ███████╗ ███████╗                 ║
║              ██╔══██╗ ██║   ██║ ██╔════╝ ██╔════╝                 ║
║              ██║  ╚═╝ ██║   ██║ █████╗   ███████╗                 ║
║              ██║  ██╗ ██║   ██║ ██╔══╝   ╚════██║                 ║
║              ╚█████╔╝ ╚██████╔╝ ██║      ███████║                 ║
║               ╚════╝   ╚═════╝  ╚═╝      ╚══════╝                 ║
║                                                                   ║
║                 Create Ultimate Flutter Stack                     ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

A powerful CLI tool for generating production-ready Flutter applications with your preferred stack configuration. Think of it as "Create React App" but for Flutter - get started with best practices in seconds.

## ✨ Features

- 🎯 **Interactive CLI** - Simple prompts guide you through project setup
- 🏗️ **Clean Architecture** - Follows industry-standard folder structure
- 🎨 **Multiple Themes** - Material 3, Minimal Clean, Neumorphic, Glassmorphism
- 🔐 **Backend Integration** - Firebase, Supabase, Appwrite support
- 🧭 **Smart Routing** - GoRouter, GetX Routing, or Flutter Navigator
- 📦 **State Management** - Provider, GetX, Riverpod, Bloc, MobX
- 🚀 **Production Ready** - Clean code that passes `flutter analyze`

### Method 1: Via Pub.dev (Recommended)
Prerequisite: [Dart SDK](https://dart.dev/get-dart) installed.

```bash
# Install globally
dart pub global activate cufs

# Run
cufs create my_app
```

### Method 2: Standalone Binary (No Dart SDK required)
Download the latest release for your OS from the [Releases](https://github.com/yourusername/create_ultimate_flutter_stack/releases) page.

```bash
# Make executable (Linux/Mac)
chmod +x cufs

# Run
./cufs create my_app
```

## 🚀 Usage

### Interactive Mode

```bash
cufs create my_awesome_app
```

The CLI will guide you through selecting:
1. **State Management** - Choose your preferred solution
2. **Backend** - Pick your backend service or none
3. **Router** - Select routing approach
4. **Theme** - Choose your UI style
5. **Screens** - Select which screens to generate

### Example Session

```bash
$ cufs create my_app

🚀 Welcome to CUFS! Let's build your ultimate Flutter stack.

? Choose State Management: ›
❯ Provider
  GetX
  Riverpod
  Bloc
  MobX

? Choose Backend: ›
❯ Firebase
  Supabase
  Appwrite
  None

? Choose Router: ›
  Flutter Navigator
❯ GoRouter
  GetX Routing

? Choose UI Theme Style: ›
  Minimal Clean
❯ Material 3
  Neumorphic
  Glassmorphism

? Choose default screens to include: ›
✔ Splash
✔ Login / Signup
✔ Home
✔ Profile
✔ Settings

✓ Project my_app generated successfully! 🚀
cd my_app && flutter run
```

## 📂 Generated Project Structure

```
my_app/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   ├── themes/
│   │   │   └── app_theme.dart
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   └── database_service.dart
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   └── repositories/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── settings_screen.dart
│   │   ├── widgets/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── custom_app_bar.dart
│   │   └── app.dart
│   ├── routes/
│   │   └── app_router.dart
│   └── main.dart
└── pubspec.yaml
```

## 🎨 Available Options

### State Management
- **Provider** - Simple and effective
- **GetX** - Lightweight and powerful
- **Riverpod** - Modern Provider evolution
- **Bloc** - Predictable state container
- **MobX** - Reactive state management

### Backend Services
- **Firebase** - Google's mobile platform
- **Supabase** - Open source Firebase alternative
- **Appwrite** - Self-hosted backend server
- **None** - Frontend only

### Routing
- **GoRouter** - Declarative routing (recommended)
- **GetX Routing** - Built-in GetX navigation
- **Flutter Navigator** - Default Flutter routing

### Themes
- **Material 3** - Latest Material Design
- **Minimal Clean** - Black/white minimalism
- **Neumorphic** - Soft UI with shadows
- **Glassmorphism** - Modern glass effects

## 🛠️ What Gets Generated

### Core Files
- ✅ `main.dart` with state management setup
- ✅ `app.dart` with routing configuration
- ✅ `app_theme.dart` with your chosen theme
- ✅ `app_router.dart` or `app_pages.dart` for navigation

### Services
- ✅ `auth_service.dart` - Authentication logic
- ✅ `database_service.dart` - Database operations

### Screens
- ✅ Splash screen with auto-navigation
- ✅ Login/Signup screen with forms
- ✅ Home screen with navigation example
- ✅ Profile screen
- ✅ Settings screen

### Widgets
- ✅ Custom button with loading states
- ✅ Custom text field with validation
- ✅ Loading indicator
- ✅ Custom app bar

## 🧪 Testing

All generated projects are verified to:
- ✅ Pass `flutter analyze` with zero errors
- ✅ Compile successfully
- ✅ Follow Flutter best practices
- ✅ Use null-safe code

## 📝 Example Combinations

### Startup MVP
```
State Management: Provider
Backend: Firebase
Router: GoRouter
Theme: Material 3
```

### Enterprise App
```
State Management: Bloc
Backend: Supabase
Router: GoRouter
Theme: Minimal Clean
```

### Quick Prototype
```
State Management: GetX
Backend: None
Router: GetX Routing
Theme: Glassmorphism
```

## 🤝 Contributing

This tool is actively maintained. If you find bugs or have feature requests, please open an issue.

## 📄 License

This project is open source and available under the MIT License.

## 🎯 Next Steps After Generation

1. Navigate to your project: `cd my_app`
2. Run the app: `flutter run`
3. Start coding! All the boilerplate is done.

## 💡 Tips

- **Backend Setup**: Remember to configure your backend service (Firebase, Supabase, Appwrite) with your credentials
- **Custom Modifications**: All generated code is yours to modify
- **Clean Code**: Generated projects follow industry best practices
- **Production Ready**: Code is analysis-clean and null-safe

---

**Happy Coding! 🚀**

Built with ❤️ for the Flutter community
# create_ultimate_flutter_stack
# create_ultimate_flutter_stack
