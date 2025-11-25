import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser; // Add this getter

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Re-throw for ViewModel to handle specific exceptions
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> deleteAccount({required String password}) async {
    try {
      // Re-authenticate user before deleting, if not recently authenticated
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, // Assuming email/password user
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}

// Custom Exception class for authentication errors
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  factory AuthException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthException('The email address is not valid.');
      case 'user-disabled':
        return AuthException('The user has been disabled.');
      case 'user-not-found':
        return AuthException('No user found for that email.');
      case 'wrong-password':
        return AuthException('Wrong password provided for that user.');
      case 'email-already-in-use':
        return AuthException(
          'The email address is already in use by another account.',
        );
      case 'operation-not-allowed':
        return AuthException('Email & Password accounts are not enabled.');
      case 'weak-password':
        return AuthException('The password provided is too weak.');
      case 'requires-recent-login':
        return AuthException(
          'This operation is sensitive and requires recent authentication. Please log in again.',
        );
      default:
        return AuthException(
          'An unknown authentication error occurred. ($code)',
        );
    }
  }

  @override
  String toString() => 'AuthException: $message';
}
