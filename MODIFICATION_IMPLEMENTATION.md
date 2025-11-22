# WeeklyMenu App Modification Implementation Plan

## Journal

### Phase 0: Initial Setup and Verification

*   **Actions:**
    *   Verified no uncommitted changes on the current branch.

*   **Learnings/Surprises:**
    *   None.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 1: Fix Bottom Navigator Color

*   **Actions:**
    *   Ran all tests, confirmed project in good state.
    *   Modified `lib/main.dart` to define `lightTheme` and `darkTheme` with `BottomNavigationBarThemeData` for contrasting background and item colors.

*   **Learnings/Surprises:**
    *   The default `ThemeData` does not provide sufficient contrast for the bottom navigation bar, requiring explicit theme configuration.

*   **Deviations from Plan:**
    *   None.

---

## Phases

### Phase 1: Fix Bottom Navigator Color

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Modify `lib/main.dart` to add `BottomNavigationBarThemeData` to the existing `ThemeData`s (`lightTheme` and `darkTheme`).
    -   [x] Set `backgroundColor` to a contrasting color (e.g., `Colors.blue` for light theme, `Colors.grey[800]` for dark theme).
    -   [x] Set `selectedItemColor` and `unselectedItemColor` for visibility.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass. (This refers to existing tests, no new tests created)
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 2: Fix Weekly Menu Refresh

-   [ ] Add temporary `print` statements in `lib/presentation/view_models/weekly_menu_view_model.dart`'s `generateWeeklyMenu()` and `_generateAndSaveMenuIfNeeded()` to inspect `_currentSettings` and `_allUserRecipes`.
-   [ ] Add temporary `print` statements in `lib/data/services/menu_generator_service.dart`'s `generateWeeklyMenu()` to inspect `userSettings` and `suitableRecipes`.
-   [ ] Run the app manually and observe the console output for the `print` statements to understand the data flow and identify where the generation is failing.
-   [ ] Based on observations, modify `lib/presentation/view_models/weekly_menu_view_model.dart` and/or `lib/data/services/menu_generator_service.dart` to correct the menu generation logic. This might involve:
    -   Ensuring `_currentSettings` and `_allUserRecipes` are always valid and accessible.
    -   Adjusting filtering criteria for `suitableRecipes`.
    -   Handling cases where `suitableRecipes` might be empty.
    -   Ensuring `notifyListeners()` is called appropriately.
-   [ ] Remove temporary `print` statements.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Verify Shopping List Generation and Final Cleanup

-   [ ] Run the app manually and verify that the shopping list is correctly generated after the weekly menu refresh.
-   [ ] Update any `README.md` file for the package with relevant information from the modification (if any).
-   [ ] Update any `GEMINI.md` file in the project directory so that it still correctly describes the app, its purpose, and implementation details and the layout of the files.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.
-   [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.