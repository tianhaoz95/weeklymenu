import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart';
import 'package:weeklymenu/presentation/screens/cookbook_screen.dart';
import 'package:weeklymenu/presentation/screens/recipe_screen.dart';
import 'package:weeklymenu/presentation/screens/login_screen.dart';
import 'package:weeklymenu/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_core/firebase_core.dart'; // Import FirebaseCore
import 'package:weeklymenu/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weekly Menu Generation End-to-End Test', () {
    testWidgets(
      'Login, delete existing recipes, add 3 recipes, generate weekly menu, and verify',
      (WidgetTester tester) async {
        // Initialize Firebase before any Firebase operations
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await FirebaseAuth.instance.signOut(); // Ensure logged out state
        await tester
            .pumpAndSettle(); // Wait for any auth state changes to propagate

        // Start the app
        app.main();
        await tester.pumpAndSettle(
          const Duration(seconds: 10),
        ); // Increased duration

        // Verify that we are on the LoginScreen
        expect(find.byType(LoginScreen), findsOneWidget);

        // Login
        final emailField = find.byKey(const Key('email_input_field'));
        final passwordField = find.byKey(const Key('password_input_field'));
        final loginButton = find.byKey(const Key('login_button'));

        await tester.enterText(emailField, 'test@weeklymenu.com');
        await tester.enterText(passwordField, '12341234');
        await tester.pumpAndSettle();

        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Get userId after login
        final userId = FirebaseAuth.instance.currentUser!.uid;
        // Clear all existing recipes directly from Firestore for a clean test environment
        await clearUserRecipes(userId);
        await tester.pumpAndSettle(
          const Duration(seconds: 5),
        ); // Increased duration to ensure full deletion

        // Verify that we are on the WeeklyMenuScreen (initial redirect after login)
        expect(find.byType(WeeklyMenuScreen), findsOneWidget);

        // Navigate to Settings screen to add 'main_course' meal type and set preferences
        final settingsTabFromWeeklyMenu = find.byIcon(Icons.settings);
        expect(settingsTabFromWeeklyMenu, findsOneWidget);
        await tester.tap(settingsTabFromWeeklyMenu);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        expect(find.byType(SettingsScreen), findsOneWidget);

        // Add 'main_course' as a custom meal type if it doesn't exist
        final newMealTypeInputField = find.byKey(
          const Key('new_meal_type_input_field'),
        );
        final addMealTypeButton = find.byKey(const Key('add_meal_type_button'));

        // Check if 'main_course' already exists in the chips
        final mainCourseChipInSettings = find.byWidgetPredicate(
          (widget) =>
              widget is Chip && (widget.label as Text).data == 'main_course',
        );

        if (!tester.any(mainCourseChipInSettings)) {
          // Only add if it doesn't exist
          expect(newMealTypeInputField, findsOneWidget);
          await tester.enterText(newMealTypeInputField, 'main_course');
          await tester.pump();

          expect(addMealTypeButton, findsOneWidget);
          await tester.tap(addMealTypeButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        }

        // Add 'appetizer' as a custom meal type if it doesn't exist
        final appetizerChipInSettings = find.byWidgetPredicate(
          (widget) =>
              widget is Chip && (widget.label as Text).data == 'appetizer',
        );

        if (!tester.any(appetizerChipInSettings)) {
          // Only add if it doesn't exist
          expect(newMealTypeInputField, findsOneWidget);
          await tester.enterText(newMealTypeInputField, 'appetizer');
          await tester.pump();

          expect(addMealTypeButton, findsOneWidget);
          await tester.tap(addMealTypeButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        }

        // Select some weekdays (e.g., Monday, Tuesday, Wednesday)
        await tester.tap(find.text('Monday'));
        await tester.pump();
        await tester.tap(find.text('Tuesday'));
        await tester.pump();
        await tester.tap(find.text('Wednesday'));
        await tester.pump();

        // Select all default meal types
        await tester.tap(find.byKey(const Key('meal_type_chip_breakfast')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('meal_type_chip_lunch')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('meal_type_chip_dinner')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('meal_type_chip_snack')));
        await tester.pump();
        await tester.pumpAndSettle(
          const Duration(seconds: 5),
        ); // Increased wait time for settings to propagate

        // Navigate to Cookbook screen
        final cookbookTab = find.byIcon(Icons.restaurant_menu);
        expect(cookbookTab, findsOneWidget);
        await tester.tap(cookbookTab);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Verify that we are on the CookbookScreen
        expect(find.byType(CookbookScreen), findsOneWidget);

        // Add three new generic test recipes
        for (int i = 1; i <= 3; i++) {
          // Tap the add recipe button
          final addRecipeButton = find.byKey(const Key('add_recipe_button'));
          expect(addRecipeButton, findsOneWidget);
          await tester.tap(addRecipeButton);
          await tester.pump();

          // Enter recipe name in the dialog
          final recipeNameInputFieldInDialog = find.byKey(
            const Key('recipe_name_input_field'),
          );
          expect(recipeNameInputFieldInDialog, findsOneWidget);
          await tester.enterText(
            recipeNameInputFieldInDialog,
            'Test Recipe $i',
          );
          await tester.pump();

          final addRecipeDialogAddButton = find.byKey(
            const Key('add_recipe_dialog_add_button'),
          );
          expect(addRecipeDialogAddButton, findsOneWidget);
          await tester.tap(addRecipeDialogAddButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify navigation to RecipeScreen
          expect(find.byType(RecipeScreen), findsOneWidget);
          await waitForWidget(
            tester,
            find.byKey(const Key('category_chip_main_course')),
          );

          // Add two ingredients
          final addIngredientButton = find.byKey(
            const Key('add_ingredient_button'),
          );
          final singleIngredientInputField = find.byKey(
            const Key('single_ingredient_input_field'),
          );

          await tester.tap(addIngredientButton);
          await tester.pump();
          expect(singleIngredientInputField, findsOneWidget);
          await tester.enterText(singleIngredientInputField, 'Ingredient A$i');
          await tester.pump();
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pump();

          await tester.tap(addIngredientButton);
          await tester.pump();
          expect(singleIngredientInputField, findsOneWidget);
          await tester.enterText(singleIngredientInputField, 'Ingredient B$i');
          await tester.pump();
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pump();

          // Select categories
          expect(
            find.byKey(const Key('category_chip_main_course')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const Key('category_chip_main_course')));
          await tester.pump();

          expect(
            find.byKey(const Key('category_chip_breakfast')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const Key('category_chip_breakfast')));
          await tester.pump();

          expect(find.byKey(const Key('category_chip_snack')), findsOneWidget);
          await tester.tap(find.byKey(const Key('category_chip_snack')));
          await tester.pump();

          expect(
            find.byKey(const Key('category_chip_appetizer')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const Key('category_chip_appetizer')));
          await tester.pump();

          // Set 2-star rating
          final starRating2 = find.byKey(const Key('star_rating_2'));
          expect(starRating2, findsOneWidget);
          await tester.tap(starRating2);
          await tester.pump();

          // Save the recipe
          final saveRecipeButton = find.byKey(const Key('save_recipe_button'));
          expect(saveRecipeButton, findsOneWidget);
          await tester.tap(saveRecipeButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Verify the new recipe appears in the CookbookScreen
          expect(find.byType(CookbookScreen), findsOneWidget);
          expect(find.text('Test Recipe $i'), findsOneWidget);
        }

        // Add a longer pumpAndSettle here to ensure all recipe streams have propagated
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Go back to Weekly Menu screen (by re-tapping the weekly menu tab)
        final weeklyMenuTab = find.byIcon(Icons.menu_book);
        expect(weeklyMenuTab, findsOneWidget);
        await tester.tap(weeklyMenuTab);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Verify that we are on the WeeklyMenuScreen
        expect(find.byType(WeeklyMenuScreen), findsOneWidget);

        // Tap the "generate" button (refresh icon in the top-right corner)
        final generateMenuButton = find.byKey(
          const Key('generate_menu_button'),
        );
        expect(generateMenuButton, findsOneWidget);
        await tester.tap(generateMenuButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert that a weekly menu is generated
        expect(
          find.text(
            'No weekly menu generated yet. Tap the refresh icon to generate one!',
          ),
          findsNothing,
        );

        // Assert that the generated recipes appear in the menu
        expect(find.textContaining('Test Recipe 1'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Test Recipe 2'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Test Recipe 3'), findsAtLeastNWidgets(1));
      },
    );
  });
}

Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool found = false;
  final stopwatch = Stopwatch()..start();
  while (!found && stopwatch.elapsed < timeout) {
    await tester.pump();
    if (tester.any(finder)) {
      found = true;
    }
  }
  expect(found, isTrue, reason: 'Widget not found within timeout: $finder');
}

Future<void> clearUserRecipes(String userId) async {
  final recipesCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cookbook');

  final snapshot = await recipesCollection.get();
  for (final doc in snapshot.docs) {
    await doc.reference.delete();
  }
}
