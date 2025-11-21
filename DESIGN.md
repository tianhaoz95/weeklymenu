# WeeklyMenu App Design Document

## 1. Overview

The WeeklyMenu app is a Flutter-based mobile application designed to assist users in managing their custom recipes, generating personalized weekly meal plans, and creating dynamic shopping lists. The core functionality revolves around allowing users to input and store their own recipes, define their meal preferences (e.g., meals included, days of the week), and then automatically generate a weekly menu. A shopping list, derived from the generated menu, will also be provided, which dynamically updates with menu changes. The app will support user authentication via Firebase and offer internationalization for English and Chinese.

## 2. Detailed Analysis of Goal/Problem

The primary goal is to provide a comprehensive solution for meal planning and grocery shopping. The application addresses the common problem of meal repetition, time-consuming meal planning, and manual shopping list creation.

### 2.1. Core Features and User Stories

*   **User Authentication:**
    *   Users can sign up with email and password.
    *   Users can log in with email and password.
    *   Users can reset forgotten passwords.
    *   Users can sign out.
    *   Users can delete their account.
*   **Recipe Management (Cookbook):**
    *   Users can add new recipes, specifying name, ingredients, style, type (breakfast, lunch, dinner, snack - multi-select), and a star rating (1-5).
    *   Users can view a list of their saved recipes.
    *   Users can edit existing recipes.
*   **Weekly Menu Generation:**
    *   Users can specify which meals (breakfast, lunch, dinner, snack) and which days of the week should be included in the menu.
    *   The app automatically generates a weekly menu based on available recipes, user preferences, and recipe star ratings (higher-rated recipes are more likely to be selected).
    *   The menu generation uses a "random pick without replacement" logic per meal type and day, with replication based on star ratings.
    *   Users can regenerate the weekly menu.
*   **Shopping List:**
    *   A shopping list is automatically generated based on the ingredients from the current weekly menu.
    *   The list is organized by days of the week, with Monday on top.
    *   Users can mark items as checked/purchased.
    *   The shopping list dynamically updates when the weekly menu is regenerated, removing outdated items.
*   **Settings:**
    *   Display user's email.
    *   Allow selection of included meals (breakfast, lunch, dinner, snack).
    *   Allow selection of included weekdays.
    *   Sign out button.
    *   Delete account button.
*   **Internationalization:**
    *   Support for English and Chinese languages.
    *   Defaults to system language if available, otherwise English.

### 2.2. Screen Requirements

The application will feature the following distinct screens:

*   **Login Screen:** Email, password input, Login button, Sign Up button, Forgot Password button.
*   **Sign Up Screen:** Email, password, confirm password input, Sign Up button.
*   **Weekly Menu Screen:** List of daily menus (based on settings), Regenerate button.
*   **Cookbook Screen:** List of user recipes, Add New Recipe button.
*   **Recipe Screen:** Displays/edits recipe details (ingredients, style, type, star rating), Edit button. Pop-up for new recipe name.
*   **Shopping List Screen:** Checklist of ingredients grouped by day, dynamically updated.
*   **Settings Screen:** Welcome message, user email display, meal selector, weekday selector, Sign Out button, Delete Account button.

### 2.3. Screen Interactions/Navigation

*   **App Launch:** Login Screen -> (Successful Auth) -> Weekly Menu Screen.
*   **Login Screen:**
    *   "Sign Up" -> Sign Up Screen.
*   **Sign Up Screen:**
    *   (Successful Sign Up) -> Login Screen -> Weekly Menu Screen.
*   **Main Navigation:** Weekly Menu, Cookbook, Settings screens will be navigated via a Bottom Navigation Bar or swiping. Order: Weekly Menu, Cookbook, Settings.
*   **Settings Screen:**
    *   "Sign Out" / "Delete Account" -> Login Screen.
*   **Cookbook Screen:**
    *   Tap recipe -> Recipe Screen (for editing).
    *   "Add New Recipe" -> Pop-up for recipe name -> Recipe Screen (for details).
*   **Shopping List Screen:** Accessible from the Weekly Menu screen (likely a dedicated button or tab).

### 2.4. Backend Service (Firebase)

