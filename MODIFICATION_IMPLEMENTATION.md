# Meal Type Customization Implementation Plan

## Journal

- All existing tests passed before starting modifications.
- Confirmed that `json_annotation` and `json_serializable` are already present in `pubspec.yaml`.
- `pub get` executed successfully.
- Created `lib/data/models/meal_type_model.dart`.
- Generated `lib/data/models/meal_type_model.g.dart`.
- Created `lib/data/repositories/meal_type_repository.dart`.
- Created unit tests for `MealTypeRepository` in `test/data/repositories/meal_type_repository_test.dart`.
- `dart fix --apply` found no issues.
- `analyze_files` revealed issues with mocking `cloud_firestore`'s sealed classes with `mockito`.
- Decided to use `fake_cloud_firestore` for testing `MealTypeRepository` due to `mockito`'s limitations with sealed classes.
- Added `fake_cloud_firestore` as a dev dependency.
- Modified `MealTypeModel` to extend `Equatable` to ensure proper value equality for testing streams.
- Regenerated `meal_type_model.g.dart` after adding `Equatable`.
- All `MealTypeRepository` unit tests now pass.
- All project tests pass.
- `dart format` ran successfully and formatted 3 files.
- Re-read `MODIFICATION_IMPLEMENTATION.md`, no changes in the plan.

## Phases

### Phase 1: Initial Setup and Baseline Check

- [x] Run all tests to ensure the project is in a good state before starting modifications.
- [x] Update `pubspec.yaml` to include `json_annotation` and `json_serializable` if not already present, or ensure compatible versions.
- [x] Run `pub get`.
- [x] Create `lib/data/models/meal_type_model.dart` with the `MealTypeModel` and its `json_serializable` parts.
- [x] Generate the `.g.dart` file for `MealTypeModel`.
- [x] Create `lib/data/repositories/meal_type_repository.dart` with the `MealTypeRepository` class.
- [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [x] Run the dart_fix tool to clean up the code.
- [x] Run the analyze_files tool one more time and fix any issues.
- [x] Run any tests to make sure they all pass.
- [x] Run dart_format to make sure that the formatting is correct.
- [x] Re-read the MODIFICATION_IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the MODIFICATION_IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if an app is running, use the hot_reload tool to reload it.

### Phase 2: Refactor `SettingsModel` and `SettingsRepository`

- [ ] Remove `mealTypes` from `lib/data/models/settings_model.dart`.
- [ ] Regenerate the `.g.dart` file for `SettingsModel`.
- [ ] Update `lib/data/repositories/settings_repository.dart` to remove any references to `mealTypes`.
- [ ] Update any code that uses `SettingsModel.mealTypes` directly.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the dart_fix tool to clean up the code.
- [ ] Run the analyze_files tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run dart_format to make sure that the formatting is correct.
- [ ] Re-read the MODIFICATION_IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the MODIFICATION_IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if an app is running, use the hot_reload tool to reload it.

### Phase 3: Update `UserRepository` for Default Meal Types

- [ ] Modify `lib/data/repositories/user_repository.dart` to provision default meal types ("Breakfast", "Lunch", "Dinner") when a new user is created. This will involve using `MealTypeRepository`.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the dart_fix tool to clean up the code.
- [ ] Run the analyze_files tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run dart_format to make sure that the formatting is correct.
- [ ] Re-read the MODIFICATION_IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the MODIFICATION_IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if an app is running, use the hot_reload tool to reload it.

### Phase 4: Integrate `MealTypeRepository` into `SettingsViewModel` and UI

- [ ] Update `lib/presentation/view_models/settings_view_model.dart` to:
    -   Accept `MealTypeRepository` as a dependency.
    -   Expose a stream of `List<MealTypeModel>` for meal types.
    -   Implement `addMealType` and `deleteMealType` methods using `MealTypeRepository`.
    -   Add toast messages for success/failure and console logging for errors.
- [ ] Modify `lib/presentation/screens/settings_screen.dart` to:
    -   Use `StreamBuilder` to display meal types from `SettingsViewModel`.
    -   Add a `TextField` and "Add" button for new meal types.
    -   Add "Delete" `IconButton`s next to each meal type.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the dart_fix tool to clean up the code.
- [ ] Run the analyze_files tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run dart_format to make sure that the formatting is correct.
- [ ] Re-read the MODIFICATION_IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the MODIFICATION_IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if an app is running, use the hot_reload tool to reload it.

### Phase 5: Update `MenuGeneratorService`

- [ ] Update `lib/data/services/menu_generator_service.dart` to:
    -   Accept `MealTypeRepository` as a dependency.
    -   Fetch meal types from `MealTypeRepository` instead of `SettingsModel`.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the dart_fix tool to clean up the code.
- [ ] Run the analyze_files tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run dart_format to make sure that the formatting is correct.
- [ ] Re-read the MODIFICATION_IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the MODIFICATION_IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have to be completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if an app is running, use the hot_reload tool to reload it.

### Phase 6: Final Review and Project Updates

- [ ] Update any README.md file for the package with relevant information from the modification (if any).
- [ ] Update any GEMINI.md file in the project directory so that it still correctly describes the app, its purpose, and implementation details and the layout of the files.
- [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.