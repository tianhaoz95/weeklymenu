import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  Future<void> updateUserSettings(
    String userId, {
    List<String>? enabledDays,
    List<String>? enabledMeals,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (enabledDays != null) {
        updates['enabledDays'] = enabledDays;
      }
      if (enabledMeals != null) {
        updates['enabledMeals'] = enabledMeals;
      }
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Error updating user settings: $e');
    }
  }

  Stream<UserModel?> streamUser(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    });
  }
}
