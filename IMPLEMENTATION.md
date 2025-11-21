# WeeklyMenu App Implementation Plan

This document outlines the phased implementation plan for the WeeklyMenu Flutter application. Each phase consists of a set of tasks that will be completed sequentially. After each phase, a review of changes, testing, and an update to the Journal section will occur.

## Journal

This section will be updated after each phase to log actions taken, learnings, surprises, and deviations from the plan. It will be in chronological order.

---

## Phases

### Phase 1: Project Setup and Initial Commit

-   [ ] Create a Flutter package named `weeklymenu` in the current directory, supporting all default platforms, as an empty project.
-   [ ] Remove any boilerplate in the new package that will be replaced, including the `test` directory.
-   [ ] Update the description of the package in `pubspec.yaml` to "A Flutter application for managing custom recipes, generating weekly menus, and creating shopping lists." and set the version number to `0.1.0`.
-   [ ] Update the `README.md` to include a short placeholder description of the package.
-   [ ] Create the `CHANGELOG.md` with an initial version of `0.1.0`.
-   [ ] Commit this empty version of the package to the current branch.
-   [ ] After committing the change, start running the app with the `launch_app` tool on the user's preferred device.

**Post-Phase Checklist:**
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Present the change message to the user for approval.
-   [ ] Wait for approval. Do not commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if the app is running, use the `hot_reload` tool to reload it.

### Phase 2: Firebase Core and Authentication Setup

-   [ ] Add `firebase_core`, `firebase_auth` dependencies.
-   [ ] Initialize Firebase in `main.dart`.
-   [ ] Implement `AuthRepository` with `signIn`, `signUp`, `signOut`, `resetPassword`, `deleteAccount` methods.
-   [ ] Implement `AuthViewModel` as a `ChangeNotifier` to expose authentication state.
-   [ ] Add `AuthViewModel` to `MultiProvider` at the root of the app.
-   [ ] Implement Login, Sign Up, and Forgot Password screens.
-   [ ] Connect these screens to `AuthViewModel` for authentication actions.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 3: GoRouter Navigation Setup

-   [ ] Add `go_router` dependency.
-   [ ] Configure `GoRouter` with `MaterialApp.router`.
-   [ ] Implement the top-level `redirect` logic based on `AuthViewModel`'s authentication state.
-   [ ] Create placeholder screens for Weekly Menu, Cookbook, Settings, and Shopping List.
-   [ ] Implement `StatefulShellRoute.indexedStack` for the bottom navigation bar, including the Weekly Menu, Cookbook, and Settings screens.
-   [ ] Set up navigation to Login/Sign Up screens and from authenticated screens back to Login on sign out.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 4: Firestore Data Models and Repositories

-   [ ] Add `cloud_firestore`, `json_annotation`, `json_serializable` dependencies.
-   [ ] Create Dart models for `UserModel`, `RecipeModel`, `SettingsModel`, `WeeklyMenuItemModel`, `WeeklyMenuModel`, `ShoppingListItemModel`.
-   [ ] Apply `json_serializable` annotations and generate `.g.dart` files using `dart run build_runner build --delete-conflicting-outputs`.
-   [ ] Implement `UserRepository`, `RecipeRepository`, `WeeklyMenuRepository` to handle Firestore CRUD operations for respective models.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 5: Settings Screen and User Profile

-   [ ] Implement the UI for the Settings screen:
    -   Display user's email.
    -   Selector for included meals (breakfast, lunch, dinner, snack).
    -   Selector for included weekdays.
    -   Sign Out button.
    -   Delete Account button.
-   [ ] Connect Settings screen UI elements to `SettingsViewModel` (which interacts with `UserRepository` for profile data).
-   [ ] Ensure Sign Out/Delete Account actions correctly navigate to the Login screen.
-   [ ] Implement `SettingsViewModel` as a `ChangeNotifier`.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 6: Cookbook (Recipe Management)

-   [ ] Implement the UI for the Cookbook screen:
    -   List of user-added recipes.
    -   "Add New Recipe" button.
-   [ ] Implement the UI for the Recipe screen:
    -   Input fields for ingredients, style, type (multi-select), star rating (1-5).
    -   Edit/Save button.
-   [ ] Implement "Add New Recipe" pop-up.
-   [ ] Connect Cookbook and Recipe screens to `CookbookViewModel` (which interacts with `RecipeRepository`).
-   [ ] Implement `CookbookViewModel` as a `ChangeNotifier`.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 7: Weekly Menu Generation Logic

-   [ ] Implement `MenuGeneratorService` with the specified logic for generating the weekly menu based on settings and recipes.
-   [ ] Implement the UI for the Weekly Menu screen:
    -   Display the generated menu for selected days and meals.
    -   "Regenerate Weekly Menu" button.
-   [ ] Connect Weekly Menu screen to `WeeklyMenuViewModel` (which uses `MenuGeneratorService` and `WeeklyMenuRepository`).
-   [ ] Implement `WeeklyMenuViewModel` as a `ChangeNotifier`.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 8: Shopping List Generation

-   [ ] Implement `ShoppingListService` for generating the shopping list from the weekly menu.
-   [ ] Implement the UI for the Shopping List screen:
    -   Checklist of ingredients grouped by day.
    -   Allow users to mark items as checked.
-   [ ] Connect Shopping List screen to `ShoppingListViewModel` (which uses `ShoppingListService`).
-   [ ] Implement `ShoppingListViewModel` as a `ChangeNotifier`.
-   [ ] Ensure the shopping list updates correctly when the weekly menu is regenerated.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 9: Internationalization

-   [ ] Configure `flutter_localizations` and `intl` in `pubspec.yaml`.
-   [ ] Create `l10n.yaml` and `.arb` files (`app_en.arb`, `app_zh.arb`) in `lib/l10n` for all UI strings.
-   [ ] Generate localization code using `flutter gen-l10n`.
-   [ ] Integrate localized strings throughout the application UI.
-   [ ] Configure `MaterialApp` to support `Locale('en')` and `Locale('zh')`.

**Post-Phase Checklist:** (Same as Phase 1)

### Phase 10: Final Polish and Documentation

-   [ ] Create a comprehensive `README.md` file for the package, including setup instructions, features, and usage.
-   [ ] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, and implementation details of the application and the layout of the files.
-   [ ] Review the entire application for UI consistency, error handling, and overall user experience.
-   [ ] Conduct final testing across all features.
-   [ ] Ask the user to inspect the app and the code and say if they are satisfied with it, or if any modifications are needed.

**Post-Phase Checklist:** (Same as Phase 1, but without the "Wait for approval" for the final step).
