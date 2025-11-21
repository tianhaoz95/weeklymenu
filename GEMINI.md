# WeeklyMenu App Gemini-specific Documentation

This document provides details relevant to the Gemini agent for understanding, developing, and interacting with the WeeklyMenu Flutter application.

## App Purpose

The WeeklyMenu app is designed to help users manage custom recipes, generate personalized weekly meal plans, and create shopping lists based on those plans. It aims to simplify meal planning and grocery shopping.

## Key Features Implemented by Gemini

The Gemini agent has been instrumental in implementing the following core features:

-   **Phase 1: Project Setup and Initial Commit:** Initial Flutter project setup, boilerplate removal, and basic configuration.
-   **Phase 2: Firebase Core and Authentication Setup:** Integration of Firebase Authentication for user management (sign-up, login, password reset, delete account).
-   **Phase 3: GoRouter Navigation Setup:** Implemented declarative navigation using `go_router`, including bottom navigation with `StatefulShellRoute` and authentication-based redirects.
-   **Phase 4: Firestore Data Models and Repositories:** Defined data models (`UserModel`, `RecipeModel`, `SettingsModel`, `WeeklyMenuItemModel`, `WeeklyMenuModel`, `ShoppingListItemModel`) and their corresponding Firestore repositories (`UserRepository`, `RecipeRepository`, `WeeklyMenuRepository`). `json_serializable` was used for model serialization.
-   **Phase 5: Settings Screen and User Profile:** Implemented the UI for user settings, allowing users to select meal types and weekdays for menu generation, and provided sign-out/delete account functionality.
-   **Phase 6: Cookbook (Recipe Management):** Implemented UI and logic for managing a personal recipe collection (add, edit, delete recipes).
-   **Phase 7: Weekly Menu Generation Logic:** Developed `MenuGeneratorService` and integrated it with `WeeklyMenuViewModel` to generate dynamic weekly meal plans based on user settings and recipes.
-   **Phase 8: Shopping List Generation:** Developed `ShoppingListService` and integrated it with `ShoppingListViewModel` to generate shopping lists from the weekly menu, allowing users to mark items as checked.
-   **Phase 9: Internationalization:** Configured `flutter_localizations` and `intl`, created ARB files for English and Chinese, and integrated localized strings throughout the application UI.

## File Layout and Architecture

The project adheres to a clean architecture pattern with a clear separation of concerns.

-   **`lib/`**:
    -   **`main.dart`**: Application entry point, `MultiProvider` setup, and `GoRouter` configuration.
    -   **`l10n/`**: Contains generated localization files (`app_localizations.dart`, etc.) and ARB files (`app_en.arb`, `app_zh.arb`).
    -   **`data/`**:
        -   **`models/`**: Dart classes representing data structures (`recipe_model.dart`, `user_model.dart`, etc.) and their `json_serializable` generated parts (`.g.dart`).
        -   **`repositories/`**: Abstraction layer for data sources, primarily interacting with Firebase Firestore (`auth_repository.dart`, `recipe_repository.dart`, etc.).
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
-   **Navigation:** `go_router` is used for all major navigation. Understand its redirection logic based on authentication state.
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
