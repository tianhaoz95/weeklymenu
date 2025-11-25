import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:weeklymenu/data/models/meal_type_model.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart';

void main() {
  late MealTypeRepository mealTypeRepository;
  late FakeFirebaseFirestore fakeFirestore;

  const String testUserId = 'testUserId';
  final MealTypeModel testMealType = MealTypeModel(
    id: '1',
    name: 'Breakfast',
    userId: testUserId,
  );
  final MealTypeModel testMealType2 = MealTypeModel(
    id: '2',
    name: 'Lunch',
    userId: testUserId,
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mealTypeRepository = MealTypeRepository(firestore: fakeFirestore);
  });

  group('MealTypeRepository', () {
    test('addMealType adds a meal type to Firestore', () async {
      await mealTypeRepository.addMealType(testUserId, testMealType);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType.id)
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data(), testMealType.toJson());
    });

    test('getMealTypes returns a stream of meal types', () async {
      // Add some meal types to the fake Firestore
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType.id)
          .set(testMealType.toJson());
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType2.id)
          .set(testMealType2.toJson());

      final resultStream = mealTypeRepository.getMealTypes(testUserId);

      expect(resultStream, emits([testMealType, testMealType2]));
    });

    test('deleteMealType deletes a meal type from Firestore', () async {
      // Add a meal type to delete
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType.id)
          .set(testMealType.toJson());

      // Ensure it exists before deletion
      var doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType.id)
          .get();
      expect(doc.exists, isTrue);

      await mealTypeRepository.deleteMealType(testUserId, testMealType.id);

      // Ensure it does not exist after deletion
      doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('mealTypes')
          .doc(testMealType.id)
          .get();
      expect(doc.exists, isFalse);
    });
  });
}
