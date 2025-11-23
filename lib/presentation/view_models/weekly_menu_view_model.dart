import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/settings_model.dart'; // Import SettingsModel
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart'; // Import SettingsRepository
import 'package:weeklymenu/data/repositories/weekly_menu_repository.dart';
import 'package:weeklymenu/data/services/menu_generator_service.dart';
import 'dart:async'; // Import for StreamSubscription

class WeeklyMenuViewModel extends ChangeNotifier {
  final WeeklyMenuRepository _weeklyMenuRepository;
  final SettingsRepository _settingsRepository; // Use SettingsRepository
  final RecipeRepository _recipeRepository;
  final MenuGeneratorService _menuGeneratorService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WeeklyMenuViewModel({
    WeeklyMenuRepository? weeklyMenuRepository,
    SettingsRepository? settingsRepository, // Add SettingsRepository
    RecipeRepository? recipeRepository,
    MenuGeneratorService? menuGeneratorService,
  }) : _weeklyMenuRepository = weeklyMenuRepository ?? WeeklyMenuRepository(),
       _settingsRepository =
           settingsRepository ??
           SettingsRepository(), // Initialize SettingsRepository
       _recipeRepository = recipeRepository ?? RecipeRepository(),
       _menuGeneratorService = menuGeneratorService ?? MenuGeneratorService();

  WeeklyMenuModel? _weeklyMenu;
  WeeklyMenuModel? get weeklyMenu => _weeklyMenu;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SettingsModel? _currentSettings; // Change to SettingsModel
  List<RecipeModel> _allUserRecipes = [];

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<SettingsModel?>?
  _settingsSubscription; // Change to SettingsModel
  StreamSubscription<List<RecipeModel>>? _recipesSubscription;
  StreamSubscription<WeeklyMenuModel?>? _weeklyMenuSubscription;

  void initialize() {
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _settingsSubscription?.cancel();
      _recipesSubscription?.cancel();
      _weeklyMenuSubscription?.cancel();

      if (user != null) {
        // Stream user settings
        _settingsSubscription = _settingsRepository
            .getSettings(user.uid)
            .listen((settings) {
              _currentSettings = settings;
              _generateAndSaveMenuIfNeeded();
            });

        // Stream all recipes for the user
        _recipesSubscription = _recipeRepository
            .getRecipesForUser(user.uid)
            .listen((recipes) {
              _allUserRecipes = recipes;
              _generateAndSaveMenuIfNeeded();
            });

        // Stream weekly menu from repository
        _weeklyMenuSubscription = _weeklyMenuRepository
            .streamWeeklyMenu(user.uid)
            .listen((menu) {
              _weeklyMenu = menu;
              notifyListeners();
            });
      } else {
        _weeklyMenu = null;
        _currentSettings = null;
        _allUserRecipes = [];
        notifyListeners();
      }
    });
  }

  // Generates and saves a new menu if settings or recipes have changed
  void _generateAndSaveMenuIfNeeded() {
    if (_currentSettings != null && _allUserRecipes.isNotEmpty) {
      // Logic to decide if a new menu needs to be generated.
      // For now, we'll generate every time settings or recipes update.
      // In a real app, you might compare timestamps or hashes of settings/recipes.
      generateWeeklyMenu();
    }
  }

  Future<void> generateWeeklyMenu() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      return;
    }

    if (_currentSettings == null || _allUserRecipes.isEmpty) {
      _setErrorMessage('User settings or recipes not loaded.');
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      final newMenuMap = await _menuGeneratorService.generateWeeklyMenu(
        userId: userId,
        userSettings: _currentSettings!,
        allRecipes: _allUserRecipes,
      );
      await _weeklyMenuRepository.createOrUpdateWeeklyMenu(userId, newMenuMap);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _settingsSubscription?.cancel(); // Changed from _userSettingsSubscription
    _recipesSubscription?.cancel();
    _weeklyMenuSubscription?.cancel();
    super.dispose();
  }
}
