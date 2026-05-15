# FlatNest Mobile App Architecture Guide

This document explains the architecture, directory structure, and development flow of the FlatNest mobile application.

## ⚙️ Code Generation
We use `json_serializable` for data models. When you create or update a model in the `model/` folder, you MUST run the build runner:

- **Single Build**: `flutter pub run build_runner build --delete-conflicting-outputs`
- **Watch Mode**: `flutter pub run build_runner watch --delete-conflicting-outputs`

---

## 🚀 Running Different Environments

We use separate entry points for different environments (Dev, Staging, Prod). This automatically switches the API Base URL.

### To Run:
- **Development**: `flutter run -t lib/main_dev.dart`
- **Staging**: `flutter run -t lib/main_staging.dart`
- **Production**: `flutter run -t lib/main_prod.dart`

### To Build (Release Mode):
For production, always use the `--release` flag and point to the production entry point:

#### 🤖 Android:
- **Build APK**: `flutter build apk --release -t lib/main_prod.dart`
- **Build App Bundle (for Play Store)**: `flutter build appbundle --release -t lib/main_prod.dart`

#### 🍎 iOS:
- **Build IPA**: `flutter build ipa --release -t lib/main_prod.dart`

> **Note**: If you want to build for Staging, simply replace `-t lib/main_prod.dart` with `-t lib/main_staging.dart`.

---

## 🏗 Core Architecture
We use **Dio** with a specialized `ApiClient` that handles:
- **Automatic Token Injection**: `AuthInterceptor` adds the Bearer token to all requests.
- **Refresh Token Mechanism**: If a request fails with `401 Unauthorized`, the interceptor automatically:
    1. Pauses the error.
    2. Calls the refresh token endpoint.
    3. Retries the original request with the new token.
    4. Logouts the user if the refresh fails.
- **Centralized Error Handling**: `ErrorInterceptor` converts raw exceptions into user-friendly messages.
- **Multi-Environment**: Environment-specific Base URLs are managed via `ApiConfig`.

---

## 🔐 Session & Onboarding Flow
The app handles the first-time user experience and persistent logins through the `SplashController` and `AuthService`.

### Navigation Branching (Splash):
1. **First Time Launch**: If `isFirstTime` is true in `CacheManager`, the user is routed to the **Onboarding** module.
2. **Returning User (Logged In)**: If `isAuthenticated` is true, the user skips login and goes directly to **Home**.
3. **Returning User (Logged Out)**: The user is routed to the **Login** screen.

### Persistence:
- **Tokens**: Stored securely using `flutter_secure_storage`.
- **Flags**: `is_first_time` and `is_logged_in` flags are persisted to ensure the user doesn't see onboarding twice and stays logged in.

---

## 🏗 Core Architecture
We follow a **Modular MVVM + Repository Pattern** using **GetX** for state management and dependency injection.

### Key Principles:
- **Clean Separation of Concerns**: Views handle UI, Controllers handle logic, and Repositories handle data.
- **Reactive State Management**: Using GetX `.obs` and `Obx` for real-time UI updates.
- **Centralized Theming**: All colors, font sizes, and styles are managed in one place.
- **Service Layer**: Global states (Auth, Theme) are handled by long-running `GetxService` classes.

---

## 📁 Project Structure

```text
lib/
├── app/
│   ├── core/               # Global shared code
│   │   ├── base/           # Base classes (BaseController, BaseRepository)
│   │   ├── network/        # Dio API client & Interceptors
│   │   ├── cache/          # Secure Storage & Cache Management
│   │   ├── service/        # Global Services (Auth, Theme)
│   │   └── utils/          # Helpers & Validators
│   │
│   ├── modules/            # Feature-based modules (THE HEART OF THE APP)
│   │   ├── module_name/    # e.g., auth, splash, home
│   │   │   ├── binding/    # Dependency injection (Get.lazyPut)
│   │   │   ├── controller/ # Logic & State (ViewModel)
│   │   │   ├── repository/ # API & Data handling
│   │   │   ├── model/      # Data models (JSON Serialized)
│   │   │   ├── view/       # UI Screens
│   │   │   └── widget/     # Module-specific widgets
│   │
│   ├── route/              # Route names and Page definitions
│   └── theme/              # Global Design System (Colors, TextStyles)
│
└── main.dart               # App entry & Service initialization
```

---

## 🔄 Development Flow (The Lifecycle)

When adding a new feature or handling an action (like Login), the flow is as follows:

### 1. The Model (`model/`)
Define your data structure using `json_serializable` and `equatable`.
```dart
@JsonSerializable()
class UserModel extends Equatable { ... }
```

### 2. The Repository (`repository/`)
Handle API calls using the `ApiClient`. Catch exceptions and return a `Resource<T>` wrapper.
```dart
class AuthRepository extends BaseRepository {
  Future<Resource<UserModel>> login(String email, String password) async {
    try {
      final response = await apiClient.post('/login', ...);
      return Success(UserModel.fromJson(response.data));
    } catch (e) {
      return Error(e.toString());
    }
  }
}
```

### 3. The Controller (`controller/`)
Handle UI state (loading, errors) and call the repository. Use exhaustive pattern matching on the `Resource`. **No UI code here.**
```dart
class AuthController extends BaseController {
  final AuthRepository _repo;

  void login() async {
    showLoading();
    final result = await _repo.login(...);
    hideLoading();

    switch (result) {
      case Success(data: final user):
        // Handle success
      case Error(message: final msg):
        showError(msg);
    }
  }
}
```

### 4. The View (`view/`)
Declarative UI that binds to the controller. **No logic here.**
```dart
class LoginView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
      onPressed: controller.login,
      child: controller.isLoading ? Loader() : Text('Login'),
    ));
  }
}
```

---

## 🎨 Theme & Styling
- **Colors**: Use `AppColors` constants.
- **Text Styles**: Use `AppTextStyles` or `Theme.of(context).textTheme`.
- **Theme Extensions**: Use `Theme.of(context).extension<FlatNestTheme>()` for custom theme-aware tokens like `ink` or `surface`.

## 🚦 Routing
1. Define the route name in `app_routes.dart`.
2. Add the `GetPage` with its `Binding` and `View` in `app_pages.dart`.

---

## 📜 Coding Standards
- **Controllers**: Always extend `BaseController` for built-in loading/error handling.
- **Cleanliness**: Keep views small. Break down complex UIs into private methods or separate widgets.
- **Reusability**: Move common UI elements to `app/core/widget/`.
