// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WeeklyMenu';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get forgotPasswordButton => 'Forgot Password?';

  @override
  String get logoutButton => 'Sign Out';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get cookbookScreenTitle => 'Cookbook';

  @override
  String get weeklyMenuScreenTitle => 'Weekly Menu';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get shoppingListScreenTitle => 'Shopping List';

  @override
  String get addRecipeTitle => 'Add New Recipe';

  @override
  String get recipeNameLabel => 'Recipe Name';

  @override
  String get ingredientsLabel => 'Ingredients (comma-separated)';

  @override
  String get instructionsLabel => 'Instructions (each on a new line)';

  @override
  String get cuisinesLabel => 'Cuisines:';

  @override
  String get categoriesLabel => 'Categories:';

  @override
  String get starRatingLabel => 'Star Rating:';

  @override
  String get saveButton => 'Save';

  @override
  String get userNotLoggedInError => 'User not logged in.';

  @override
  String get recipeAddedMessage => 'Recipe added!';

  @override
  String get recipeUpdatedMessage => 'Recipe updated!';

  @override
  String deleteRecipeConfirmation(String recipeName) {
    return 'Are you sure you want to delete \"$recipeName\"?';
  }

  @override
  String get errorLoadingRecipes => 'Error loading recipes.';

  @override
  String get noRecipesAdded =>
      'No recipes added yet. Tap + to add your first recipe!';

  @override
  String get regenerateMenuButton => 'Regenerate Weekly Menu';

  @override
  String get errorGeneratingMenu => 'Error generating menu.';

  @override
  String get selectMealsForMenu => 'Select Meals for Weekly Menu:';

  @override
  String get selectWeekdaysForMenu => 'Select Weekdays for Weekly Menu:';

  @override
  String get sendResetEmailButton => 'Send Reset Email';

  @override
  String passwordResetEmailSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get recipeNameCannotBeEmpty => 'Recipe name cannot be empty.';

  @override
  String get confirmAccountDeletionTitle => 'Confirm Account Deletion';

  @override
  String get confirmAccountDeletionContent =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get reauthenticateTitle => 'Re-authenticate';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get passwordRequiredToDeleteAccount =>
      'Password is required to delete account.';

  @override
  String get editRecipeTitle => 'Edit Recipe';

  @override
  String get noItemsInShoppingList => 'No items in the shopping list.';

  @override
  String get noWeeklyMenuGenerated =>
      'No weekly menu generated. Tap the refresh button to generate one!';
}
