# FlatNest Mobile App

A modern Flutter application for finding and listing flats, built with scalability and clean architecture in mind.

## 🚀 Key Features
- **Modern UI/UX**: Clean, responsive design based on high-fidelity prototypes.
- **Advanced Networking**: Robust API client with automatic token refresh and centralized error handling.
- **Multi-Environment Support**: Separate configurations for Development, Staging, and Production.
- **Theme Switching**: Seamless Light/Dark mode transitions.

## 🏗 Architecture
This project follows a **Modular MVVM + Repository Pattern** using **GetX**.
- **Separation of Concerns**: UI, Logic, and Data layers are strictly separated.
- **Reactive State**: Real-time UI updates using GetX.
- **Dependency Injection**: Decoupled components for better testability.

For more details, see the [ARCHITECTURE.md](ARCHITECTURE.md) guide.

---

## 🛠 Getting Started

### 1. Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### 2. Installation
```bash
flutter pub get
```

### 3. Code Generation
If you modify any models, run this to generate the serialization code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
For continuous generation while developing:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 🚦 How to Run & Build

We use separate entry points to handle environment-specific configurations (like API Base URLs).

### Run (Debug Mode)
- **Development**: `flutter run -t lib/main_dev.dart`
- **Staging**: `flutter run -t lib/main_staging.dart`
- **Production**: `flutter run -t lib/main_prod.dart`

### Build (Release Mode)

#### 🤖 Android
- **APK**: `flutter build apk --release -t lib/main_prod.dart`
- **App Bundle**: `flutter build appbundle --release -t lib/main_prod.dart`

#### 🍎 iOS
- **IPA**: `flutter build ipa --release -t lib/main_prod.dart`

---

## 📁 Key Directories
- `lib/app/core`: Shared logic, services, and network configuration.
- `lib/app/modules`: Feature-based modules (Auth, Splash, Home, etc.).
- `lib/app/theme`: Centralized design system (Colors, Styles, Themes).
- `lib/app/route`: Centralized routing management.
