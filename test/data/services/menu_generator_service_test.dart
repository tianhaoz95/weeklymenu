import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart';
import 'package:weeklymenu/data/services/menu_generator_service.dart';
// For DeepCollectionEquality

// Mocks
class MockMealTypeRepository extends Mock implements MealTypeRepository {}

void main() {
  late MenuGeneratorService menuGeneratorService;
  late MockMealTypeRepository mockMealTypeRepository;

  setUp(() {
    mockMealTypeRepository = MockMealTypeRepository();
    menuGeneratorService = MenuGeneratorService(
      mealTypeRepository: mockMealTypeRepository,
    );
  });

  /*
  group('MenuGeneratorService', () {
    final testSettings = SettingsModel(
      includedWeekdays: ['monday', 'tuesday'],
    );

    final List<RecipeModel> testRecipes = [
      RecipeModel(
        id: 'r1',
        name: 'Scrambled Eggs',
        categories: ['breakfast'],
        cuisines: ['American'],
        userId: 'anyUserId',
      ),
      RecipeModel(
        id: 'r2',
        name: 'Chicken Stir-fry',
        categories: ['main_course'],
        cuisines: ['Chinese'],
        userId: 'anyUserId',
      ),
      RecipeModel(
        id: 'r3',
        name: 'Fruit Salad',
        categories: ['snack', 'appetizer'],
        cuisines: ['Mediterranean'],
        userId: 'anyUserId',
      ),
      RecipeModel(
        id: 'r4',
        name: 'Oatmeal',
        categories: ['breakfast'],
        cuisines: ['American'],
        userId: 'anyUserId',
      ),
    ];

    test('generateWeeklyMenu generates menu based on settings and meal types', () async {
      const userId = 'testUserId';
      final mealTypes = [
        MealTypeModel(id: 'm1', name: 'Breakfast', userId: userId),
        MealTypeModel(id: 'm2', name: 'Lunch', userId: userId),
      ];

      when(mockMealTypeRepository.getMealTypes(userId))
          .thenAnswer((_) => Stream.value(mealTypes));

      final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
        userId: userId,
        userSettings: testSettings,
        allRecipes: testRecipes,
      );

      expect(generatedMenu.keys, containsAll(['monday', 'tuesday']));
      expect(generatedMenu['monday']!.length, equals(2)); // Breakfast & Lunch
      expect(generatedMenu['tuesday']!.length, equals(2)); // Breakfast & Lunch

      // Verify that Breakfast and Lunch recipes are selected for Monday
      final mondayMeals = generatedMenu['monday']!;
      expect(mondayMeals.any((item) => item.mealType == 'Breakfast'), isTrue);
      expect(mondayMeals.any((item) => item.mealType == 'Lunch'), isTrue);

      // Verify that the meal types match the names from MealTypeModel
      expect(mondayMeals.where((item) => item.mealType == 'Breakfast').first.recipeName, anyOf('Scrambled Eggs', 'Oatmeal'));
      expect(mondayMeals.where((item) => item.mealType == 'Lunch').first.recipeName, 'Chicken Stir-fry');
    });

    test('generateWeeklyMenu handles no suitable recipes', () async {
      const userId = 'testUserId';
      final mealTypes = [
        MealTypeModel(id: 'm1', name: 'Breakfast', userId: userId),
      ];
      final noBreakfastRecipes = [
        RecipeModel(
          id: 'r5',
          name: 'Soup',
          categories: ['appetizer'],
          cuisines: ['French'],
          userId: 'anyUserId',
        ),
      ];

      when(mockMealTypeRepository.getMealTypes(userId))
          .thenAnswer((_) => Stream.value(mealTypes));

      final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
        userId: userId,
        userSettings: testSettings,
        allRecipes: noBreakfastRecipes,
      );

      expect(generatedMenu['monday']!.isEmpty, isTrue);
    });

    test('generateWeeklyMenu handles empty meal types from repository', () async {
      const userId = 'testUserId';
      final emptyMealTypes = <MealTypeModel>[];

      when(mockMealTypeRepository.getMealTypes(userId))
          .thenAnswer((_) => Stream.value(emptyMealTypes));

      final generatedMenu = await menuGeneratorService.generateWeeklyMenu(
        userId: userId,
        userSettings: testSettings,
        allRecipes: testRecipes,
      );

      expect(generatedMenu.keys, containsAll(['monday', 'tuesday']));
      expect(generatedMenu['monday']!.isEmpty, isTrue);
      expect(generatedMenu['tuesday']!.isEmpty, isTrue);
    });
  });
*/
}
