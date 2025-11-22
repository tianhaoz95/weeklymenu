import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/shopping_list_item_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:uuid/uuid.dart';

class ShoppingListService {
  final Uuid _uuid = const Uuid();

  Map<String, List<ShoppingListItemModel>> generateShoppingList({
    required WeeklyMenuModel weeklyMenu,
    required List<RecipeModel> allRecipes,
  }) {
    final Map<String, Map<String, int>> aggregatedIngredientsByDay = {};

    // First, aggregate all ingredients by day and count occurrences
    for (final dayEntry in weeklyMenu.menuItems.entries) {
      final day = dayEntry.key;
      aggregatedIngredientsByDay[day] = {};

      for (final menuItem in dayEntry.value) {
        final recipe = allRecipes.firstWhere((r) => r.id == menuItem.recipeId);

        for (final ingredientName in recipe.ingredients) {
          aggregatedIngredientsByDay[day]!.update(
            ingredientName.trim().toLowerCase(),
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }
    }

    // Then, convert aggregated data into ShoppingListItemModel instances
    final Map<String, List<ShoppingListItemModel>> shoppingList = {};
    aggregatedIngredientsByDay.forEach((day, ingredientsMap) {
      shoppingList[day] = [];
      ingredientsMap.forEach((name, count) {
        shoppingList[day]!.add(
          ShoppingListItemModel(
            id: _uuid.v4(),
            name: name,
            quantity: count,
            unit: 'item', // Default unit as per design
            isChecked: false,
            dailyMenuId: day, // Associate with the day it came from
          ),
        );
      });
    });

    return shoppingList;
  }
}
