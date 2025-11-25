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
  String get loginButton => 'Login';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get forgotPasswordButton => 'Forgot Password?';

  @override
  String get sendResetEmailButton => 'Send Reset Email';

  @override
  String get weeklyMenuTitle => 'Weekly Menu';

  @override
  String get cookbookTitle => 'Cookbook';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get noAccountYet => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get nameHint => 'Name';

  @override
  String passwordResetEmailSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get errorGeneratingMenu => 'Error generating weekly menu';

  @override
  String get noWeeklyMenuGenerated =>
      'No weekly menu generated yet. Tap the refresh icon to generate one!';

  @override
  String get userNotLoggedInError => 'User not logged in.';

  @override
  String get errorLoadingRecipes => 'Error loading recipes.';

  @override
  String get recipeAddedMessage => 'Recipe added!';

  @override
  String get recipeUpdatedMessage => 'Recipe updated!';

  @override
  String get addRecipeTitle => 'Add New Recipe';

  @override
  String get recipeNameLabel => 'Recipe Name';

  @override
  String get ingredientLabel => 'Ingredient';

  @override
  String get addIngredientHint => 'Add an ingredient';

  @override
  String get instructionsLabel => 'Instructions (each on a new line)';

  @override
  String get cuisinesLabel => 'Cuisines:';

  @override
  String get categoriesLabel => 'Categories:';

  @override
  String get starRatingLabel => 'Star Rating:';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get selectMealsForMenu => 'Select Meals for Weekly Menu:';

  @override
  String get selectWeekdaysForMenu => 'Select Weekdays for Weekly Menu:';

  @override
  String get customMealTypes => 'Custom Meal Types:';

  @override
  String get newMealTypeHint => 'Enter new meal type name';

  @override
  String get logoutButton => 'Sign Out';

  @override
  String get cookbookScreenTitle => 'Cookbook';

  @override
  String deleteRecipeConfirmation(String recipeName) {
    return 'Are you sure you want to delete \"$recipeName\"?';
  }

  @override
  String get noRecipesAdded =>
      'No recipes added yet. Tap + to add your first recipe!';

  @override
  String get shoppingListScreenTitle => 'Shopping List';

  @override
  String get noItemsInShoppingList => 'No items in the shopping list.';

  @override
  String get totalItems => 'Total Items:';

  @override
  String get saveButton => 'Save';

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
  String get error => 'Error';

  @override
  String get guest => 'Guest';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get deletedMessage => 'deleted.';

  @override
  String get appetizer => 'Appetizer';

  @override
  String get main_course => 'Main Course';

  @override
  String get dessert => 'Dessert';

  @override
  String get american => 'American';

  @override
  String get italian => 'Italian';

  @override
  String get mexican => 'Mexican';

  @override
  String get indian => 'Indian';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get mediterranean => 'Mediterranean';

  @override
  String get languagePreference => 'Language Preference';

  @override
  String get english => 'English';

  @override
  String get systemDefault => 'System Default';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginToYourCookbook => 'Log in to your cookbook.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters long.';

  @override
  String get password => 'Password';
}
