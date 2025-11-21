import 'package:flutter/material.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';

class CookbookViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;

  CookbookViewModel({RecipeRepository? recipeRepository})
      : _recipeRepository = recipeRepository ?? RecipeRepository();

  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void initialize() {
    _recipeRepository.getRecipes().listen((recipeList) {
      _recipes = recipeList;
      notifyListeners();
    });
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _recipeRepository.addRecipe(recipe);
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
