import 'package:flutter_test/flutter_test.dart';
import 'package:weeklymenu/data/models/recipe_model.dart'; // Import RecipeModel
import 'package:weeklymenu/data/models/settings_model.dart'; // Import SettingsModel
import 'package:weeklymenu/data/services/menu_generator_service.dart';

void main() {
  late MenuGeneratorService menuGeneratorService;

  setUp(() {
    menuGeneratorService = MenuGeneratorService();
  });

  group('MenuGeneratorService', () {
    final testSettings = SettingsModel(
      includedWeekdays: ['monday', 'tuesday'],
      includedMealTypes: [
        'breakfast',
        'lunch',
        'dinner',
        'snack',
      ], // Added meal types
    );

    final List<RecipeModel> testRecipes = [
      RecipeModel(
        id: 'r1',
        name: 'Scrambled Eggs',
        categories: ['breakfast'],
        cuisines: ['American'],
        userId: 'anyUserId',
        rating: 2, // Add rating for better testing
      ),
      RecipeModel(
        id: 'r2',
        name: 'Chicken Stir-fry',
        categories: ['main_course'],
        cuisines: ['Chinese'],
        userId: 'anyUserId',
        rating: 3,
      ),
      RecipeModel(
        id: 'r3',
        name: 'Fruit Salad',
        categories: ['snack', 'appetizer'],
        cuisines: ['Mediterranean'],
        userId: 'anyUserId',
        rating: 1,
      ),
      RecipeModel(
        id: 'r4',
        name: 'Oatmeal',
        categories: ['breakfast'],
        cuisines: ['American'],
        userId: 'anyUserId',
        rating: 4,
      ),
      RecipeModel(
        id: 'r5',
        name: 'Pasta',
        categories: ['main_course'],
        cuisines: ['Italian'],
        userId: 'anyUserId',
        rating: 5,
      ),
    ];

    test(
      'generateWeeklyMenu generates menu based on settings and meal types',
      () async {
        const userId = 'testUserId';

        final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
          userId: userId,
          userSettings: testSettings,
          allRecipes: testRecipes,
        );

        expect(generatedMenu.keys, containsAll(['monday', 'tuesday']));
        // Expect all meal types to be present for each day
        expect(
          generatedMenu['monday']!.length,
          equals(testSettings.includedMealTypes.length),
        );
        expect(
          generatedMenu['tuesday']!.length,
          equals(testSettings.includedMealTypes.length),
        );

        // Verify that all included meal types have a recipe
        for (final day in testSettings.includedWeekdays) {
          for (final mealType in testSettings.includedMealTypes) {
            expect(
              generatedMenu[day]!.any((item) => item.mealType == mealType),
              isTrue,
            );
          }
        }

        // Further assertions can be added to check recipe names based on categories
        // For breakfast
        expect(
          generatedMenu['monday']!
              .where((item) => item.mealType == 'breakfast')
              .first
              .recipeName,
          anyOf('Scrambled Eggs', 'Oatmeal'),
        );
        // For lunch/dinner (main_course)
        expect(
          generatedMenu['monday']!
              .where((item) => item.mealType == 'lunch')
              .first
              .recipeName,
          anyOf('Chicken Stir-fry', 'Pasta'),
        );
      },
    );

    test(
      'generateWeeklyMenu handles no suitable recipes for a meal type',
      () async {
        const userId = 'testUserId';
        final testSettingsNoDinner = SettingsModel(
          includedWeekdays: ['monday'],
          includedMealTypes: ['breakfast', 'lunch'],
        );

        final List<RecipeModel> onlyBreakfastRecipes = [
          RecipeModel(
            id: 'r1',
            name: 'Scrambled Eggs',
            categories: ['breakfast'],
            userId: 'anyUserId',
            rating: 3,
          ),
        ];

        final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
          userId: userId,
          userSettings: testSettingsNoDinner,
          allRecipes: onlyBreakfastRecipes,
        );

        expect(
          generatedMenu['monday']!.length,
          equals(2),
        ); // Breakfast and Lunch
        expect(
          generatedMenu['monday']!.any((item) => item.mealType == 'breakfast'),
          isTrue,
        );
        // Lunch should be empty or a placeholder if no suitable recipe
        expect(
          generatedMenu['monday']!.any((item) => item.mealType == 'lunch'),
          isTrue,
        );
        expect(
          generatedMenu['monday']!
              .firstWhere((item) => item.mealType == 'lunch')
              .recipeName,
          'No Recipe Found',
        ); // Assuming "No Recipe Found" is placeholder from service
      },
    );

    test('generateWeeklyMenu handles empty recipe list', () async {
      const userId = 'testUserId';

      final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
        userId: userId,
        userSettings: testSettings,
        allRecipes: [],
      );

      expect(generatedMenu.keys, containsAll(['monday', 'tuesday']));
      expect(
        generatedMenu['monday']!.length,
        equals(testSettings.includedMealTypes.length),
      );
      expect(
        generatedMenu['monday']!.every(
          (item) => item.recipeName == 'No Recipe Found',
        ),
        isTrue,
      );
    });
  });
}
