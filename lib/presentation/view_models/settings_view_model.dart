import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/settings_model.dart'; // Import SettingsModel
import 'package:weeklymenu/data/repositories/settings_repository.dart'; // Import SettingsRepository
import 'dart:async';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository; // Change to SettingsRepository
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SettingsViewModel({SettingsRepository? settingsRepository})
    : _settingsRepository = settingsRepository ?? SettingsRepository();

  SettingsModel? _currentSettings; // Use SettingsModel to store user settings
  SettingsModel? get currentSettings => _currentSettings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<SettingsModel?>? _settingsSubscription;

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

  Future<void> updateIncludedMeals(List<String> meals) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
      return;
    }
    if (_currentSettings == null) {
      // If settings don't exist, create default ones
      _currentSettings = SettingsModel(id: userId, includedMeals: meals);
    } else {
      _currentSettings = _currentSettings!.copyWith(includedMeals: meals);
    }

    _setLoading(true);
    clearErrorMessage();
    try {
      await _settingsRepository.saveSettings(userId, _currentSettings!);
      // Optimistically update and notifyListeners already done above
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateIncludedWeekdays(List<String> weekdays) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _setErrorMessage('User not logged in.');
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
      // Optimistically update and notifyListeners already done above
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
    _settingsSubscription?.cancel();
    super.dispose();
  }
}
