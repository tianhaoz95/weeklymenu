import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/shopping_list_item_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';

class ShoppingListService {
  Map<String, List<ShoppingListItemModel>> generateShoppingList({
    required WeeklyMenuModel weeklyMenu,
    required List<RecipeModel> allRecipes,
  }) {
    final Map<String, List<ShoppingListItemModel>> shoppingList = {};

    for (final dayEntry in weeklyMenu.menuItems.entries) {
      final day = dayEntry.key;
      for (final menuItem in dayEntry.value) {
        final recipe = allRecipes.firstWhere((r) => r.id == menuItem.recipeId);

        for (final ingredient in recipe.ingredients) {
          // Simple parsing: assuming ingredient is like "2 cups flour" or "1 onion"
          // This is a basic implementation and can be improved with a more robust parser
          final parts = ingredient.split(' ');
          double quantity = 1.0;
          String unit = 'unit';
          String name = ingredient;

          if (parts.isNotEmpty) {
            try {
              quantity = double.parse(parts[0]);
              if (parts.length > 1) {
                unit = parts[1];
                name = parts.sublist(2).join(' ');
              } else {
                name = parts[0];
              }
            } catch (e) {
              quantity = 1.0;
              unit = 'unit';
              name = ingredient;
            }
          }

          if (!shoppingList.containsKey(day)) {
            shoppingList[day] = [];
          }
          shoppingList[day]!.add(
            ShoppingListItemModel(name: name, unit: unit, quantity: quantity),
          );
        }
      }
    }
    return shoppingList;
  }
}
