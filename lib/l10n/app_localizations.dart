import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WeeklyMenu'**
  String get appTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordButton;

  /// No description provided for @sendResetEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmailButton;

  /// No description provided for @weeklyMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Menu'**
  String get weeklyMenuTitle;

  /// No description provided for @cookbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookbook'**
  String get cookbookTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to {email}'**
  String passwordResetEmailSent(String email);

  /// No description provided for @errorGeneratingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error generating weekly menu'**
  String get errorGeneratingMenu;

  /// No description provided for @noWeeklyMenuGenerated.
  ///
  /// In en, this message translates to:
  /// **'No weekly menu generated yet. Tap the refresh icon to generate one!'**
  String get noWeeklyMenuGenerated;

  /// No description provided for @userNotLoggedInError.
  ///
  /// In en, this message translates to:
  /// **'User not logged in.'**
  String get userNotLoggedInError;

  /// No description provided for @errorLoadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Error loading recipes.'**
  String get errorLoadingRecipes;

  /// No description provided for @recipeAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Recipe added!'**
  String get recipeAddedMessage;

  /// No description provided for @recipeUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Recipe updated!'**
  String get recipeUpdatedMessage;

  /// No description provided for @addRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Recipe'**
  String get addRecipeTitle;

  /// No description provided for @recipeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get recipeNameLabel;

  /// No description provided for @ingredientLabel.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get ingredientLabel;

  /// No description provided for @addIngredientHint.
  ///
  /// In en, this message translates to:
  /// **'Add an ingredient'**
  String get addIngredientHint;

  /// No description provided for @instructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructions (each on a new line)'**
  String get instructionsLabel;

  /// No description provided for @cuisinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Cuisines:'**
  String get cuisinesLabel;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories:'**
  String get categoriesLabel;

  /// No description provided for @starRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Star Rating:'**
  String get starRatingLabel;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeMessage;

  /// No description provided for @selectMealsForMenu.
  ///
  /// In en, this message translates to:
  /// **'Select Meals for Weekly Menu:'**
  String get selectMealsForMenu;

  /// No description provided for @selectWeekdaysForMenu.
  ///
  /// In en, this message translates to:
  /// **'Select Weekdays for Weekly Menu:'**
  String get selectWeekdaysForMenu;

  /// No description provided for @customMealTypes.
  ///
  /// In en, this message translates to:
  /// **'Custom Meal Types:'**
  String get customMealTypes;

  /// No description provided for @newMealTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new meal type name'**
  String get newMealTypeHint;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logoutButton;

  /// No description provided for @cookbookScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookbook'**
  String get cookbookScreenTitle;

  /// No description provided for @deleteRecipeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{recipeName}\"?'**
  String deleteRecipeConfirmation(String recipeName);

  /// No description provided for @noRecipesAdded.
  ///
  /// In en, this message translates to:
  /// **'No recipes added yet. Tap + to add your first recipe!'**
  String get noRecipesAdded;

  /// No description provided for @shoppingListScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingListScreenTitle;

  /// No description provided for @noItemsInShoppingList.
  ///
  /// In en, this message translates to:
  /// **'No items in the shopping list.'**
  String get noItemsInShoppingList;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items:'**
  String get totalItems;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @recipeNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Recipe name cannot be empty.'**
  String get recipeNameCannotBeEmpty;

  /// No description provided for @confirmAccountDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get confirmAccountDeletionTitle;

  /// No description provided for @confirmAccountDeletionContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get confirmAccountDeletionContent;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @reauthenticateTitle.
  ///
  /// In en, this message translates to:
  /// **'Re-authenticate'**
  String get reauthenticateTitle;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @passwordRequiredToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Password is required to delete account.'**
  String get passwordRequiredToDeleteAccount;

  /// No description provided for @editRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get editRecipeTitle;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// No description provided for @deletedMessage.
  ///
  /// In en, this message translates to:
  /// **'deleted.'**
  String get deletedMessage;

  /// No description provided for @appetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get appetizer;

  /// No description provided for @main_course.
  ///
  /// In en, this message translates to:
  /// **'Main Course'**
  String get main_course;

  /// No description provided for @dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get dessert;

  /// No description provided for @american.
  ///
  /// In en, this message translates to:
  /// **'American'**
  String get american;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @mexican.
  ///
  /// In en, this message translates to:
  /// **'Mexican'**
  String get mexican;

  /// No description provided for @indian.
  ///
  /// In en, this message translates to:
  /// **'Indian'**
  String get indian;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @mediterranean.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get mediterranean;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
