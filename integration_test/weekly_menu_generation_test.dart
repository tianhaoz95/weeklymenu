import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart';
import 'package:weeklymenu/presentation/screens/cookbook_screen.dart';
import 'package:weeklymenu/presentation/screens/recipe_screen.dart';
import 'package:weeklymenu/presentation/screens/login_screen.dart';
import 'package:weeklymenu/presentation/screens/settings_screen.dart'; // Import SettingsScreen

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weekly Menu Generation End-to-End Test', () {
    testWidgets(
      'Login, delete existing recipes, add 3 recipes, generate weekly menu, and verify',
      (WidgetTester tester) async {
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

        // Verify that we are on the WeeklyMenuScreen (initial redirect after login)
        expect(find.byType(WeeklyMenuScreen), findsOneWidget);

        // Navigate to Cookbook screen
        final cookbookTab = find.byIcon(Icons.restaurant_menu);
        expect(cookbookTab, findsOneWidget);
        await tester.tap(cookbookTab);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Verify that we are on the CookbookScreen
        expect(find.byType(CookbookScreen), findsOneWidget);

        // Delete existing recipes
        final Finder recipeListItemFinder = find.byKey(
          const Key('recipe_list_item_0'),
          skipOffstage: false,
        );
        final Finder deleteRecipeItemButtonFinder = find.byKey(
          const Key('delete_recipe_item_button'),
        );
        final Finder confirmDeleteButtonFinder = find.byKey(
          const Key('confirm_delete_button'),
        );

        while (tester.any(recipeListItemFinder)) {
          // Find the delete button within the first recipe list item
          final specificDeleteButton = find.descendant(
            of: recipeListItemFinder,
            matching: find.byKey(const Key('delete_recipe_item_button')),
          );
          await tester.tap(specificDeleteButton); // Tap this specific button
          await tester.pump();
          await tester.tap(confirmDeleteButtonFinder);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        }

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
          await tester.pumpAndSettle(
            const Duration(seconds: 2),
          ); // Duration for navigation

          // Verify navigation to RecipeScreen
          expect(find.byType(RecipeScreen), findsOneWidget);
          await tester.pump(
            const Duration(milliseconds: 100),
          ); // Short delay for layout

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

          // Set 2-star rating
          final starRating2 = find.byKey(const Key('star_rating_2'));
          expect(starRating2, findsOneWidget);
          await tester.tap(starRating2);
          await tester.pump();

          // Save the recipe
          final saveRecipeButton = find.byKey(const Key('save_recipe_button'));
          expect(saveRecipeButton, findsOneWidget);
          await tester.tap(saveRecipeButton);
          await tester.pumpAndSettle(
            const Duration(milliseconds: 500),
          ); // Allow time for saving and navigation

          // Verify the new recipe appears in the CookbookScreen
          expect(find.byType(CookbookScreen), findsOneWidget);
          expect(find.text('Test Recipe $i'), findsOneWidget);
        }

        // Navigate to Settings screen and set preferences
        final settingsTab = find.byIcon(Icons.settings);
        expect(settingsTab, findsOneWidget);
        await tester.tap(settingsTab);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Verify we are on SettingsScreen
        expect(find.byType(SettingsScreen), findsOneWidget);
        // Select some weekdays (e.g., Monday, Tuesday, Wednesday)
        await tester.tap(find.text('Monday'));
        await tester.pump();
        await tester.tap(find.text('Tuesday'));
        await tester.pump();
        await tester.tap(find.text('Wednesday'));
        await tester.pump();

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
        await tester.pumpAndSettle(const Duration(seconds: 2));

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

        // Also check for meal types to ensure proper structure
        expect(find.text('BREAKFAST'), findsOneWidget);
        expect(find.text('LUNCH'), findsOneWidget);
        expect(find.text('DINNER'), findsOneWidget);
        expect(find.text('SNACK'), findsOneWidget);
      },
    );
  });
}
