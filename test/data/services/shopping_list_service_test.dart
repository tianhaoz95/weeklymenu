import 'package:flutter_test/flutter_test.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart'; // Add this import
import 'package:weeklymenu/data/services/shopping_list_service.dart';

void main() {
  group('ShoppingListService', () {
    late ShoppingListService shoppingListService;
    late List<RecipeModel> mockRecipes;
    late WeeklyMenuModel mockWeeklyMenu;

    setUp(() {
      shoppingListService = ShoppingListService();

      // Mock Recipes
      mockRecipes = [
        RecipeModel(
          id: 'recipe1',
          name: 'Spaghetti Carbonara',
          ingredients: [
            'pasta',
            'eggs',
            'bacon',
            'parmesan cheese',
            'black pepper',
          ],
          instructions: [],
          categories: [],
          cuisines: [],
          rating: 0,
          userId: 'user1',
        ),
        RecipeModel(
          id: 'recipe2',
          name: 'Chicken Curry',
          ingredients: [
            'chicken',
            'onions',
            'garlic',
            'ginger',
            'curry powder',
            'coconut milk',
          ],
          instructions: [],
          categories: [],
          cuisines: [],
          rating: 0,
          userId: 'user1',
        ),
        RecipeModel(
          id: 'recipe3',
          name: 'Simple Salad',
          ingredients: ['lettuce', 'tomato', 'cucumber', 'olive oil'],
          instructions: [],
          categories: [],
          cuisines: [],
          rating: 0,
          userId: 'user1',
        ),
        RecipeModel(
          id: 'recipe4',
          name: 'Mashed Potatoes',
          ingredients: ['potatoes', 'milk', 'butter'],
          instructions: [],
          categories: [],
          cuisines: [],
          rating: 0,
          userId: 'user1',
        ),
      ];

      // Mock Weekly Menu
      mockWeeklyMenu = WeeklyMenuModel(
        id: 'menu1', // Changed from userId to id
        menuItems: {
          'monday': [
            WeeklyMenuItemModel(
              mealType: 'lunch',
              recipeId: 'recipe1',
              recipeName: 'Spaghetti Carbonara',
            ),
            WeeklyMenuItemModel(
              mealType: 'dinner',
              recipeId: 'recipe2',
              recipeName: 'Chicken Curry',
            ),
          ],
          'tuesday': [
            WeeklyMenuItemModel(
              mealType: 'lunch',
              recipeId: 'recipe3',
              recipeName: 'Simple Salad',
            ),
            WeeklyMenuItemModel(
              mealType: 'dinner',
              recipeId: 'recipe4',
              recipeName: 'Mashed Potatoes',
            ),
          ],
          'wednesday': [
            WeeklyMenuItemModel(
              mealType: 'lunch',
              recipeId: 'recipe1',
              recipeName: 'Spaghetti Carbonara',
            ), // Duplicate recipe
          ],
        },
      );
    });

    test(
      'generateShoppingList aggregates ingredients by day and consolidates duplicates',
      () {
        final shoppingList = shoppingListService.generateShoppingList(
          weeklyMenu: mockWeeklyMenu,
          allRecipes: mockRecipes,
        );

        // Verify Monday's shopping list
        final mondayList = shoppingList['monday']!;
        expect(
          mondayList.length,
          11,
        ); // 5 from recipe1 + 6 from recipe2 = 11 unique ingredients
        expect(
          mondayList.any((item) => item.name == 'pasta' && item.quantity == 1),
          isTrue,
        );
        expect(
          mondayList.any(
            (item) => item.name == 'chicken' && item.quantity == 1,
          ),
          isTrue,
        );

        // Verify Tuesday's shopping list
        final tuesdayList = shoppingList['tuesday']!;
        expect(tuesdayList.length, 7); // 4 from recipe3 + 3 from recipe4
        expect(
          tuesdayList.any(
            (item) => item.name == 'lettuce' && item.quantity == 1,
          ),
          isTrue,
        );
        expect(
          tuesdayList.any((item) => item.name == 'milk' && item.quantity == 1),
          isTrue,
        );

        // Verify Wednesday's shopping list (duplicates from Monday's recipe1)
        final wednesdayList = shoppingList['wednesday']!;
        expect(wednesdayList.length, 5);
        expect(
          wednesdayList.any(
            (item) => item.name == 'pasta' && item.quantity == 1,
          ),
          isTrue,
        );

        // Now test for consolidation when same ingredients appear multiple times on the same day
        final weeklyMenuWithDuplicates = WeeklyMenuModel(
          id: 'menu2', // Changed from userId to id
          menuItems: {
            'thursday': [
              WeeklyMenuItemModel(
                mealType: 'lunch',
                recipeId: 'recipe1',
                recipeName: 'Spaghetti Carbonara',
              ),
              WeeklyMenuItemModel(
                mealType: 'dinner',
                recipeId: 'recipe1',
                recipeName: 'Spaghetti Carbonara',
              ), // recipe1 twice
              WeeklyMenuItemModel(
                mealType: 'snack',
                recipeId: 'recipe4',
                recipeName: 'Mashed Potatoes',
              ), // potatoes, milk, butter
            ],
          },
        );

        final shoppingListWithDuplicates = shoppingListService
            .generateShoppingList(
              weeklyMenu: weeklyMenuWithDuplicates,
              allRecipes: mockRecipes,
            );

        final thursdayList = shoppingListWithDuplicates['thursday']!;
        // recipe1 ingredients: 'pasta', 'eggs', 'bacon', 'parmesan cheese', 'black pepper' (5 items)
        // recipe1 again: 'pasta', 'eggs', 'bacon', 'parmesan cheese', 'black pepper' (5 items)
        // recipe4 ingredients: 'potatoes', 'milk', 'butter' (3 items)
        // Expected consolidated: pasta(x2), eggs(x2), bacon(x2), parmesan cheese(x2), black pepper(x2), potatoes(x1), milk(x1), butter(x1)
        // Total unique items: 8 (5 from recipe1 + 3 from recipe4)
        expect(thursdayList.length, 8);
        expect(
          thursdayList.firstWhere((item) => item.name == 'pasta').quantity,
          2,
        );
        expect(
          thursdayList.firstWhere((item) => item.name == 'eggs').quantity,
          2,
        );
        expect(
          thursdayList.firstWhere((item) => item.name == 'potatoes').quantity,
          1,
        );
        expect(
          thursdayList.firstWhere((item) => item.name == 'milk').quantity,
          1,
        );
      },
    );

    test('generateShoppingList correctly handles recipes not found', () {
      final weeklyMenuWithMissingRecipe = WeeklyMenuModel(
        id: 'menu3', // Changed from userId to id
        menuItems: {
          'friday': [
            WeeklyMenuItemModel(
              mealType: 'lunch',
              recipeId: 'non_existent_recipe',
              recipeName: 'Non Existent Recipe',
            ),
          ],
        },
      );

      // Expect a StateError if a recipe is not found, as firstWhere throws if no element matches
      expect(
        () => shoppingListService.generateShoppingList(
          weeklyMenu: weeklyMenuWithMissingRecipe,
          allRecipes: mockRecipes,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
