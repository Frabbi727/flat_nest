# FlatNest Mobile App Architecture Guide

This document explains the architecture, directory structure, and development flow of the FlatNest mobile application.

## 🚀 Running Different Environments

We use separate entry points for different environments (Dev, Staging, Prod). This automatically switches the API Base URL.

### To Run:
- **Development**: `flutter run -t lib/main_dev.dart`
- **Staging**: `flutter run -t lib/main_staging.dart`
- **Production**: `flutter run -t lib/main_prod.dart`

### To Build (Release):
- **Development**: `flutter build apk -t lib/main_dev.dart`
- **Staging**: `flutter build apk -t lib/main_staging.dart`
- **Production**: `flutter build apk -t lib/main_prod.dart`

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
Handle API calls using the `ApiClient`. Return clean models to the controller.
```dart
class AuthRepository extends BaseRepository {
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', ...);
    return UserModel.fromJson(response.data);
  }
}
```

### 3. The Controller (`controller/`)
Handle UI state (loading, errors) and call the repository. **No UI code here.**
```dart
class AuthController extends BaseController {
  final AuthRepository _repo;
  final emailController = TextEditingController();

  void login() async {
    showLoading();
    try {
      final user = await _repo.login(emailController.text, ...);
      // Handle success
    } catch (e) {
      showError(e.toString());
    } finally {
      hideLoading();
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
