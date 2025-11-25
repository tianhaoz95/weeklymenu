import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/user_model.dart';
import 'package:weeklymenu/data/models/meal_type_model.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart';
import 'package:uuid/uuid.dart'; // Import Uuid for generating unique IDs

class UserRepository {
  final FirebaseFirestore _firestore;
  final MealTypeRepository _mealTypeRepository;
  final Uuid _uuid;

  UserRepository({
    FirebaseFirestore? firestore,
    MealTypeRepository? mealTypeRepository,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _mealTypeRepository = mealTypeRepository ?? MealTypeRepository(),
       _uuid = uuid ?? const Uuid();

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());

      // Provision default meal types
      final defaultMealTypes = [
        MealTypeModel(id: _uuid.v4(), name: 'Breakfast', userId: user.id),
        MealTypeModel(id: _uuid.v4(), name: 'Lunch', userId: user.id),
        MealTypeModel(id: _uuid.v4(), name: 'Dinner', userId: user.id),
      ];

      for (var mealType in defaultMealTypes) {
        await _mealTypeRepository.addMealType(user.id, mealType);
      }
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
      // Note: enabledMeals is no longer part of SettingsModel,
      // so this will be removed in a later phase.
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
