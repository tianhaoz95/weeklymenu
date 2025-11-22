import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart';
import 'package:weeklymenu/presentation/screens/cookbook_screen.dart';
import 'package:weeklymenu/presentation/screens/recipe_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login, Navigation, and Recipe Management Test', () {
    testWidgets('Login, navigate to Cookbook, add a recipe, and verify', (
      WidgetTester tester,
    ) async {
      // Ensure environment variables are set
      const testEmail = String.fromEnvironment('TEST_EMAIL');
      const testPassword = String.fromEnvironment('TEST_PASSWORD');

      expect(
        testEmail,
        isNotEmpty,
        reason: 'TEST_EMAIL environment variable must be set',
      );
      expect(
        testPassword,
        isNotEmpty,
        reason: 'TEST_PASSWORD environment variable must be set',
      );

      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the email and password input fields
      final emailField = find.byKey(const Key('email_input_field'));
      final passwordField = find.byKey(const Key('password_input_field'));
      final loginButton = find.byKey(const Key('login_button'));

      // Enter test credentials
      await tester.enterText(emailField, testEmail);
      await tester.enterText(passwordField, testPassword);
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Increased duration for full navigation and data load

      // Verify that we are on the WeeklyMenuScreen
      expect(find.byType(WeeklyMenuScreen), findsOneWidget);

      // Navigate to the Cookbook screen
      final cookbookTab = find.byIcon(Icons.restaurant_menu);
      expect(cookbookTab, findsOneWidget);
      await tester.tap(cookbookTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that we are on the CookbookScreen
      expect(find.byType(CookbookScreen), findsOneWidget);

      // Add a new recipe
      final addRecipeButton = find.byKey(const Key('add_recipe_button'));
      expect(addRecipeButton, findsOneWidget);
      await tester.tap(addRecipeButton);
      await tester.pumpAndSettle();

      // Enter recipe name in the dialog
      final recipeNameInputField = find.byKey(
        const Key('recipe_name_input_field'),
      );
      expect(recipeNameInputField, findsOneWidget);
      final uniqueRecipeName =
          'Test Recipe ${DateTime.now().millisecondsSinceEpoch}';
      await tester.enterText(recipeNameInputField, uniqueRecipeName);
      await tester.pumpAndSettle();

      final addRecipeDialogAddButton = find.byKey(
        const Key('add_recipe_dialog_add_button'),
      );
      expect(addRecipeDialogAddButton, findsOneWidget);
      await tester.tap(addRecipeDialogAddButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify navigation to RecipeScreen
      expect(find.byType(RecipeScreen), findsOneWidget);

      // Enter ingredients and instructions
      final ingredientsInputField = find.byKey(
        const Key('ingredients_input_field'),
      );
      final instructionsInputField = find.byKey(
        const Key('instructions_input_field'),
      );

      expect(ingredientsInputField, findsOneWidget);
      expect(instructionsInputField, findsOneWidget);

      await tester.enterText(
        ingredientsInputField,
        'Ingredient 1, Ingredient 2',
      );
      await tester.enterText(instructionsInputField, 'Step 1\nStep 2');
      await tester.pumpAndSettle();

      // Tap the save button
      final saveRecipeButton = find.byKey(const Key('save_recipe_button'));
      expect(saveRecipeButton, findsOneWidget);
      await tester.tap(saveRecipeButton);
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Increased duration for full navigation and data load

      // Verify the new recipe appears in the CookbookScreen
      expect(
        find.byType(CookbookScreen),
        findsOneWidget,
      ); // Should be back on CookbookScreen
      expect(find.text(uniqueRecipeName), findsOneWidget);
    });
  });
}
