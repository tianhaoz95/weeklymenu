import 'package:flutter/material.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/repositories/user_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  SettingsViewModel({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository();

  SettingsModel _settings = SettingsModel();
  SettingsModel get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Listen to settings changes from the repository
  void initialize() {
    _userRepository.getUserSettings().listen((settingsData) {
      if (settingsData != null) {
        _settings = settingsData;
        notifyListeners();
      }
    });
  }

  Future<void> updateSelectedMeals(List<String> meals) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      final updatedSettings = SettingsModel(
        selectedMeals: meals,
        selectedWeekdays: _settings.selectedWeekdays,
      );
      await _userRepository.updateUserSettings(updatedSettings);
      _settings = updatedSettings; // Optimistically update
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSelectedWeekdays(List<String> weekdays) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      final updatedSettings = SettingsModel(
        selectedMeals: _settings.selectedMeals,
        selectedWeekdays: weekdays,
      );
      await _userRepository.updateUserSettings(updatedSettings);
      _settings = updatedSettings; // Optimistically update
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