*   **Firebase Authentication:** Used exclusively for email and password authentication.
*   **Cloud Firestore:** Used for data storage.
    *   `/users/{uid}` collection for each user.
    *   Document structure within `/users/{uid}`:
        *   `weeklyMenu`: Stores the most recently generated weekly menu.
        *   `cookbook`: Stores user-added recipes.
        *   `profile`: Stores user-specific settings and profile data.

## 3. Alternatives Considered

### 3.1. State Management

*   **`ValueNotifier` and `ValueListenableBuilder`:**
    *   **Pros:** Simple, built-in, lightweight for very localized state.
    *   **Cons:** Not suitable for complex, application-wide state or sharing state across many distant widgets. Would lead to significant "prop drilling" or complex manual dependency passing.
    *   **Decision:** Rejected for application-wide state due to complexity, but may be used for ephemeral, local widget state.
*   **`ChangeNotifier` directly with `ListenableBuilder`:**
    *   **Pros:** Built-in, allows for complex state logic.
    *   **Cons:** Providing `ChangeNotifier` instances to the widget tree without a DI solution would require manual passing through constructors, which becomes cumbersome and error-prone in a large app.
    *   **Decision:** Will be used as the base for ViewModels, but will be combined with `Provider` for efficient dependency injection.
*   **`Provider` with `ChangeNotifier`:**
    *   **Pros:** `Provider` is a widely adopted and highly efficient solution for dependency injection in Flutter. It seamlessly integrates with `ChangeNotifier` to make state objects available throughout the widget tree without boilerplate. It simplifies listening to state changes, reduces code, and improves testability. This approach aligns with the MVVM pattern.
    *   **Cons:** It's a third-party package.
    *   **Decision:** **Selected.** Given the complexity of the app (multiple screens, shared user data, recipes, settings, authentication state), `Provider` offers significant advantages in managing and providing state objects throughout the application in a clean, maintainable, and testable manner. It adheres to the principle of "separation of concerns" effectively.

### 3.2. Navigation

*   **`Navigator 1.0` (Imperative):**
    *   **Pros:** Simple for basic push/pop navigation.
    *   **Cons:** Lacks declarative nature, struggles with deep linking, web support, and complex navigation graphs (like authenticated flows and bottom navigation with preserved state). Managing the navigation stack for bottom navigation becomes very manual and error-prone.
    *   **Decision:** Rejected due to the app's complex navigation requirements (authenticated/unauthenticated flows, bottom navigation with nested routes).
*   **`GoRouter` (Declarative):**
    *   **Pros:** Excellent for declarative routing, deep linking, and web compatibility. Its `redirect` mechanism is perfect for handling authenticated/unauthenticated flows. `StatefulShellRoute` is specifically designed for bottom navigation with preserved state, which is a critical requirement for this app. It simplifies complex navigation graphs significantly.
    *   **Cons:** Steeper learning curve compared to simple `Navigator 1.0`.
    *   **Decision:** **Selected.** `GoRouter` is the ideal choice for managing the app's complex navigation structure, particularly the authenticated redirection logic and the bottom navigation bar with independent navigation stacks for each tab.

### 3.3. Data Serialization

*   **Manual JSON Serialization:**
    *   **Pros:** No extra dependencies.
    *   **Cons:** Error-prone, verbose, difficult to maintain, especially with complex nested objects.
    *   **Decision:** Rejected.
*   **`json_serializable` with `json_annotation`:**
    *   **Pros:** Automated code generation for JSON serialization/deserialization, type-safe, reduces boilerplate, robust for complex data models, supports field renaming (e.g., camelCase to snake_case).
    *   **Cons:** Requires a build runner (`build_runner`) and additional configuration.
    *   **Decision:** **Selected.** Provides a clean, efficient, and type-safe way to map Dart objects to Firestore data and vice-versa.

## 4. Detailed Design

### 4.1. Application Architecture (MVVM-inspired)

The application will follow an MVVM-inspired architecture, emphasizing clear separation of concerns:

