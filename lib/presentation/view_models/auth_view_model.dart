import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final GoRouter? _router; // Add GoRouter instance

  AuthViewModel({AuthRepository? authRepository, GoRouter? router})
    : _authRepository = authRepository ?? AuthRepository(),
      _router = router; // Initialize GoRouter

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _authRepository.userChanges;

  // Initialize and listen to auth state
  void initialize() {
    authStateChanges.listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _authRepository.signIn(email: email, password: password);
      _router?.refresh(); // Refresh GoRouter on successful sign-in
    } on AuthException catch (e) {
      _setErrorMessage(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _authRepository.signUp(email: email, password: password);
      _router?.refresh(); // Refresh GoRouter on successful sign-up
    } on AuthException catch (e) {
      _setErrorMessage(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _authRepository.signOut();
      _router?.refresh(); // Refresh GoRouter on successful sign-out
    } on AuthException catch (e) {
      _setErrorMessage(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword({required String email}) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _authRepository.resetPassword(email: email);
    } on AuthException catch (e) {
      _setErrorMessage(e.message);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount({required String password}) async {
    _setLoading(true);
    clearErrorMessage();
    try {
      await _authRepository.deleteAccount(password: password);
    } on AuthException catch (e) {
      _setErrorMessage(e.message);
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
