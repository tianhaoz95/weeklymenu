# WeeklyMenu App Modification Design Document

## 1. Overview

This document outlines the design for two new features in the WeeklyMenu Flutter application: a language switcher on the Settings page and a new Shopping List screen accessible via the bottom navigation bar.

The language switcher will allow users to dynamically change the application's language between English, Chinese, and the system default. The selected preference will persist across app launches.

The Shopping List screen will display a consolidated list of ingredients derived from the recipes in the user's weekly menu. Ingredients will be grouped by day, quantities consolidated, and each item will feature a checkbox to mark it as purchased. The shopping list will automatically update whenever the weekly menu changes and its state (including checked items) will be persisted in Firestore.

## 2. Detailed Analysis of the Goal or Problem

### 2.1 Language Switcher

**Goal:** Provide users with the ability to switch the application's display language.

**Problem:** Currently, the application uses Flutter's default localization behavior, which relies on the system locale. There is no user-facing control to override this preference.

**Requirements:**
*   **UI:** A dropdown menu on the Settings page.
*   **Options:** English, Chinese, System Default.
*   **Persistence:** Selected language preference must persist across app launches using local preferences (`shared_preferences`).
*   **No special UI requirements.**

### 2.2 Shopping List Screen

**Goal:** Display a dynamic shopping list generated from the active weekly menu, allowing users to track ingredients.

**Problem:** Users currently have no way to view a consolidated list of ingredients needed for their weekly meal plan.

**Requirements:**
*   **Accessibility:** Accessible via the bottom navigation bar (new tab).
*   **Content Source:** Ingredients derived from recipes in the user's weekly menu.
*   **Grouping:** Ingredients grouped by days of the week.
*   **Ingredient Format:** Each ingredient in `RecipeModel.ingredients` is a `String` representing the ingredient name (e.g., "milk", "onion"), without quantities or units in the string itself.
*   **Consolidation:** Duplicate ingredients within the same day's grouping should be consolidated and displayed with a count (e.g., "milk (x2)").
*   **Visual Presentation:** A list with checkboxes to mark items as purchased.
*   **Generation:** Automatically generated and updated whenever the weekly menu changes.
*   **Persistence:** The shopping list content and checked/unchecked states must persist across app launches, stored in Firestore.

## 3. Alternatives Considered

### 3.1 Language Switcher

*   **Single Cycling Button:** Considered but rejected. A dropdown provides a clearer overview of available options and allows direct selection, which is generally better for usability than cycling through options, especially with more than two languages.
*   **Radio Buttons/Segmented Control:** Considered but rejected. While clear, a dropdown consumes less vertical space, which is often valuable in mobile settings pages.

### 3.2 Shopping List Screen

*   **Grouping by Category:** Considered but rejected for initial implementation. Grouping by day was explicitly requested. Grouping by grocery category is a common and useful feature for shopping lists but adds significant complexity to the data processing (e.g., a predefined ingredient-to-category mapping). This could be a future enhancement.
*   **Manual Generation:** Considered but rejected. Automatic generation ensures the list is always up-to-date with the weekly menu, reducing user friction.
*   **Persistence in Local Storage:** Considered for simplicity, but rejected. User preference for Firestore persistence was explicitly stated, aligning with existing data storage patterns for other user data.

## 4. Detailed Design for the Modification

### 4.1 Language Switcher

**UI Implementation (SettingsScreen):**
A `DropdownButton` will be added to the `SettingsScreen`. The dropdown will display the current language (English, Chinese, or System Default). Tapping it will reveal the options for selection.

**State Management (SettingsViewModel & LocaleProvider):**
1.  **`shared_preferences` Integration:** The `shared_preferences` package will be used to store the user's preferred `languageCode` (e.g., 'en', 'zh', or 'system').
2.  **New `LocaleProvider` (or extension of `SettingsViewModel`):**
    *   A new `LocaleProvider` `ChangeNotifier` will be introduced to manage the current `Locale`. This provider will:
        *   Load the saved `languageCode` from `shared_preferences` on initialization. If no preference is found, it will default to the system locale.
        *   Expose the current `Locale` as a getter.
        *   Provide a `setLocale(Locale newLocale)` method to update the preference, save it to `shared_preferences`, and call `notifyListeners()`.
        *   Provide a `setSystemLocale()` method to revert to the system's default, clearing the saved preference.
