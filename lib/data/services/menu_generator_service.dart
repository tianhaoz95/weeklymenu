import 'dart:math';

import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';
import 'package:weeklymenu/data/models/meal_type_model.dart'; // Import MealTypeModel
import 'package:weeklymenu/data/repositories/meal_type_repository.dart'; // Import MealTypeRepository

class MenuGeneratorService {
  final MealTypeRepository _mealTypeRepository;

  MenuGeneratorService({MealTypeRepository? mealTypeRepository})
    : _mealTypeRepository = mealTypeRepository ?? MealTypeRepository();

  Future<Map<String, List<WeeklyMenuItemModel>>> generateWeeklyMenu({
    required String userId,
    required SettingsModel userSettings,
    required List<RecipeModel> allRecipes,
  }) async {
    final Map<String, List<WeeklyMenuItemModel>> generatedMenu = {};
    final Random random = Random();

    // Fetch meal types from the repository
    final List<MealTypeModel> mealTypes = await _mealTypeRepository
        .getMealTypes(userId)
        .first;

    for (final day in userSettings.includedWeekdays) {
      generatedMenu[day] = [];
      for (final mealType in mealTypes) {
        // Changed from enabledMeals
        // Filter recipes by meal type (category) if applicable
        List<String> targetCategories = [];
        switch (mealType.name.toLowerCase()) {
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
              mealType: mealType.name,
            ),
          );
        }
      }
    }
    return generatedMenu;
  }
}
