import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/data/models/shopping_list_item_model.dart';
import 'package:weeklymenu/data/repositories/auth_repository.dart'; // New import
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/repositories/shopping_list_repository.dart'; // New import
import 'package:weeklymenu/data/services/shopping_list_service.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart'; // Import WeeklyMenuViewModel
import 'dart:async'; // For StreamSubscription

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListService _shoppingListService;
  final ShoppingListRepository _shoppingListRepository; // New dependency
  final RecipeRepository _recipeRepository;
  final AuthRepository _authRepository; // New dependency
  // final FirebaseAuth _auth = FirebaseAuth.instance; // No longer needed directly here

  final WeeklyMenuViewModel _weeklyMenuViewModel; // Made final and required

  ShoppingListViewModel({
    ShoppingListService? shoppingListService,
    ShoppingListRepository? shoppingListRepository,
    RecipeRepository? recipeRepository,
    required WeeklyMenuViewModel weeklyMenuViewModel, // Required dependency
    AuthRepository? authRepository,
  }) : _shoppingListService = shoppingListService ?? ShoppingListService(),
       _shoppingListRepository =
           shoppingListRepository ?? ShoppingListRepository(),
       _recipeRepository = recipeRepository ?? RecipeRepository(),
       _weeklyMenuViewModel = weeklyMenuViewModel, // Initialize here
       _authRepository = authRepository ?? AuthRepository();

  Map<String, List<ShoppingListItemModel>> _shoppingList = {};
  Map<String, List<ShoppingListItemModel>> get shoppingList => _shoppingList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<Map<String, List<ShoppingListItemModel>>>?
  _shoppingListSubscription;
  VoidCallback? _weeklyMenuViewModelListener;

  void initialize() {
    _authStateSubscription = _authRepository.userChanges.listen((User? user) {
      _shoppingListSubscription?.cancel();
      if (_weeklyMenuViewModelListener != null) {
        _weeklyMenuViewModel.removeListener(_weeklyMenuViewModelListener!);
      }

      if (user != null) {
        // Listen to WeeklyMenuViewModel changes to regenerate shopping list
        _weeklyMenuViewModelListener = () {
          _generateAndSaveShoppingList();
        };
        if (_weeklyMenuViewModelListener != null) {
          _weeklyMenuViewModel.addListener(_weeklyMenuViewModelListener!);
        }
        _generateAndSaveShoppingList(); // Initial generation on login

        // Stream shopping list from repository
        _shoppingListSubscription = _shoppingListRepository
            .getShoppingList(user.uid)
            .listen((list) {
              _shoppingList = list;
              notifyListeners();
            });
      } else {
        _shoppingList = {};
        _weeklyMenuViewModel.removeListener(
          _weeklyMenuViewModelListener!,
        ); // Removed ?
        notifyListeners();
      }
    });
  }

  // Generate and save shopping list to Firestore
  Future<void> _generateAndSaveShoppingList() async {
    final userId =
        _authRepository.currentUser?.uid; // Use _authRepository.currentUser
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      return;
    }

    if (_weeklyMenuViewModel.weeklyMenu == null || // Removed ?
        _weeklyMenuViewModel.weeklyMenu!.menuItems.isEmpty) {
      // Removed ?
      _shoppingList = {};
      await _shoppingListRepository.clearShoppingList(
        userId,
      ); // Clear existing list
      notifyListeners();
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      final List<RecipeModel> allRecipes = await _recipeRepository
          .getRecipesForUser(userId)
          .first;
      final Map<String, List<ShoppingListItemModel>> generatedList =
          _shoppingListService.generateShoppingList(
            weeklyMenu: _weeklyMenuViewModel.weeklyMenu!,
            allRecipes: allRecipes,
          );
      // Save the newly generated list to Firestore, preserving isChecked status if possible
      // For now, assume a fresh list always
      await _shoppingListRepository.saveShoppingList(userId, generatedList);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void toggleItemChecked(String day, String itemId, bool? isChecked) async {
    final userId =
        _authRepository.currentUser?.uid; // Use _authRepository.currentUser
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      return;
    }

    final listForDay = _shoppingList[day];
    if (listForDay != null) {
      final itemIndex = listForDay.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final updatedItem = listForDay[itemIndex].copyWith(
          isChecked: isChecked ?? false,
        );
        _shoppingList[day]![itemIndex] = updatedItem;
        notifyListeners(); // Optimistic update

        try {
          await _shoppingListRepository.updateShoppingListItem(
            userId,
            itemId,
            isChecked ?? false,
          );
        } catch (e) {
          _setErrorMessage('Failed to update shopping list item: $e');
          // Revert optimistic update if update fails
          _shoppingList[day]![itemIndex] = listForDay[itemIndex];
          notifyListeners();
        }
      }
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
    _shoppingListSubscription?.cancel();
    if (_weeklyMenuViewModelListener != null) {
      _weeklyMenuViewModel.removeListener(_weeklyMenuViewModelListener!);
    }
    super.dispose();
  }
}
