import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/user_model.dart';
import 'package:weeklymenu/data/repositories/user_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SettingsViewModel({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository();

  UserModel? _currentUserModel; // Use UserModel to store user settings
  UserModel? get currentUserModel => _currentUserModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Listen to user changes from the repository
  void initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _userRepository.streamUser(user.uid).listen((userModel) {
          _currentUserModel = userModel;
          notifyListeners();
        });
      } else {
        _currentUserModel = null;
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

    _setLoading(true);
    clearErrorMessage();
    try {
      await _userRepository.updateUserSettings(userId, enabledMeals: meals);
      // Optimistically update
      _currentUserModel = _currentUserModel?.copyWith(enabledMeals: meals);
      notifyListeners();
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

    _setLoading(true);
    clearErrorMessage();
    try {
      await _userRepository.updateUserSettings(userId, enabledDays: weekdays);
      // Optimistically update
      _currentUserModel = _currentUserModel?.copyWith(enabledDays: weekdays);
      notifyListeners();
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
