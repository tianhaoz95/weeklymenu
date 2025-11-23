import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart';
import 'package:weeklymenu/presentation/screens/shopping_list_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weekly Menu Generation Test', () {
    final String testEmail = 'test_menu_gen@example.com';
    final String testPassword = 'Password123!';
    late String userId;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final firebaseAuth = FirebaseAuth.instance;
      final settingsRepository = SettingsRepository();
      final recipeRepository = RecipeRepository();

      // Ensure no user is logged in
      await firebaseAuth.signOut();

      // Try to create user, if exists, sign in
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          await firebaseAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          );
        } else {
          rethrow;
        }
      }
      userId = firebaseAuth.currentUser!.uid;

      // Clean up any previous test data
      await settingsRepository.saveSettings(userId, SettingsModel(id: userId));
      final existingRecipes = await recipeRepository
          .getRecipesForUser(userId)
          .first;
      for (var recipe in existingRecipes) {
        await recipeRepository.deleteRecipe(
          userId,
          recipe.id!,
        ); // Corrected call
      }

      // Add test recipes
      await recipeRepository.createRecipe(
        // Corrected call
        RecipeModel.newRecipe(name: 'Scrambled Eggs', userId: userId).copyWith(
          categories: ['breakfast', 'main_course'],
          ingredients: ['eggs', 'milk', 'butter'],
        ),
      );
      await recipeRepository.createRecipe(
        // Corrected call
        RecipeModel.newRecipe(
          name: 'Chicken Stir-fry',
          userId: userId,
        ).copyWith(
          categories: ['main_course'],
          ingredients: ['chicken breast', 'broccoli', 'soy sauce'],
        ),
      );
      await recipeRepository.createRecipe(
        // Corrected call
        RecipeModel.newRecipe(name: 'Fruit Smoothie', userId: userId).copyWith(
          categories: ['snack'],
          ingredients: ['banana', 'spinach', 'almond milk'],
        ),
      );

      // Set user preferences
      await settingsRepository.saveSettings(
        userId,
        SettingsModel(
          id: userId,
          includedMeals: ['breakfast', 'lunch', 'dinner', 'snack'],
          includedWeekdays: [
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
          ],
        ),
      );
    });

    tearDownAll(() async {
      await Firebase.initializeApp(); // Ensure Firebase is initialized for cleanup
      final firebaseAuth = FirebaseAuth.instance;
      final recipeRepository = RecipeRepository();
      // Clean up test recipes
      final existingRecipes = await recipeRepository
          .getRecipesForUser(userId)
          .first;
      for (var recipe in existingRecipes) {
        await recipeRepository.deleteRecipe(
          userId,
          recipe.id!,
        ); // Corrected call
      }
      // Delete test user
      await firebaseAuth.currentUser?.delete();
    });

    testWidgets('Weekly menu and shopping list should generate correctly', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to WeeklyMenuScreen
      await tester.tap(find.byIcon(Icons.menu_book));
      await tester.pumpAndSettle();

      // Tap the refresh icon to generate the menu
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Increased duration for generation

      // Assert that no error message is displayed
      expect(find.text('User settings or recipes not loaded.'), findsNothing);
      expect(
        find.text('Error generating weekly menu'),
        findsNothing,
      ); // Specific error from previous task

      // Assert that a weekly menu is displayed
      expect(find.byType(WeeklyMenuScreen), findsOneWidget);
      expect(
        find.textContaining('Scrambled Eggs'),
        findsWidgets,
        reason: 'Should find generated breakfast recipe',
      );
      expect(
        find.textContaining('Chicken Stir-fry'),
        findsWidgets,
        reason: 'Should find generated main course recipe',
      );
      expect(
        find.textContaining('Fruit Smoothie'),
        findsWidgets,
        reason: 'Should find generated snack recipe',
      );

      // Navigate to ShoppingListScreen
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert that the shopping list is displayed and contains expected items
      expect(find.byType(ShoppingListScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('eggs'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain eggs',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('milk'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain milk',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('butter'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain butter',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('chicken breast'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain chicken breast',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('broccoli'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain broccoli',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('soy sauce'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain soy sauce',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('banana'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain banana',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('spinach'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain spinach',
      );
      expect(
        find.descendant(
          of: find.byType(ShoppingListScreen),
          matching: find.textContaining('almond milk'),
        ),
        findsWidgets,
        reason: 'Shopping list should contain almond milk',
      );
    });
  });
}
