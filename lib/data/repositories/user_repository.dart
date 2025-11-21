import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Get current user's UID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  // Create or update user profile in Firestore
  Future<void> createUserProfile(UserModel user) async {
    if (currentUserId == null) return;
    await _firestore.collection('users').doc(currentUserId).set(user.toJson());
  }

  // Fetch user profile
  Stream<UserModel?> getUserProfile() {
    if (currentUserId == null) return Stream.value(null);
    return _firestore.collection('users').doc(currentUserId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // Update user profile fields (e.g., displayName)
  Future<void> updateUserProfile({String? displayName}) async {
    if (currentUserId == null) return;
    await _firestore.collection('users').doc(currentUserId).update({
      if (displayName != null) 'display_name': displayName,
    });
  }

  // --- Settings specific operations ---

  // Fetch user settings
  Stream<SettingsModel?> getUserSettings() {
    if (currentUserId == null) return Stream.value(null);
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('profile') // Use 'profile' subcollection for settings
        .doc('settings') // Use a fixed document ID for settings
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return SettingsModel.fromJson(doc.data()!);
          }
          // Return default settings if document doesn't exist
          return SettingsModel();
        });
  }

  // Update user settings
  Future<void> updateUserSettings(SettingsModel settings) async {
    if (currentUserId == null) return;
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('profile')
        .doc('settings')
        .set(settings.toJson());
  }
}
