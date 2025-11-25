import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart'; // Import MealTypeRepository
import 'package:weeklymenu/data/models/meal_type_model.dart'; // Import MealTypeModel
import 'dart:async'; // Import for StreamSubscription

class CookbookViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final MealTypeRepository _mealTypeRepository; // Add MealTypeRepository
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CookbookViewModel({
    RecipeRepository? recipeRepository,
    MealTypeRepository? mealTypeRepository, // Accept MealTypeRepository
  }) : _recipeRepository = recipeRepository ?? RecipeRepository(),
       _mealTypeRepository =
           mealTypeRepository ??
           MealTypeRepository(); // Initialize MealTypeRepository

  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MealTypeModel> _mealTypes = [];
  List<MealTypeModel> get mealTypes => _mealTypes;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<List<MealTypeModel>>? _mealTypesSubscription;

  void initialize() {
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _mealTypesSubscription?.cancel(); // Cancel previous subscription
      if (user != null) {
        _recipeRepository.getRecipesForUser(user.uid).listen((recipeList) {
          _recipes = recipeList;
          notifyListeners();
        });

        // Stream meal types for the user
        _mealTypesSubscription = _mealTypeRepository
            .getMealTypes(user.uid)
            .listen((mealTypeList) {
              _mealTypes = mealTypeList;
              notifyListeners();
            });
      } else {
        _recipes = [];
        _mealTypes = []; // Clear meal types on logout
        notifyListeners();
      }
    });
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _setErrorMessage('User not logged in.');
        return;
      }
      // Ensure the recipe has the current user's ID
      final recipeWithUserId = recipe.copyWith(userId: userId);
      await _recipeRepository.createRecipe(recipeWithUserId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRecipe(RecipeModel recipe) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _recipeRepository.updateRecipe(recipe);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _setErrorMessage('User not logged in.');
        return;
      }
      await _recipeRepository.deleteRecipe(userId, recipeId);
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