3.  **`MaterialApp.router` Configuration (`main.dart`):**
    *   The `MaterialApp.router` widget will be wrapped with a `ChangeNotifierProvider<LocaleProvider>`.
    *   Its `locale` property will listen to `LocaleProvider.locale`.
    *   `supportedLocales` and `localizationsDelegates` are already configured.
4.  **`SettingsScreen` Integration:**
    *   The `SettingsScreen` will consume the `LocaleProvider`.
    *   The `DropdownButton`'s value will reflect `LocaleProvider.locale`.
    *   `onChanged` callback will call `LocaleProvider.setLocale()` or `LocaleProvider.setSystemLocale()`.

**Data Flow:**
User selects language (SettingsScreen) -> `LocaleProvider.setLocale()`/`setSystemLocale()` called -> Preference saved to `shared_preferences` -> `notifyListeners()` called -> `MaterialApp.router` rebuilds with new `locale` -> UI updates with new localized strings.

### 4.2 Shopping List Screen

**Data Model (`ShoppingListItemModel` modification):**
The existing `ShoppingListItemModel` in `lib/data/models/shopping_list_item_model.dart` needs to be enhanced to better support consolidation and Firebase persistence of `isChecked` status.
*   `id`: `String` (Firestore document ID).
*   `name`: `String` (e.g., "milk").
*   `quantity`: `int` (default 1, incremented for consolidated items).
*   `unit`: `String` (will be "item" initially, can be expanded later).
*   `isChecked`: `bool` (default `false`).
*   `userId`: `String` (for multi-user support, already present).
A new field `dailyMenuId` will be added to associate shopping list items with the weekly menu entry they originated from, helping with automatic regeneration logic.

**Service Layer (`ShoppingListService` enhancement):**
The existing `ShoppingListService` in `lib/data/services/shopping_list_service.dart` will be responsible for:
1.  **`generateShoppingList(WeeklyMenuModel weeklyMenu, List<RecipeModel> allRecipes)`:**
    *   Iterate through `weeklyMenu.menuItems` by day.
    *   For each `WeeklyMenuItemModel`, retrieve the corresponding `RecipeModel` using its `recipeId`.
    *   Extract `ingredients` (`List<String>`) from each `RecipeModel`.
    *   Aggregate all ingredient names for the day.
    *   Consolidate duplicate ingredient names within the day, counting occurrences (e.g., "onion (x2)").
    *   Map these aggregated and consolidated items to `ShoppingListItemModel` objects, setting `quantity` and `name` (e.g., "onion", "x2" can be part of the display name).
    *   Return a `Map<String, List<ShoppingListItemModel>>` where the key is the day and the value is the list of items for that day.
    *   Consider creating a helper class `ParsedIngredient` if more complex parsing of quantity/unit is needed in the future, but for now, the `ShoppingListItemModel` will hold the simple name and count.

**Repository Layer (`ShoppingListRepository` new):**
A new `ShoppingListRepository` in `lib/data/repositories/shopping_list_repository.dart` will handle CRUD operations for `ShoppingListItemModel` with Firestore.
1.  `Future<void> saveShoppingList(String userId, Map<String, List<ShoppingListItemModel>> shoppingList)`: Saves the entire daily-grouped shopping list to Firestore.
2.  `Stream<Map<String, List<ShoppingListItemModel>>> getShoppingList(String userId)`: Streams the user's shopping list from Firestore.
3.  `Future<void> updateShoppingListItem(String userId, String day, ShoppingListItemModel item)`: Updates the status of a single item.

**State Management (`ShoppingListViewModel` enhancement):**
The existing `ShoppingListViewModel` will be enhanced to:
1.  **Listen to `WeeklyMenuViewModel`:** Be notified when the weekly menu changes.
2.  **Trigger Generation:** When the weekly menu changes (and on initialization), call `ShoppingListService.generateShoppingList()` to get the new list.
3.  **Persist to Firestore:** After generation, call `ShoppingListRepository.saveShoppingList()` to store the generated list in Firestore.
4.  **Listen to `ShoppingListRepository`:** Stream the user's shopping list from Firestore, updating its internal state (`shoppingList`) and notifying listeners.
5.  **`toggleItemChecked(String day, int itemIndex, bool? isChecked)`:** Update the `isChecked` status of an item and call `ShoppingListRepository.updateShoppingListItem()`.
6.  Expose `isLoading`, `errorMessage`, and the `Map<String, List<ShoppingListItemModel>> shoppingList`.

