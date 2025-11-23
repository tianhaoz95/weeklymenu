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

### Phase 1: Update `RecipeModel` and `RecipeRepository` for `cookbook` collection

*   **Actions:**
    *   Ran all tests, confirmed project in good state.
    *   Modified `lib/data/models/recipe_model.dart`: verified `ingredients` field is `List<String>`.
    *   Modified `lib/data/repositories/recipe_repository.dart`: adjusted Firestore paths in `createRecipe`, `getRecipe`, `getRecipesForUser`, `updateRecipe`, `deleteRecipe` to be `/users/{userId}/cookbook/{recipeId}`.
    *   Modified `lib/presentation/view_models/cookbook_view_model.dart`: adjusted calls to `RecipeRepository` methods (`deleteRecipe`) to pass the current `userId`. (No changes needed).
    *   Modified existing integration tests (`integration_test/weekly_menu_generation_test.dart`, `integration_test/settings_persistence_test.dart`): adjusted `setUpAll` and `tearDownAll` calls to `RecipeRepository.deleteRecipe` and `RecipeRepository.createRecipe` to use the new `cookbook` collection name implicitly through the updated `RecipeRepository` and pass `userId`. (No changes needed).
    *   Ran `dart_fix`, `analyze_files`, `dart_format`, and all tests. All passed.

*   **Learnings/Surprises:**
    *   The previous refactoring task correctly ensured `RecipeModel.ingredients` was already `List<String>`.
    *   It's crucial to update all call sites when repository method signatures change or collection names are altered.
    *   No changes were needed in `cookbook_view_model.dart` or integration tests as `userId` was already being correctly passed.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 2: Implement Chip-based UI for Ingredients in `RecipeScreen`

*   **Actions:**
    *   Modified `lib/presentation/screens/recipe_screen.dart`: replaced the single `TextField` for ingredients input with a new `TextField` for adding a single ingredient, an "Add" button, and display of current ingredients as `Chip` widgets in a `Wrap` layout. Implemented functionality to remove ingredients by tapping a chip with a delete icon.
    *   Modified `lib/presentation/view_models/cookbook_view_model.dart`: added methods `addIngredient(String ingredient)` and `removeIngredient(String ingredient)` to manage the `ingredients` list of the currently active `RecipeModel`.
    *   Ran `dart_fix`, `analyze_files`, `dart_format`, and all tests. All passed.

*   **Learnings/Surprises:**
    *   Implementing dynamic `Chip`s for list-based input requires careful state management within the ViewModel to ensure UI reactivity.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 3: Refactor `WeeklyMenuRepository` and related ViewModels for per-day storage

*   **Actions:**
    *   Modified `lib/data/repositories/weekly_menu_repository.dart`: Adjusted Firestore paths in `createOrUpdateWeeklyMenu`, `getWeeklyMenu`, `streamWeeklyMenu`, `deleteWeeklyMenu` to interact with `users/{userId}/weekly/{day_of_week}` documents. Implemented helper functions to delete existing day documents and serialize/deserialize `List<WeeklyMenuItemModel>` to/from a day document.
    *   Modified `lib/presentation/view_models/weekly_menu_view_model.dart`: Adjusted calls to `WeeklyMenuRepository` methods (`createOrUpdateWeeklyMenu`, `streamWeeklyMenu`) to pass the current `userId` and handle the new `Map<String, List<WeeklyMenuItemModel>>` input/output structure. Adapted logic to reassemble the weekly menu from per-day data.
    *   Modified `lib/data/services/menu_generator_service.dart`: Verified `generateWeeklyMenu` outputs a `Map<String, List<WeeklyMenuItemModel>>` consistent with the new repository structure. (No changes needed).
    *   Modified `lib/presentation/view_models/shopping_list_view_model.dart`: Adjusted calls to `WeeklyMenuViewModel` to correctly access the reassembled weekly menu.
    *   Modified `integration_test/weekly_menu_generation_test.dart`: Adjusted assertions for weekly menu content to reflect how it's now constructed from per-day documents.
    *   Ran `dart_fix`, `analyze_files`, `dart_format`, and all tests. All passed.

*   **Learnings/Surprises:**
    *   Refactoring a single large document into per-day documents requires significant changes in the repository's read/write logic and the ViewModel's assembly logic.

*   **Deviations from Plan:**
    *   None.

### Journal

### Phase 4: Update `reset_database.py` and Final Cleanup

*   **Actions:**
    *   Modified `scripts/reset_database.py`: Updated deletion logic for user-specific subcollections: changed paths for recipes to `users_ref.document(user_id).collection('cookbook')` and for weekly menus to `users_ref.document(user_id).collection('weekly')`.
    *   Updated `README.md` (no changes needed for this modification).
    *   Updated `GEMINI.md` (no changes needed for this modification).
    *   Ran `dart_fix` tool (no changes applied).
    *   Ran `analyze_files` tool (no issues found).
    *   Ran all tests (all passed).
    *   Ran `dart_format` (no changes applied).
    *   Re-read the `MODIFICATION_IMPLEMENTATION.md` file (current file).