*   **Views (Widgets):** Responsible for rendering the UI and handling user interactions. They will observe ViewModels for state changes and trigger actions on ViewModels.
*   **ViewModels (`ChangeNotifier`s):** Hold the presentation logic and state for a specific view or feature. They expose data to the Views and contain methods to update that data. ViewModels interact with Repositories to access data. `Provider` will be used to inject ViewModels into the widget tree and allow widgets to listen to them.
*   **Repositories:** Abstract the data sources. They provide a clean API for ViewModels to interact with external data (Firebase Firestore, Firebase Auth). Repositories handle data fetching, persistence, and error handling.
*   **Services:** Utility classes for specific tasks (e.g., `AuthService` for Firebase Authentication, `RecipeService` for business logic related to recipes and menu generation). These can be used by ViewModels or Repositories.
*   **Models:** Plain Dart objects representing the application's data structures (e.g., `User`, `Recipe`, `MenuItem`, `AppSettings`). These will leverage `json_serializable` for easy mapping to/from Firestore documents.

```mermaid
graph TD
    User -- interacts with --> View
    View -- observes --> ViewModel
    View -- triggers actions on --> ViewModel
    ViewModel -- requests data from --> Repository
    Repository -- accesses --> "Data Source (Firebase Auth/Firestore)"
    Repository -- uses --> Model
    ViewModel -- uses --> Service
    Service -- uses --> Model
```

### 4.2. State Management

`Provider` will be used as the primary state management solution, integrating seamlessly with `ChangeNotifier` for ViewModels.

*   **Root `MultiProvider`:** The root of the widget tree will be wrapped with a `MultiProvider` to provide application-wide ViewModels (e.g., `AuthViewModel`, `SettingsViewModel`, `CookbookViewModel`, `WeeklyMenuViewModel`).
*   **`ChangeNotifierProvider`:** Each ViewModel (`ChangeNotifier`) will be provided using `ChangeNotifierProvider`.
*   **`Consumer` / `Selector` / `Provider.of`:** Widgets will consume state using `Consumer` (for rebuilding a subtree), `Selector` (for rebuilding only when specific parts of the state change), or `Provider.of<T>(context, listen: false)` (for calling methods without rebuilding).

### 4.3. Navigation

`GoRouter` will manage all navigation within the app, including authentication flows and bottom navigation.

*   **Authentication Redirect:** A top-level `redirect` function in `GoRouter` will observe the authentication state (from `AuthViewModel`).
    *   If `AuthViewModel.isAuthenticated` is `false`, and the user is trying to access an authenticated route, redirect to `/login`.
    *   If `AuthViewModel.isAuthenticated` is `true`, and the user is on `/login` or `/signup`, redirect to `/weekly-menu`.
*   **Root `MaterialApp.router`:** The `MaterialApp` will use `routerConfig` with the `GoRouter` instance.
*   **`StatefulShellRoute.indexedStack`:** This will be used to implement the bottom navigation bar. Each tab (Weekly Menu, Cookbook, Settings) will be a `StatefulShellBranch`, preserving its own navigation stack.
*   **Named Routes:** All major routes will use named routes for clarity and easier navigation (e.g., `GoRouter.of(context).goNamed('recipe', pathParameters: {'id': recipeId})`).

```mermaid
graph TD
    A[App Launch] --> B{Is Authenticated?};
    B -- No --> C[/login Screen];
    C -- "Successful Login/Signup" --> D[/weekly-menu];
    B -- Yes --> D[/weekly-menu];

    subgraph Authenticated Flow
        direction LR
        D -- "Bottom Nav: Weekly Menu" --> WeeklyMenuScreen;
        D -- "Bottom Nav: Cookbook" --> CookbookScreen;
        D -- "Bottom Nav: Settings" --> SettingsScreen;

        CookbookScreen -- "Tap Recipe" --> RecipeScreen("Recipe Screen (Edit)");
        CookbookScreen -- "Add New Recipe" --> RecipePopup;
        RecipePopup -- "Input Name" --> RecipeScreen("Recipe Screen (New)");

        SettingsScreen -- "Sign Out/Delete" --> C;
    end
```

### 4.4. Authentication (Firebase Auth)

An `AuthRepository` will encapsulate all Firebase Authentication logic, exposing methods like `signIn`, `signUp`, `signOut`, `resetPassword`, and `deleteAccount`.

