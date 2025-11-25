import 'dart:math';

import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';
// Remove unused imports
// import 'package:weeklymenu/data/models/meal_type_model.dart';
// import 'package:weeklymenu/data/repositories/meal_type_repository.dart';

class MenuGeneratorService {
  MenuGeneratorService();

  Future<Map<String, List<WeeklyMenuItemModel>>> generateWeeklyMenu({
    required String userId,
    required SettingsModel userSettings,
    required List<RecipeModel> allRecipes,
  }) async {
    final Map<String, List<WeeklyMenuItemModel>> generatedMenu = {};
    final Random random = Random();

    for (final day in userSettings.includedWeekdays) {
      generatedMenu[day] = [];
      for (final mealType in userSettings.includedMealTypes) {
        // Filter recipes by meal type (category) if applicable
        List<String> targetCategories = [];
        switch (mealType.toLowerCase()) {
          case 'breakfast':
            targetCategories.add('breakfast');
            break;
          case 'lunch':
          case 'dinner':
            targetCategories.add('main_course');
            break;
          case 'snack':
            targetCategories.add('snack');
            targetCategories.add('appetizer');
            break;
        }

        final suitableRecipes = allRecipes.where((recipe) {
          // Check if any of the recipe's categories match the targetCategories for the mealType
          return recipe.categories.any(
            (category) => targetCategories.contains(category),
          );
        }).toList();

        if (suitableRecipes.isNotEmpty) {
          // Select a random recipe
          final selectedRecipe =
              suitableRecipes[random.nextInt(suitableRecipes.length)];
          generatedMenu[day]!.add(
            WeeklyMenuItemModel(
              recipeId: selectedRecipe.id!,
              recipeName: selectedRecipe.name,
              mealType: mealType,
            ),
          );
        } else {
          // Add a placeholder if no suitable recipe is found
          generatedMenu[day]!.add(
            WeeklyMenuItemModel(
              recipeId: null, // No recipe ID for placeholder
              recipeName: 'No Recipe Found', // Placeholder text
              mealType: mealType,
            ),
          );
        }
      }
    }
    return generatedMenu;
  }
}
