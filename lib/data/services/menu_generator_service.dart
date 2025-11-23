import 'dart:math';

import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/settings_model.dart'; // Changed from user_model.dart
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';

class MenuGeneratorService {
  Map<String, List<WeeklyMenuItemModel>> generateWeeklyMenu({
    required SettingsModel userSettings, // Changed from UserModel
    required List<RecipeModel> allRecipes,
  }) {
    final Map<String, List<WeeklyMenuItemModel>> generatedMenu = {};
    final Random random = Random();

    for (final day in userSettings.includedWeekdays) {
      // Changed from enabledDays
      generatedMenu[day] = [];
      for (final mealType in userSettings.includedMeals) {
        // Changed from enabledMeals
        // Filter recipes by meal type (category) if applicable
        List<String> targetCategories = [];
        switch (mealType) {
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
        }
      }
    }
    return generatedMenu;
  }
}