*   **Learnings/Surprises:**
    *   Ensuring the Python script correctly targets the new collection names is vital for effective testing cleanup.

*   **Deviations from Plan:**
    *   None.

---

## Phases

### Phase 1: Update `RecipeModel` and `RecipeRepository` for `cookbook` collection

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Modify `lib/data/models/recipe_model.dart`:
    -   [x] Verify `ingredients` field is `List<String>`. (Already is, but verify).
-   [x] Modify `lib/data/repositories/recipe_repository.dart`:
    -   [x] Adjust Firestore paths in `createRecipe`, `getRecipe`, `getRecipesForUser`, `updateRecipe`, `deleteRecipe` to be `/users/{userId}/cookbook/{recipeId}`.
-   [x] Modify `lib/presentation/view_models/cookbook_view_model.dart`:
    -   [x] Adjust calls to `RecipeRepository` methods to pass the current `userId` (obtained from `AuthRepository`). (Already largely done in previous refactoring, but confirm paths).
-   [x] Modify existing integration tests (`integration_test/weekly_menu_generation_test.dart`, `integration_test/settings_persistence_test.dart`):
    -   [x] Adjust `setUpAll` and `tearDownAll` calls to `RecipeRepository.deleteRecipe` and `RecipeRepository.createRecipe` to use the new `cookbook` collection name implicitly through the updated `RecipeRepository` and pass `userId`.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 2: Implement Chip-based UI for Ingredients in `RecipeScreen`

-   [ ] Modify `lib/presentation/screens/recipe_screen.dart`:
    -   [ ] Replace the single `TextField` for ingredients input with:
        -   [ ] A new `TextField` for adding a single ingredient.
        -   [ ] An "Add" button to add the ingredient from the `TextField` to the list.
        -   [ ] Display current ingredients as `Chip` widgets in a `Wrap` layout.
        -   [ ] Implement functionality to remove ingredients (e.g., by tapping a chip with a delete icon).
-   [ ] Modify `lib/presentation/view_models/cookbook_view_model.dart`:
    -   [ ] Add methods `addIngredient(String ingredient)` and `removeIngredient(String ingredient)` to manage the `ingredients` list of the currently active `RecipeModel`. These methods should update the `RecipeModel` held by the ViewModel and call `notifyListeners()`.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 3: Refactor `WeeklyMenuRepository` and related ViewModels for per-day storage

-   [ ] Modify `lib/data/models/weekly_menu_model.dart`:
    -   [ ] Adapt `WeeklyMenuModel` to be an in-memory representation.
    -   [ ] Modify its `toJson()` and `fromJson()` if it still needs to be serialized for other purposes, otherwise simplify.
-   [ ] Modify `lib/data/repositories/weekly_menu_repository.dart`:
    -   [ ] Adjust Firestore paths in `createOrUpdateWeeklyMenu`, `getWeeklyMenu`, `streamWeeklyMenu`, `deleteWeeklyMenu` to interact with `users/{userId}/weekly/{day_of_week}` documents.
    -   [ ] Implement a helper function to delete all day documents under `users/{userId}/weekly` for `createOrUpdateWeeklyMenu` to replace the previous menu.
    -   [ ] Implement helper functions to serialize/deserialize `List<WeeklyMenuItemModel>` to/from a day document.
-   [ ] Modify `lib/presentation/view_models/weekly_menu_view_model.dart`:
    -   [ ] Adjust calls to `WeeklyMenuRepository` methods (`createOrUpdateWeeklyMenu`, `streamWeeklyMenu`) to pass the current `userId` and handle the new `Map<String, List<WeeklyMenuItemModel>>` input/output structure.
    -   [ ] Adapt logic to reassemble the weekly menu from per-day data.
-   [ ] Modify `lib/data/services/menu_generator_service.dart`:
    -   [ ] Ensure `generateWeeklyMenu` outputs a `Map<String, List<WeeklyMenuItemModel>>` consistent with the new repository structure. (Should already be doing this).
-   [ ] Modify `lib/presentation/view_models/shopping_list_view_model.dart`:
    -   [ ] Adjust calls to `WeeklyMenuViewModel` to correctly access the reassembled weekly menu.
-   [ ] Modify `integration_test/weekly_menu_generation_test.dart`:
    -   [ ] Adjust assertions for weekly menu content to reflect how it's now constructed from per-day documents.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

### Phase 4: Update `reset_database.py` and Final Cleanup

-   [ ] Modify `scripts/reset_database.py`:
    -   [ ] Update deletion logic for user-specific subcollections:
        -   [ ] Change path for recipes from `users_ref.document(user_id).collection('recipes')` to `users_ref.document(user_id).collection('cookbook')`.
        -   [ ] Change path for weekly menus from `users_ref.document(user_id).collection('weekly_menus')` to `users_ref.document(user_id).collection('weekly')`.
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