*   **`AuthViewModel`:** This `ChangeNotifier` will hold the current `User` (from Firebase) and `UserModel` (from Firestore) and expose `Stream<User?>` from `FirebaseAuth.instance.authStateChanges()`. It will be responsible for calling `AuthRepository` methods and updating its state.
*   **User Model:** A `UserModel` will store user-specific data (email, name, settings).
*   **Initialization:** Firebase will be initialized at app startup in `main.dart`.

### 4.5. Data Model & Persistence (Firestore)

Cloud Firestore will store all user data. Data models will be defined as Dart classes and serialized/deserialized using `json_serializable`.

#### Firestore Structure:

```
/users/{uid} (Document for each user)
├── profile (Sub-collection or sub-document)
│   └── (Document for user settings, e.g., selectedMeals, selectedWeekdays)
├── cookbook (Collection of recipes)
│   ├── {recipeId} (Document for each recipe)
│   │   ├── name: String
│   │   ├── ingredients: List<String>
│   │   ├── style: String
│   │   ├── type: List<String> (e.g., ["breakfast", "lunch"])
│   │   └── rating: int (1-5)
│   └── ...
└── weeklyMenu (Collection or sub-document storing the current menu)
    └── currentMenu (Document)
        └── days: Map<String, Map<String, String>> (e.g., {"Monday": {"breakfast": "Recipe A", "lunch": "Recipe B"}})
```

#### Dart Models (`json_serializable`):

*   `UserModel`: Represents user profile data.
*   `RecipeModel`: Stores name, ingredients, style, type, rating.
*   `SettingsModel`: Stores user preferences (selected meals, weekdays).
*   `WeeklyMenuItemModel`: Represents a single meal within the weekly menu (e.g., "Monday Lunch: Chicken Salad").
*   `WeeklyMenuModel`: Aggregates `WeeklyMenuItemModel`s for the entire week.
*   `ShoppingListItemModel`: Represents an item in the shopping list (ingredient, quantity, checked status).

#### Repositories:

*   `UserRepository`: Handles CRUD operations for `UserModel` and `SettingsModel`.
*   `RecipeRepository`: Handles CRUD operations for `RecipeModel` in the `cookbook` collection.
*   `WeeklyMenuRepository`: Handles saving and retrieving `WeeklyMenuModel`.

```mermaid
erDiagram
    USER ||--o{ RECIPE : "has many"
    USER ||--|{ PROFILE : "has one"
    USER ||--|{ WEEKLY_MENU : "has one"
    RECIPE {
        string recipeId PK
        string userId FK
        string name
        list<string> ingredients
        string style
        list<string> type
        int rating
    }
    PROFILE {
        string userId PK
        list<string> selectedMeals
        list<string> selectedWeekdays
    }
    WEEKLY_MENU {
        string userId PK
        map<string, map<string, string>> days
    }
```

### 4.6. Weekly Menu Generation Logic

A `MenuGeneratorService` will implement the following logic:

1.  **Filter Recipes:** Based on `SettingsModel.selectedMeals` and `SettingsModel.selectedWeekdays`, filter the `RecipeModel`s from the user's `cookbook` to create a pool of available recipes for each meal type (breakfast, lunch, dinner, snack).
2.  **Replicate by Rating:** For each filtered recipe, replicate its entry in the pool according to its `rating` (e.g., a 2-star recipe appears twice). This increases the probability of selection for higher-rated recipes.
3.  **Random Selection (without replacement):** For each selected day and meal type:
    *   Randomly pick a recipe from the current meal-specific pool.
    *   Remove the selected recipe from the pool to ensure "without replacement" for that specific meal type within that generation cycle.
    *   If a pool runs out, handle gracefully (e.g., reuse recipes from a larger pool if no unique ones are left, or indicate insufficient recipes).
4.  **Save Menu:** Store the newly generated menu in `WeeklyMenuRepository`.