**UI Implementation (`ShoppingListScreen` & Bottom Navigation):**
1.  **New `ShoppingListScreen` (`lib/presentation/screens/shopping_list_screen.dart`):**
    *   Display the `shoppingList` grouped by day using `ListView.builder` for days and nested `ListView.builder` or `Column` for items within each day.
    *   Each item will be a `CheckboxListTile` displaying the consolidated ingredient name and count (e.g., "milk (x2)").
    *   The `onChanged` of the checkbox will call `ShoppingListViewModel.toggleItemChecked()`.
    *   Handle loading and error states from `ShoppingListViewModel`.
    *   Display a message when the shopping list is empty.
2.  **Bottom Navigation (`main.dart`):**
    *   A new `BottomNavigationBarItem` will be added for the "Shopping List" in `ScaffoldWithNavBar`.
    *   A new `StatefulShellBranch` will be added to `GoRouter` in `main.dart` for the `/shopping-list` route, pointing to `ShoppingListScreen`.

## 5. Diagrams

### 5.1 Language Switcher Data Flow

```mermaid
graph TD
    A[Settings Screen] -- User selects language --> B{LocaleProvider.setLocale/setSystemLocale};
    B -- Calls --> C[SharedPreferences.setString/remove];
    B -- Calls --> D{notifyListeners()};
    D -- Triggers rebuild --> E[MaterialApp.router];
    E -- Updates "locale" property --> F[Flutter Localization System];
    F -- Propagates change --> G[All Widgets (e.g. AppLocalizations.of(context).text)];
```

### 5.2 Shopping List Generation & Persistence

```mermaid
graph TD
    A[Weekly Menu ViewModel] -- onWeeklyMenuChange --> B[Shopping List ViewModel];
    B -- Calls --> C[ShoppingListService.generateShoppingList];
    C -- Uses --> D[Weekly Menu Model];
    C -- Uses --> E[Recipe Models];
    C -- Returns consolidated items --> B;
    B -- Calls --> F[ShoppingListRepository.saveShoppingList];
    F -- Persists to --> G[Firestore];
    G -- Streams updates --> H[ShoppingListRepository.getShoppingList];
    H -- Updates --> B;
    B -- Calls --> I{notifyListeners()};
    I -- Triggers rebuild --> J[Shopping List Screen];
    J -- User checks item --> B;
    B -- Calls --> F;
```

## 6. Summary of the Design

The language switcher will be implemented as a `DropdownButton` on the Settings page, leveraging `shared_preferences` for local persistence. A new `LocaleProvider` will manage the selected locale and rebuild the `MaterialApp.router` to apply changes.

The Shopping List feature will involve enhancing the `ShoppingListItemModel` to include `quantity` and `unit` (initially "item") and an `isChecked` flag. The `ShoppingListService` will be extended to aggregate and consolidate ingredients from the weekly menu. A new `ShoppingListRepository` will manage Firestore persistence. The `ShoppingListViewModel` will listen to weekly menu changes to automatically generate, persist, and stream the shopping list. The `ShoppingListScreen` will provide a checkbox-enabled list grouped by day, accessible via a new bottom navigation tab.

## 7. References to Research URLs

*   [Flutter Internationalization and localization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
*   [Flutter `shared_preferences` package](https://pub.dev/packages/shared_preferences)
*   [Flutter `GoRouter` package](https://pub.dev/packages/go_router)
*   [Flutter `Provider` package](https://pub.dev/packages/provider)
*   [Flutter `cloud_firestore` package](https://pub.dev/packages/cloud_firestore)
*   [Flutter `json_serializable` package](https://pub.dev/packages/json_serializable)
*   [Effective Dart: Style Guide](https://dart.dev/guides/language/effective-dart/style)
*   [Flutter Widget Testing](https://flutter.dev/docs/testing/widget-tests)
*   [Flutter Integration Testing](https://flutter.dev/docs/testing/integration-tests)
