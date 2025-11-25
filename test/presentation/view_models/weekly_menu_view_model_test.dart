import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weeklymenu/data/repositories/weekly_menu_repository.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/services/menu_generator_service.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:rxdart/rxdart.dart'; // For BehaviorSubject

import 'weekly_menu_view_model_test.mocks.dart';

@GenerateMocks([
  WeeklyMenuRepository,
  SettingsRepository,
  RecipeRepository,
  MenuGeneratorService,
  FirebaseAuth,
  User,
])
void main() {
  group('WeeklyMenuViewModel', () {
    late MockWeeklyMenuRepository mockWeeklyMenuRepository;
    late MockSettingsRepository mockSettingsRepository;
    late MockRecipeRepository mockRecipeRepository;
    late MockMenuGeneratorService mockMenuGeneratorService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    late BehaviorSubject<User?> authStateChangesController;
    late BehaviorSubject<SettingsModel> settingsController; // Corrected type
    late BehaviorSubject<List<RecipeModel>> recipesController;
    late BehaviorSubject<WeeklyMenuModel?> weeklyMenuController;

    setUp(() {
      mockWeeklyMenuRepository = MockWeeklyMenuRepository();
      mockSettingsRepository = MockSettingsRepository();
      mockRecipeRepository = MockRecipeRepository();
      mockMenuGeneratorService = MockMenuGeneratorService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      authStateChangesController = BehaviorSubject<User?>();
      settingsController =
          BehaviorSubject<SettingsModel>(); // Corrected initialization
      recipesController = BehaviorSubject<List<RecipeModel>>();
      weeklyMenuController = BehaviorSubject<WeeklyMenuModel?>();

      when(
        mockFirebaseAuth.authStateChanges(),
      ).thenAnswer((_) => authStateChangesController.stream);
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('testUserId');

      when(
        mockSettingsRepository.getSettings('testUserId'),
      ).thenAnswer((_) => settingsController.stream);
      when(
        mockRecipeRepository.getRecipesForUser('testUserId'),
      ).thenAnswer((_) => recipesController.stream);
      when(
        mockWeeklyMenuRepository.streamWeeklyMenu('testUserId'),
      ).thenAnswer((_) => weeklyMenuController.stream);

      when(
        mockMenuGeneratorService.generateWeeklyMenu(
          userId: anyNamed('userId'),
          userSettings: anyNamed('userSettings'),
          allRecipes: anyNamed('allRecipes'),
        ),
      ).thenAnswer((_) async => {}); // Return an empty map for now

      when(
        mockWeeklyMenuRepository.createOrUpdateWeeklyMenu(any, any),
      ).thenAnswer((_) async => {});
    });

    tearDown(() {
      authStateChangesController.close();
      settingsController.close();
      recipesController.close();
      weeklyMenuController.close();
    });

    test(
      'should not generate weekly menu automatically when settings or recipes update after initialization',
      () async {
        final viewModel = WeeklyMenuViewModel(
          weeklyMenuRepository: mockWeeklyMenuRepository,
          settingsRepository: mockSettingsRepository,
          recipeRepository: mockRecipeRepository,
          menuGeneratorService: mockMenuGeneratorService,
          firebaseAuth: mockFirebaseAuth, // Pass the mock here
        );
        viewModel.initialize();

        authStateChangesController.add(mockUser);
        await Future.delayed(Duration.zero); // Allow stream to propagate

        final mockSettings = SettingsModel(
          id: 'testUserId',
          includedWeekdays: ['MONDAY', 'TUESDAY'], // Corrected parameter name
          includedMealTypes: [], // Corrected parameter name
        );
        settingsController.add(
          mockSettings,
        ); // No ! needed as settingsController is non-nullable now
        await Future.delayed(Duration.zero); // Allow stream to propagate

        final List<RecipeModel> mockRecipes = [
          RecipeModel(
            id: '1',
            userId: 'testUserId',
            name: 'Recipe 1',
            categories: ['Breakfast'],
          ),
        ];
        recipesController.add(mockRecipes);
        await Future.delayed(Duration.zero); // Allow stream to propagate

        verifyNever(
          mockMenuGeneratorService.generateWeeklyMenu(
            userId: anyNamed('userId'),
            userSettings: anyNamed('userSettings'),
            allRecipes: anyNamed('allRecipes'),
          ),
        );
      },
    );

    test(
      'should generate weekly menu when generateWeeklyMenu is explicitly called',
      () async {
        // Reset mocks to ensure a clean slate for this test
        reset(mockMenuGeneratorService);

        final viewModel = WeeklyMenuViewModel(
          weeklyMenuRepository: mockWeeklyMenuRepository,
          settingsRepository: mockSettingsRepository,
          recipeRepository: mockRecipeRepository,
          menuGeneratorService: mockMenuGeneratorService,
          firebaseAuth: mockFirebaseAuth, // Pass the mock here
        );
        viewModel.initialize();

        authStateChangesController.add(mockUser);
        await Future.delayed(Duration.zero);

        final mockSettings = SettingsModel(
          id: 'testUserId',
          includedWeekdays: ['MONDAY', 'TUESDAY'], // Corrected parameter name
          includedMealTypes: [], // Corrected parameter name
        );
        settingsController.add(mockSettings);
        await Future.delayed(Duration.zero);

        final List<RecipeModel> mockRecipes = [
          RecipeModel(
            id: '1',
            userId: 'testUserId',
            name: 'Recipe 1',
            categories: ['Breakfast'],
          ),
        ];
        recipesController.add(mockRecipes);
        await Future.delayed(Duration.zero);

        // Explicitly call generateWeeklyMenu
        await viewModel.generateWeeklyMenu();

        // Verify that generateWeeklyMenu was called
        verify(
          mockMenuGeneratorService.generateWeeklyMenu(
            userId: 'testUserId',
            userSettings: mockSettings,
            allRecipes: mockRecipes,
          ),
        ).called(1);
      },
    );
  });
}
