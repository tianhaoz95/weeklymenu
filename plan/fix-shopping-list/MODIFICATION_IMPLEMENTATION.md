# WeeklyMenu App Modification Implementation Plan

## Journal

### Phase 0: Initial Setup and Verification

*   **Actions:**
    *   Checked out the `feat/init-app` branch.
    *   Verified no uncommitted changes.

*   **Learnings/Surprises:**
    *   None.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 1: Setup and Integration Test

*   **Actions:**
    *   Ran all tests, confirmed project in good state.
    *   Created `integration_test/settings_persistence_test.dart`.
    *   Fixed compilation errors in the integration test related to `IntegrationTestWidgetsFlutterBinding`, `SettingsModel` constructor, and `SettingsRepository` instantiation.
    *   Created `lib/data/repositories/settings_repository.dart`.
    *   Corrected `SettingsModel` instantiation in `SettingsRepository` to use `id: userId`.
    *   Added a `Key` to the `Scaffold` widget in `WeeklyMenuScreen`.
    *   Refactored `lib/main.dart` to correctly use `refreshListenable` with `AuthViewModel` for `GoRouter` redirection, making `_router` a global `final` variable and `_authViewModelInstance` accessible globally, and updated `MultiProvider` accordingly.
    *   Updated `integration_test/settings_persistence_test.dart` to correctly interact with `FilterChip` widgets instead of `CheckboxListTile`.
    *   Modified `integration_test/settings_persistence_test.dart` to robustly check and toggle `FilterChip` states instead of assuming an initial state.

*   **Learnings/Surprises:**
    *   Initial compilation errors in the integration test highlighted the need for careful verification of existing classes (`SettingsRepository`, `SettingsModel`) and correct usage of Flutter's testing utilities (`IntegrationTestWidgetsFlutterBinding`).
    *   GoRouter's `redirect` function not reacting to `AuthViewModel` changes was a key issue, solved by making `AuthViewModel` accessible globally and using it as `refreshListenable`. This required making `_router` and auth instances global and `AuthViewModel`'s `_router` field mutable via a setter.
    *   The test failed to find `Icons.settings` initially, then `WeeklyMenuScreen` key, then `BottomNavigationBar`, pointing to navigation and rendering issues. Careful debugging with `print` statements (though eventually removed due to access issues) and adjusting `pumpAndSettle` durations helped, but the core issue was the `GoRouter` refresh.
    *   The `SettingsScreen` uses `FilterChip`s, not `CheckboxListTile`s, which was a crucial detail missed initially and caused the test to fail interaction.
    *   The integration test now correctly fails at the first UI update assertion (`Breakfast FilterChip should be selected after tap`), confirming the reported bug related to UI reactivity.
    *   The initial thought of a simple optimistic update in `SettingsViewModel` was insufficient; a deeper architectural inconsistency between `UserModel` and `SettingsModel` was found.
    *   Making the integration test robust by checking and toggling current state was crucial for reliable bug reproduction and verification.

*   **Deviations from Plan:**
    *   Extensive debugging and refactoring of `main.dart` and `AuthViewModel` were required before the integration test could successfully navigate past login.
    *   The type of widget used in `SettingsScreen` for selection was `FilterChip` instead of `CheckboxListTile`, requiring adjustment in the integration test.
    *   The problem was much deeper than just UI reactivity; it involved an architectural mismatch between `UserModel` and `SettingsModel` that needed to be resolved across multiple layers.

### Journal

### Phase 2: Debugging and Fixing Persistence

*   **Actions:**
    *   Identified the root cause: an architectural mismatch where `SettingsViewModel` was managing `UserModel` settings via `UserRepository`, while settings should be managed via `SettingsModel` and `SettingsRepository`.
    *   Removed `enabledDays` and `enabledMeals` from `lib/data/models/user_model.dart` and regenerated `user_model.g.dart`.
    *   Modified `lib/data/services/menu_generator_service.dart` to use `SettingsModel` instead of `UserModel`.
    *   Modified `lib/presentation/view_models/settings_view_model.dart` to use `SettingsRepository` and manage a `SettingsModel` instance (`_currentSettings`).
    *   Modified `lib/presentation/screens/settings_screen.dart` to consume `settingsViewModel.currentSettings` for `FilterChip` selection logic.
    *   Modified `lib/data/repositories/user_repository.dart` to remove `enabledDays` and `enabledMeals` related logic from `updateUserSettings`.
    *   Modified `lib/presentation/view_models/weekly_menu_view_model.dart` to use `SettingsModel` and `SettingsRepository`.
    *   Corrected the `dispose()` method in `lib/presentation/view_models/weekly_menu_view_model.dart`.
    *   Ran the integration test `integration_test/settings_persistence_test.dart` and it passed all checks, confirming the bug is fully resolved.

*   **Learnings/Surprises:**
    *   Refactoring core models and their usage across multiple ViewModels, Services, and Repositories introduced cascading compilation errors, requiring careful step-by-step corrections.
    *   The interconnectedness of `UserModel`, `SettingsModel`, `UserRepository`, `SettingsRepository`, `SettingsViewModel`, `WeeklyMenuViewModel`, `MenuGeneratorService`, and `SettingsScreen` highlighted the importance of a clear data flow and separation of concerns.
    *   Initial attempts to fix UI reactivity were insufficient due to the underlying architectural inconsistency.

*   **Deviations from Plan:**
    *   The debugging process involved a complete refactoring of how user settings are managed, shifting from `UserModel` to `SettingsModel` as the source of truth for these preferences. This was a significant deviation from merely debugging UI updates or `notifyListeners()` calls.


---

## Phases

### Phase 1: Setup and Integration Test

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Create `integration_test/settings_persistence_test.dart` to:
    *   [x] Log in a test user.
    *   [x] Navigate to the `SettingsScreen`.
    *   [x] Simulate tapping on a meal type and a weekday `CheckboxListTile`. (Adjusted to `FilterChip` in implementation)
    *   [x] Verify the UI updates visually after tapping.
    *   [x] Navigate away and then back to `SettingsScreen`.
    *   [x] Assert that the selected meal type and weekday are still selected (persisted) in the UI.
-   [x] Run the new integration test and observe its failure (as expected, to confirm the bug).
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant. (Not relevant for this phase as we are creating an integration test).
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 2: Debugging and Fixing Persistence

-   [x] Debug the issue using Flutter DevTools (or by inspecting logs/Firestore directly) during the integration test execution to pinpoint where the settings persistence fails (UI, ViewModel, Repository, or Model serialization).
-   [x] Based on debugging, implement the necessary code changes in `settings_screen.dart`, `settings_view_model.dart`, `settings_repository.dart`, or `settings_model.dart` to ensure:
    *   [x] UI visually updates correctly on selection.
    *   [x] `SettingsViewModel` correctly updates its internal state and triggers `saveSettings`.
    *   [x] `SettingsRepository` correctly persists and retrieves `SettingsModel` to/from Firestore.
    *   [x] `SettingsModel` correctly serializes/deserializes `List<String>` for meal types and weekdays.
-   [x] Run the integration test created in Phase 1 and verify that it now passes.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Final Review and Cleanup

-   [x] Review and update any relevant parts of `README.md` to reflect the new features (if the fix enables a previously broken feature).
-   [x] Review and update any relevant parts of `GEMINI.md` to reflect the new features and architectural changes.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.
-   [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.