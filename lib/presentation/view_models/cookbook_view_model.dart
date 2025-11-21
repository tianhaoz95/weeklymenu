import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';

class CookbookViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CookbookViewModel({RecipeRepository? recipeRepository})
    : _recipeRepository = recipeRepository ?? RecipeRepository();

  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _recipeRepository.getRecipesForUser(user.uid).listen((recipeList) {
          _recipes = recipeList;
          notifyListeners();
        });
      } else {
        _recipes = [];
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
      await _recipeRepository.deleteRecipe(recipeId);
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
