import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/user_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/repositories/user_repository.dart';
import 'package:weeklymenu/data/repositories/weekly_menu_repository.dart';
import 'package:weeklymenu/data/services/menu_generator_service.dart';

class WeeklyMenuViewModel extends ChangeNotifier {
  final WeeklyMenuRepository _weeklyMenuRepository;
  final UserRepository _userRepository;
  final RecipeRepository _recipeRepository;
  final MenuGeneratorService _menuGeneratorService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WeeklyMenuViewModel({
    WeeklyMenuRepository? weeklyMenuRepository,
    UserRepository? userRepository,
    RecipeRepository? recipeRepository,
    MenuGeneratorService? menuGeneratorService,
  }) : _weeklyMenuRepository = weeklyMenuRepository ?? WeeklyMenuRepository(),
       _userRepository = userRepository ?? UserRepository(),
       _recipeRepository = recipeRepository ?? RecipeRepository(),
       _menuGeneratorService = menuGeneratorService ?? MenuGeneratorService();

  WeeklyMenuModel? _weeklyMenu;
  WeeklyMenuModel? get weeklyMenu => _weeklyMenu;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUserSettings;
  List<RecipeModel> _allUserRecipes = [];

  void initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // Stream user settings
        _userRepository.streamUser(user.uid).listen((userModel) {
          _currentUserSettings = userModel;
          _generateAndSaveMenuIfNeeded();
        });

        // Stream all recipes for the user
        _recipeRepository.getRecipesForUser(user.uid).listen((recipes) {
          _allUserRecipes = recipes;
          _generateAndSaveMenuIfNeeded();
        });

        // Stream weekly menu from repository
        _weeklyMenuRepository.streamWeeklyMenu(user.uid).listen((menu) {
          _weeklyMenu = menu;
          notifyListeners();
        });
      } else {
        _weeklyMenu = null;
        _currentUserSettings = null;
        _allUserRecipes = [];
        notifyListeners();
      }
    });
  }

  // Generates and saves a new menu if settings or recipes have changed
  void _generateAndSaveMenuIfNeeded() {
    if (_currentUserSettings != null && _allUserRecipes.isNotEmpty) {
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

    if (_currentUserSettings == null || _allUserRecipes.isEmpty) {
      _setErrorMessage('User settings or recipes not loaded.');
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      final newMenu = _menuGeneratorService.generateWeeklyMenu(
        userSettings: _currentUserSettings!,
        allRecipes: _allUserRecipes,
      );
      await _weeklyMenuRepository.createOrUpdateWeeklyMenu(newMenu);
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
}
