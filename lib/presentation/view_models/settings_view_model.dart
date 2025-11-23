import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart'; // Import MealTypeRepository
import 'package:weeklymenu/data/models/meal_type_model.dart'; // Import MealTypeModel
import 'package:uuid/uuid.dart'; // Import Uuid for new meal types
import 'dart:async';
import 'dart:developer'; // For logging

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final MealTypeRepository _mealTypeRepository; // Add MealTypeRepository
  final FirebaseAuth _auth; // Add FirebaseAuth as a dependency
  final Uuid _uuid; // Add Uuid for generating IDs for new meal types

  SettingsViewModel({
    SettingsRepository? settingsRepository,
    MealTypeRepository? mealTypeRepository, // Accept MealTypeRepository
    FirebaseAuth? firebaseAuth, // Accept FirebaseAuth
    Uuid? uuid, // Accept Uuid
  }) : _settingsRepository = settingsRepository ?? SettingsRepository(),
       _mealTypeRepository =
           mealTypeRepository ?? MealTypeRepository(), // Initialize
       _auth = firebaseAuth ?? FirebaseAuth.instance, // Initialize FirebaseAuth
       _uuid = uuid ?? const Uuid(); // Initialize Uuid

  SettingsModel? _currentSettings;
  SettingsModel? get currentSettings => _currentSettings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<SettingsModel?>? _settingsSubscription;

  // Stream of meal types
  Stream<List<MealTypeModel>> get mealTypes {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]); // Return an empty stream if no user
    }
    return _mealTypeRepository.getMealTypes(userId);
  }

  // Listen to user changes and then settings changes
  void initialize() {
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _settingsSubscription?.cancel(); // Cancel previous subscription
      if (user != null) {
        // Stream settings for the logged-in user
        _settingsSubscription = _settingsRepository
            .getSettings(user.uid)
            .listen((settings) {
              _currentSettings = settings;
              notifyListeners();
            });
      } else {
        _currentSettings = null;
        notifyListeners();
      }
    });
  }

  Future<void> addMealType(String name) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      log('Error: User not logged in when trying to add meal type.');
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      final newMealType = MealTypeModel(
        id: _uuid.v4(),
        name: name,
        userId: userId,
      );
      await _mealTypeRepository.addMealType(userId, newMealType);
      log('Meal type "$name" added successfully.');
    } catch (e) {
      _setErrorMessage('Failed to add meal type: $e');
      log('Error adding meal type: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteMealType(String mealTypeId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      log('Error: User not logged in when trying to delete meal type.');
      return;
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      await _mealTypeRepository.deleteMealType(userId, mealTypeId);
      log('Meal type with ID "$mealTypeId" deleted successfully.');
    } catch (e) {
      _setErrorMessage('Failed to delete meal type: $e');
      log('Error deleting meal type: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateIncludedWeekdays(List<String> weekdays) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      log('Error: User not logged in when trying to update included weekdays.');
      return;
    }
    if (_currentSettings == null) {
      // If settings don't exist, create default ones
      _currentSettings = SettingsModel(id: userId, includedWeekdays: weekdays);
    } else {
      _currentSettings = _currentSettings!.copyWith(includedWeekdays: weekdays);
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      await _settingsRepository.saveSettings(userId, _currentSettings!);
      log('Included weekdays updated successfully.');
    } catch (e) {
      _setErrorMessage('Failed to update included weekdays: $e');
      log('Error updating included weekdays: $e');
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
    _settingsSubscription?.cancel();
    super.dispose();
  }
}
