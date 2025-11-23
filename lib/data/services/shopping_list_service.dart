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
    print('ShoppingListService: generateShoppingList called.');
    print('  WeeklyMenuModel: ${weeklyMenu.menuItems}');
    print('  All Recipes Count: ${allRecipes.length}');

    final Map<String, Map<String, int>> aggregatedIngredientsByDay = {};

    // First, aggregate all ingredients by day and count occurrences
    for (final dayEntry in weeklyMenu.menuItems.entries) {
      final day = dayEntry.key;
      aggregatedIngredientsByDay[day] = {};
      print('    Processing day: $day');

      for (final menuItem in dayEntry.value) {
        final recipe = allRecipes.firstWhere((r) => r.id == menuItem.recipeId);
        print('      Processing recipe: ${recipe.name}');

        for (final ingredientName in recipe.ingredients) {
          final normalizedIngredient = ingredientName.trim().toLowerCase();
          aggregatedIngredientsByDay[day]!.update(
            normalizedIngredient,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
          print('        Aggregated ingredient: $normalizedIngredient, count: ${aggregatedIngredientsByDay[day]![normalizedIngredient]}');
        }
      }
    }
    print('ShoppingListService: Aggregated ingredients by day: $aggregatedIngredientsByDay');

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
    print('ShoppingListService: Final generated shopping list: $shoppingList');

    return shoppingList;
  }
}
