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

### Phase 1: Integration Test Setup

*   **Actions:**
    *   Ran all tests, confirmed project in good state.
    *   Created `integration_test/bottom_navigator_order_test.dart`.
    *   Ran the `integration_test/bottom_navigator_order_test.dart`.

*   **Learnings/Surprises:**
    *   The test failed as expected, confirming the incorrect order of bottom navigation items. The specific failure was that the "Shopping List" item was found to the right of "Cookbook", contradicting the desired order.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 2: Implement Fix and Verify

*   **Actions:**
    *   Modified `lib/main.dart` to reorder the `StatefulShellBranch` definitions within the `StatefulShellRoute.indexedStack`'s `branches` list to: `/weekly-menu`, `/shopping-list`, `/cookbook`, `/settings`.
    *   Modified `lib/presentation/widgets/scaffold_with_nav_bar.dart` to reorder the `BottomNavigationBarItem` widgets within the `items` list of the `BottomNavigationBar` to precisely match the new order of `StatefulShellBranch`es.
    *   Ran the `integration_test/bottom_navigator_order_test.dart` and verified that it now passes.
    *   Manually verified the order of bottom navigation items in the running app.

*   **Learnings/Surprises:**
    *   Reordering `StatefulShellBranch`es in `lib/main.dart` directly impacts the order of the bottom navigation items in `ScaffoldWithNavBar`. Synchronization between these two places is critical for correct behavior and visual presentation.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 3: Final Review and Cleanup

*   **Actions:**
    *   Updated `README.md` (no changes needed for this modification).
    *   Updated `GEMINI.md` (no changes needed for this modification).
    *   Ran `dart_fix` tool (no changes applied).
    *   Ran `analyze_files` tool (no issues found).
    *   Ran all tests (all passed).
    *   Ran `dart_format` (no changes applied).
    *   Re-read the `MODIFICATION_IMPLEMENTATION.md` file (current file).

*   **Learnings/Surprises:**
    *   None.

*   **Deviations from Plan:**
    *   None.

---

## Phases

### Phase 1: Integration Test Setup

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Create `integration_test/bottom_navigator_order_test.dart` to:
    -   [x] Log in a test user.
    -   [x] Call `Firebase.initializeApp()` in `setUpAll` and `tearDownAll`.
    -   [x] Navigate to a screen that displays the `BottomNavigationBar` (e.g., `WeeklyMenuScreen`).
    -   [x] Assert the presence and order of the `BottomNavigationBarItem`s: Weekly Menu (Icons.menu_book), Shopping List (Icons.shopping_cart), Cookbook (Icons.restaurant_menu), Settings (Icons.settings).
-   [x] Run the `integration_test/bottom_navigator_order_test.dart` and observe its failure (expected, as the order is currently incorrect).
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 2: Implement Fix and Verify

-   [x] Modify `lib/main.dart`: Reorder the `StatefulShellBranch` definitions within the `StatefulShellRoute.indexedStack`'s `branches` list to:
    -   [x] `/weekly-menu` branch
    -   [x] `/shopping-list` branch
    -   [x] `/cookbook` branch
    -   [x] `/settings` branch
-   [x] Modify `lib/presentation/widgets/scaffold_with_nav_bar.dart`: Reorder the `BottomNavigationBarItem` widgets within the `items` list of the `BottomNavigationBar` to precisely match the new order of `StatefulShellBranch`es.
-   [x] Run the `integration_test/bottom_navigator_order_test.dart` and verify that it now passes.
-   [x] Manually verify the order of bottom navigation items in the running app.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Final Review and Cleanup

-   [x] Update any `README.md` file for the package with relevant information from the modification (if any).
-   [x] Update any `GEMINI.md` file in the project directory so that it still correctly describes the app, its purpose, and implementation details and the layout of the files.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.
-   [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.
