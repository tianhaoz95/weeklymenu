import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/meal_type_model.dart';

class MealTypeRepository {
  final FirebaseFirestore _firestore;

  MealTypeRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference for meal types
  CollectionReference<MealTypeModel> _mealTypeCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('mealTypes')
        .withConverter<MealTypeModel>(
          fromFirestore: (snapshot, _) =>
              MealTypeModel.fromJson(snapshot.data()!),
          toFirestore: (mealType, _) => mealType.toJson(),
        );
  }

  // Add a new meal type
  Future<void> addMealType(String userId, MealTypeModel mealType) async {
    await _mealTypeCollection(userId).doc(mealType.id).set(mealType);
  }

  // Get a stream of meal types for a user
  Stream<List<MealTypeModel>> getMealTypes(String userId) {
    return _mealTypeCollection(userId).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  // Delete a meal type
  Future<void> deleteMealType(String userId, String mealTypeId) async {
    await _mealTypeCollection(userId).doc(mealTypeId).delete();
  }
}
