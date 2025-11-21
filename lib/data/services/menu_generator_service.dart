import 'dart:math';

import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/user_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';

class MenuGeneratorService {
  WeeklyMenuModel generateWeeklyMenu({
    required UserModel userSettings,
    required List<RecipeModel> allRecipes,
  }) {
    final Map<String, List<WeeklyMenuItemModel>> generatedMenu = {};
    final Random random = Random();

    for (final day in userSettings.enabledDays) {
      generatedMenu[day] = [];
      for (final mealType in userSettings.enabledMeals) {
        // Filter recipes by meal type (category) if applicable
        final suitableRecipes = allRecipes.where((recipe) {
          return recipe.categories.contains(mealType);
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

    return WeeklyMenuModel(id: userSettings.id, menuItems: generatedMenu);
  }
}
