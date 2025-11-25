import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:weeklymenu/data/models/user_model.dart';
import 'package:weeklymenu/data/repositories/user_repository.dart';
import 'package:weeklymenu/data/repositories/meal_type_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  late UserRepository userRepository;
  late MealTypeRepository mealTypeRepository;
  late FakeFirebaseFirestore fakeFirestore;
  late Uuid uuid;

  const String testUserId = 'testUserId';
  const String testUserEmail = 'test@example.com';
  final UserModel testUser = UserModel(id: testUserId, email: testUserEmail);

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mealTypeRepository = MealTypeRepository(firestore: fakeFirestore);
    uuid = const Uuid(); // Use real Uuid instance
    userRepository = UserRepository(
      firestore: fakeFirestore,
      mealTypeRepository: mealTypeRepository,
      uuid: uuid,
    );
  });

  group('UserRepository', () {
    test(
      'createUser creates a user and provisions default meal types',
      () async {
        await userRepository.createUser(testUser);

        // Verify user is created
        final userDoc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .get();
        expect(userDoc.exists, isTrue);
        expect(userDoc.data(), testUser.toJson());

        // Verify default meal types are provisioned
        final mealTypesSnapshot = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('mealTypes')
            .get();

        expect(mealTypesSnapshot.docs.length, 3);

        final mealTypeNames = mealTypesSnapshot.docs
            .map((doc) => doc.data()['name'])
            .toList();
        expect(mealTypeNames, containsAll(['Breakfast', 'Lunch', 'Dinner']));

        // Ensure that each meal type has a non-empty ID
        for (var doc in mealTypesSnapshot.docs) {
          expect(doc.data()['id'], isNotNull);
          expect(doc.data()['id'], isNotEmpty);
        }
      },
    );

    test('getUser returns a user if exists', () async {
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .set(testUser.toJson());

      final user = await userRepository.getUser(testUserId);
      expect(user, equals(testUser));
    });

    test('getUser returns null if user does not exist', () async {
      final user = await userRepository.getUser('nonExistentUser');
      expect(user, isNull);
    });

    test('updateUserSettings updates user settings', () async {
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .set(testUser.toJson());

      final newEnabledDays = ['monday', 'wednesday'];
      await userRepository.updateUserSettings(
        testUserId,
        enabledDays: newEnabledDays,
      );

      final updatedUserDoc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .get();
      final updatedUser = UserModel.fromDocumentSnapshot(updatedUserDoc);

      expect(updatedUser.id, testUser.id);
      expect(updatedUser.email, testUser.email);
    });

    // test('streamUser returns a stream of user updates', () async {
    //   await fakeFirestore.collection('users').doc(testUserId).set(testUser.toJson());
    //   final updatedUser = UserModel(id: testUserId, email: 'updated@example.com');

    //   final userStream = userRepository.streamUser(testUserId);

    //   // We set up the expectation first, then trigger the event that fulfills it.
    //   // This is crucial for asynchronous testing.
    //   await expectLater(
    //       userStream, emitsInOrder([testUser, updatedUser]));

    //   await fakeFirestore.collection('users').doc(testUserId).set(updatedUser.toJson());
    // });
  });
}
