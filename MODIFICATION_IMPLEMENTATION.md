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

### Phase 1: Create `reset_database.py` and `scripts/README.md`

*   **Actions:**
    *   Ran all tests, confirmed project in good state.
    *   Created `scripts/reset_database.py` with recursive delete functionality for Firestore collections and subcollections.
    *   Created `scripts/README.md` with instructions for Firebase Admin SDK setup and script usage.

*   **Learnings/Surprises:**
    *   Firestore's `delete()` method for documents does not recursively delete subcollections, necessitating a custom recursive delete function in `reset_database.py`.

*   **Deviations from Plan:**
    *   None.

---

## Phases

### Phase 1: Create `reset_database.py` and `scripts/README.md`

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Create `scripts/` directory if it doesn't exist.
-   [x] Create `scripts/reset_database.py` with the functionality to:
    -   [x] Initialize Firebase Admin SDK using a service account key.
    -   [x] Implement a recursive delete function to handle subcollections.
    -   [x] Delete the old top-level `/recipes` and `/weekly_menus` collections.
    -   [x] Delete the `/users` collection and all its subcollections.
-   [x] Create `scripts/README.md` with instructions for:
    -   [x] Installing Firebase Admin SDK (`pip install firebase-admin`).
    -   [x] Generating and placing the service account key JSON file.
    -   [x] Running the `reset_database.py` script.
-   [x] Run the `dart_fix` tool to clean up the code. (No Dart code modified in this phase, but good practice).
-   [x] Run the `analyze_files` tool one more time and fix any issues. (No Dart code modified).
-   [x] Run any tests to make sure they all pass. (This refers to existing tests, no new tests created).
-   [x] Run `dart_format` to make sure that the formatting is correct. (No Dart code modified).
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it. (Not applicable as only script/docs created).

### Phase 2: Refactor `RecipeRepository` and related ViewModels

-   [ ] Modify `lib/data/repositories/recipe_repository.dart`:
    -   [ ] Adjust Firestore paths in `createRecipe`, `getRecipe`, `getRecipesForUser`, `updateRecipe`, `deleteRecipe` to be `/users/{userId}/recipes/{recipeId}`.
    -   [ ] Modify `getRecipe` and `deleteRecipe` method signatures to accept `userId` as a parameter.
-   [ ] Modify `lib/presentation/view_models/cookbook_view_model.dart`:
    -   [ ] Adjust calls to `RecipeRepository` methods (`createRecipe`, `getRecipesForUser`, `updateRecipe`, `deleteRecipe`) to pass the current `userId` (obtained from `AuthRepository`).
-   [ ] Modify `integration_test/weekly_menu_generation_test.dart` and `integration_test/settings_persistence_test.dart`:
    -   [ ] Adjust `setUpAll` and `tearDownAll` calls to `RecipeRepository.deleteRecipe` and `RecipeRepository.createRecipe` to include `userId` as a parameter.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass. (Existing integration tests will need to pass with the new paths).
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Refactor `WeeklyMenuRepository` and related ViewModels

-   [ ] Modify `lib/data/repositories/weekly_menu_repository.dart`:
    -   [ ] Adjust Firestore paths in `createOrUpdateWeeklyMenu`, `getWeeklyMenu`, `streamWeeklyMenu`, `deleteWeeklyMenu` to be `/users/{userId}/weekly_menus/current_menu`.
    -   [ ] Assume `weeklyMenu.id` is the user ID and the document ID is `current_menu`.
-   [ ] Modify `lib/presentation/view_models/weekly_menu_view_model.dart`:
    -   [ ] Adjust calls to `WeeklyMenuRepository` methods (`createOrUpdateWeeklyMenu`, `streamWeeklyMenu`) to pass the current `userId`.
-   [ ] Modify `lib/presentation/view_models/shopping_list_view_model.dart`:
    -   [ ] Adjust calls to `RecipeRepository` (if any, e.g., for `allRecipes`) and `ShoppingListRepository` methods to pass `userId` where newly required.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 4: Final Review and Cleanup

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