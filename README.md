# WeeklyMenu

A Flutter application for managing custom recipes, generating weekly menus, and creating shopping lists.

## Table of Contents

-   [Features](#features)
-   [Getting Started](#getting-started)
    -   [Prerequisites](#prerequisites)
    -   [Installation](#installation)
    -   [Running the App](#running-the-app)
-   [Usage](#usage)
    -   [Authentication](#authentication)
    -   [Settings](#settings)
    -   [Cookbook](#cookbook)
    -   [Weekly Menu](#weekly-menu)
    -   [Shopping List](#shopping-list)
-   [Internationalization](#internationalization)
-   [Project Structure](#project-structure)
-   [Contributing](#contributing)
-   [License](#license)

## Features

-   **User Authentication:** Secure sign-up, login, password reset, and account deletion powered by Firebase Authentication.
-   **Cookbook:** Manage your personal recipe collection, including details like ingredients, instructions, categories, cuisines, and star ratings.
-   **Weekly Menu Generation:** Generate a personalized weekly meal plan based on your dietary preferences (meals per day) and available recipes.
-   **Shopping List:** Automatically generate a shopping list from your weekly menu, with the ability to mark items as purchased.
-   **User Settings:** Customize meal types and weekdays to be included in your weekly menu generation.
-   **Internationalization:** Supports multiple languages (English and Chinese).

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.10.0 or higher)
-   [Firebase CLI](https://firebase.google.com/docs/cli)
-   A Firebase Project set up with:
    -   **Authentication:** Email/Password provider enabled.
    -   **Firestore:** A Cloud Firestore database in Native mode.
    -   **Android & iOS Apps:** Registered within your Firebase project, and `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) placed in their respective `android/app` and `ios/Runner` directories.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/weeklymenu.git
    cd weeklymenu
    ```
2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Generate Firebase options file:**
    Ensure you have `firebase_core` and `firebase_auth` configured in your `pubspec.yaml`.
    ```bash
    flutterfire configure
    ```
    *If you don't have `flutterfire_cli` installed, install it globally:*
    ```bash
    dart pub global activate flutterfire_cli
    ```
4.  **Generate localization files:**
    ```bash
    flutter gen-l10n
    ```
5.  **Generate `json_serializable` files:**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

### Running the App

1.  **Connect an emulator or device:**
    ```bash
    flutter devices
    ```
2.  **Run the application:**
    ```bash
    flutter run
    ```

## Usage

### Authentication

-   **Sign Up:** Create a new user account with email and password.
-   **Login:** Access your account with existing credentials.
-   **Forgot Password:** Reset your password via email.
-   **Sign Out:** Log out of your current session.
-   **Delete Account:** Permanently remove your account and associated data.

### Settings

Access the Settings screen to:
-   View your logged-in email.
-   Select which meal types (e.g., breakfast, lunch, dinner, snack) to include in your weekly menu.
-   Select which days of the week to generate a menu for.

### Cookbook

Manage your personal recipe collection:
-   View a list of your saved recipes.
-   Add new recipes with details like name, ingredients, instructions, categories, cuisines, and star rating.
-   Edit existing recipes.
-   Delete recipes.

### Weekly Menu

-   Generate a weekly meal plan based on your settings and available recipes.
-   Recipes are randomly selected from your cookbook based on the specified categories.
-   Regenerate the menu at any time.

### Shopping List

-   View a shopping list automatically generated from your current weekly menu.
-   Ingredients are grouped by day.
-   Mark items as checked when purchased.

## Internationalization

The application supports English (`en`) and Chinese (`zh`). The language is automatically detected based on the device's locale settings, or can be configured manually if a language picker is implemented.

## Project Structure

The project follows a standard Flutter architecture with a clear separation of concerns:

-   `lib/data/models/`: Contains data models (e.g., `RecipeModel`, `UserModel`) and their `json_serializable` generated files.
-   `lib/data/repositories/`: Handles data operations and interactions with Firebase Firestore (e.g., `RecipeRepository`, `UserRepository`).
-   `lib/data/services/`: Contains business logic and services (e.g., `MenuGeneratorService`, `ShoppingListService`).
-   `lib/l10n/`: Localization files generated from ARB.
-   `lib/presentation/screens/`: Defines the main UI screens of the application.
-   `lib/presentation/view_models/`: Manages UI-specific state and logic using `ChangeNotifier` (e.g., `AuthViewModel`, `CookbookViewModel`).
-   `lib/presentation/widgets/`: Reusable UI widgets.

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