```mermaid
graph TD
    A[Start Menu Generation] --> B{Get User Settings (Meals, Days)};
    B --> C{Fetch All User Recipes};
    C --> D[Filter Recipes by Meal Type];
    D --> E[Replicate Recipes by Star Rating];
    E --> F{For Each Selected Day};
    F --> G{For Each Selected Meal Type};
    G --> H[Randomly Select Recipe from Pool];
    H --> I[Remove Selected Recipe from Pool];
    I --> J{More Meal Types?};
    J -- Yes --> G;
    J -- No --> K{More Days?};
    K -- Yes --> F;
    K -- No --> L[Compile Weekly Menu];
    L --> M[Save Weekly Menu to Firestore];
    M --> N[End Generation];
```

### 4.7. Shopping List Generation

A `ShoppingListService` will be responsible for generating and managing the shopping list.

1.  **Retrieve Weekly Menu:** Fetch the current `WeeklyMenuModel`.
2.  **Aggregate Ingredients:** For each recipe in the `WeeklyMenuModel`, retrieve its ingredients from the `cookbook` and aggregate them. Quantities will be inferred or assumed (e.g., "1 large onion" will be treated as "onion"). For initial implementation, quantities won't be calculated beyond simple aggregation of unique ingredient names.
3.  **Group by Day:** Group the aggregated ingredients by the day they appear in the menu.
4.  **Create Checklist:** Present as a checklist (`ShoppingListItemModel` with `checked` status).
5.  **Dynamic Update:** When a new weekly menu is generated and saved, the old shopping list is discarded, and a new one is generated. Checked status for items that persist will need to be intelligently transferred if possible, otherwise reset. (Initial implementation will likely reset all checked states on regeneration for simplicity).

### 4.8. Internationalization

The app will support English and Chinese.

*   **`flutter_localizations` & `intl`:** These official Flutter packages will be used for i18n.
*   **ARB Files:** All translatable strings will be stored in Application Resource Bundle (.arb) files (`app_en.arb`, `app_zh.arb`) in `lib/l10n`.
*   **Code Generation:** `flutter gen-l10n` will generate Dart code for accessing localized strings.
*   **Locale Resolution:** The `MaterialApp` will be configured to support `Locale('en')` and `Locale('zh')`, defaulting to the system locale if one of these matches, otherwise falling back to English.

### 4.9. UI/UX Considerations

*   **Material Design 3:** The app will follow Material Design 3 guidelines for a modern and consistent look and feel.
*   **Theming:** Centralized `ThemeData` with light and dark mode support, using `ColorScheme.fromSeed`.
*   **Responsiveness:** Layouts will be designed to be responsive across different screen sizes using `LayoutBuilder` and `MediaQuery`.
*   **Typography:** Consistent `TextTheme` will be defined for various text styles.
*   **Accessibility:** Focus on good contrast ratios, semantic labels, and dynamic text scaling where possible.
*   **Icons:** Use appropriate Material Icons for navigation and actions.

## 5. Summary

The WeeklyMenu app will leverage Flutter's capabilities alongside Firebase for a robust, user-friendly, and maintainable meal planning solution. An MVVM-inspired architecture with `Provider` for state management, `GoRouter` for navigation, and `json_serializable` for data persistence will ensure a clean codebase. Key features include comprehensive recipe management, intelligent weekly menu generation, dynamic shopping lists, and full internationalization. The design prioritizes modularity, testability, and a positive user experience.

## 6. References

*   **Flutter Internationalization:** [https://docs.flutter.dev/data-and-backend/internationalization](https://docs.flutter.dev/data-and-backend/internationalization)
*   **GoRouter Package:** [https://pub.dev/packages/go_router](https://pub.dev/packages/go_router)
*   **Provider Package:** [https://pub.dev/packages/provider](https://pub.dev/packages/provider)
*   **Firebase Authentication for Flutter:** [https://firebase.google.com/docs/auth/flutter/start](https://firebase.google.com/docs/auth/flutter/start)
*   **Cloud Firestore for Flutter:** [https://firebase.google.com/docs/firestore/quickstart](https://firebase.google.com/docs/firestore/quickstart)
*   **Mermaid Documentation:** [https://mermaid.js.org/syntax/flowchart.html](https://mermaid.js.org/syntax/flowchart.html)
*   **json_serializable Package:** [https://pub.dev/packages/json_serializable](https://pub.dev/packages/json_serializable)
