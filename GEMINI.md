# WeeklyMenu App Gemini-specific Documentation

This document provides details relevant to the Gemini agent for understanding, developing, and interacting with the WeeklyMenu Flutter application.

## App Purpose

The WeeklyMenu app is designed to help users manage custom recipes, generate personalized weekly meal plans, and create shopping lists based on those plans. It aims to simplify meal planning and grocery shopping.

## Key Features Implemented by Gemini

The Gemini agent has been instrumental in implementing the following core features:

-   **Phase 1: Project Setup and Initial Commit:** Initial Flutter project setup, boilerplate removal, and basic configuration.
-   **Phase 2: Firebase Core and Authentication Setup:** Integration of Firebase Authentication for user management (sign-up, login, password reset, delete account).
-   **Phase 3: GoRouter Navigation Setup:** Implemented declarative navigation using `go_router`, including bottom navigation with `StatefulShellRoute` and authentication-based redirects.
-   **Phase 4: Firestore Data Models and Repositories:** Defined data models (`UserModel`, `RecipeModel`, `SettingsModel`, `WeeklyMenuItemModel`, `WeeklyMenuModel`, `ShoppingListItemModel`, `MealTypeModel`) and their corresponding Firestore repositories (`UserRepository`, `RecipeRepository`, `SettingsRepository`, `WeeklyMenuRepository`, `MealTypeRepository`). `SettingsModel` is specifically used for user preferences like weekdays, while `UserModel` stores core user authentication data. `RecipeModel` instances are stored within a user's `cookbook` subcollection. `WeeklyMenuModel` is now an in-memory representation, with its items stored per day in a user's `weekly` subcollection. `json_serializable` was used for model serialization.
-   **Phase 5: Settings Screen and User Profile:** Implemented the UI for user settings, allowing users to manage custom meal types (add, edit, delete) and select weekdays for menu generation (now correctly persisting using `SettingsModel`), and provided sign-out/delete account functionality.
-   **Phase 7: Weekly Menu Generation Logic:** Developed `MenuGeneratorService` and integrated it with `WeeklyMenuViewModel` to generate dynamic weekly meal plans based on user settings (`SettingsModel`), meal types (`MealTypeRepository`), and recipes.
-   **Phase 8: Shopping List Generation:** Developed `ShoppingListService` and integrated it with `ShoppingListViewModel` to generate shopping lists from the weekly menu, allowing users to mark items as checked.
-   **Phase 9: Internationalization:** Configured `flutter_localizations` and `intl`, created ARB files for English and Chinese, and integrated localized strings throughout the application UI.
-   **Phase 10: Prevent Automatic Weekly Menu Generation:** Modified `WeeklyMenuViewModel` to stop automatic menu regeneration on screen start and enabled dependency injection for `FirebaseAuth` for better testability. Added unit tests to verify the behavior.

## File Layout and Architecture

The project adheres to a clean architecture pattern with a clear separation of concerns.

-   **`lib/`**:
    -   **`main.dart`**: Application entry point, `MultiProvider` setup, and `GoRouter` configuration.
    -   **`l10n/`**: Contains generated localization files (`app_localizations.dart`, etc.) and ARB files (`app_en.arb`, `app_zh.arb`).
    -   **`data/`**:
        -   **`models/`**: Dart classes representing data structures (`recipe_model.dart`, `user_model.dart`, `settings_model.dart`, `weekly_menu_model.dart`, `meal_type_model.dart`, etc.) and their `json_serializable` generated parts (`.g.dart`). `UserModel` primarily stores core user authentication and profile data, while `SettingsModel` is specifically dedicated to user preferences and settings. `RecipeModel` defines the structure for user recipes, stored in the `cookbook` subcollection. `WeeklyMenuModel` now serves as an in-memory aggregation of `WeeklyMenuItemModel`s which are individually persisted per day in the `weekly` subcollection. `MealTypeModel` defines the structure for custom meal types.
        -   **`repositories/`**: Abstraction layer for data sources, primarily interacting with Firebase Firestore (`auth_repository.dart`, `recipe_repository.dart`, `user_repository.dart`, `settings_repository.dart`, `meal_type_repository.dart`, etc.). `UserRepository` handles core user data, and `SettingsRepository` manages user settings. `MealTypeRepository` manages custom meal types.
        -   **`services/`**: Contains business logic that operates on data from repositories (e.g., `menu_generator_service.dart`, `shopping_list_service.dart`).
    -   **`presentation/`**:
        -   **`screens/`**: UI implementations of individual screens (`login_screen.dart`, `weekly_menu_screen.dart`, etc.).
        -   **`view_models/`**: `ChangeNotifier` classes that manage UI state and interact with repositories/services (`auth_view_model.dart`, `cookbook_view_model.dart`, etc.).
        -   **`widgets/`**: Reusable UI components (e.g., `scaffold_with_nav_bar.dart`).

## Gemini-specific Instructions and Considerations

-   **Testing:** Always use an Android emulator for testing.
-   **Flutter Interactions:** Always interact with Flutter using Dart MCP calls. Never directly use Flutter CLI tools (e.g., use `run_tests` instead of `flutter test`, `pub` instead of `flutter pub`).
-   **Localization:** When adding new UI strings, ensure they are added to the `.arb` files in `lib/l10n` and `flutter gen-l10n` is run to update the generated code.
-   **State Management:** `Provider` with `ChangeNotifier` is the chosen state management solution.
-   **Navigation:** `go_router` is used for all major navigation. Its redirection logic now correctly reacts to authentication state changes by using `AuthViewModel` as a `refreshListenable`, ensuring seamless navigation between authenticated and unauthenticated routes.
-   **Firestore:** Data is persisted in Firestore. Repositories handle CRUD operations.
-   **`use_build_context_synchronously` Warnings:** There are persistent `use_build_context_synchronously` warnings in `recipe_screen.dart`. These are currently considered non-blocking for functionality and have been noted in the `IMPLEMENTATION.md` journal. Any future modifications to `recipe_screen.dart` should aim to resolve these if possible, but it's not a critical blocker.

## Development Workflow for Gemini

1.  **Understand Request:** Analyze the user's request.
2.  **Consult `IMPLEMENTATION.md`:** Review the implementation plan and current status.
3.  **Code Changes:** Implement changes, adhering to project conventions and architecture.
4.  **Static Analysis:** Run `dart_fix` and `analyze_files`. Address any errors and relevant warnings.
5.  **Formatting:** Run `dart_format`.
6.  **Testing:** Run relevant tests (unit, widget, integration) when applicable.
7.  **Update `IMPLEMENTATION.md`:** Document actions, learnings, and deviations in the Journal section. Update relevant checklists.
8.  **Git Commit:** Generate `git diff`, propose a commit message, and await user approval.
9.  **Hot Reload/Restart:** If the app is running, perform a hot reload/restart after code changes.

## Gemini Added Memories
- Email: test@weeklymenu.com, Password: 12341234 for integration tests.
- Do not use the outdated `flutter_driver` for integration test, see https://remotedesktop.google.com/access/session/73b9a571-e05a-4699-8a6f-fac60123ac94 for instructions for writting flutter integration tests.
- When the user asks to debug a issue. First write a integration test to repro the issue and then implement a fix to make the integration test pass.
- After a successful task implementation, boost the build number in `pubspec.yaml` by 1. For example, if the current version number is `version: 0.1.16+26`, the boosted version should be `version: 0.1.16+27`.
- After a successful task implementation and version boost, build the aab and move it to the temp directory with a name describing the task completed by first run `flutter build aab` and then `cp build/app/outputs/bundle/release/app-release.aab temp/{feature-description}.aab`.