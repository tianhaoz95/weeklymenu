import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/shopping_list_item_model.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/services/shopping_list_service.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart'; // Import WeeklyMenuViewModel

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListService _shoppingListService;
  final RecipeRepository _recipeRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // We will listen to WeeklyMenuViewModel for changes to the weekly menu
  WeeklyMenuViewModel? _weeklyMenuViewModel;

  ShoppingListViewModel({
    ShoppingListService? shoppingListService,
    RecipeRepository? recipeRepository,
  }) : _shoppingListService = shoppingListService ?? ShoppingListService(),
       _recipeRepository = recipeRepository ?? RecipeRepository();

  Map<String, List<ShoppingListItemModel>> _shoppingList = {};
  Map<String, List<ShoppingListItemModel>> get shoppingList => _shoppingList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void updateWeeklyMenuViewModel(WeeklyMenuViewModel weeklyMenuViewModel) {
    if (_weeklyMenuViewModel != weeklyMenuViewModel) {
      _weeklyMenuViewModel = weeklyMenuViewModel;
      _weeklyMenuViewModel!.addListener(_generateShoppingList);
      _generateShoppingList(); // Generate initial list
    }
  }

  @override
  void dispose() {
    _weeklyMenuViewModel?.removeListener(_generateShoppingList);
    super.dispose();
  }

  Future<void> _generateShoppingList() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      return;
    }

    if (_weeklyMenuViewModel?.weeklyMenu == null ||
        _weeklyMenuViewModel!.weeklyMenu!.menuItems.isEmpty) {
      _shoppingList = {};
      notifyListeners();
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      final List<RecipeModel> allRecipes = await _recipeRepository
          .getRecipesForUser(userId)
          .first; // Get latest recipes
      _shoppingList = _shoppingListService.generateShoppingList(
        weeklyMenu: _weeklyMenuViewModel!.weeklyMenu!,
        allRecipes: allRecipes,
      );
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void toggleItemChecked(String day, int index, bool? isChecked) {
    if (_shoppingList.containsKey(day) &&
        index >= 0 &&
        index < _shoppingList[day]!.length) {
      _shoppingList[day]![index] = _shoppingList[day]![index].copyWith(
        isChecked: isChecked ?? false,
      );
      notifyListeners();
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
