import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:weeklymenu/data/models/settings_model.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart';

void main() {
  late SettingsRepository settingsRepository;
  late FakeFirebaseFirestore fakeFirestore;

  const String testUserId = 'testUserId';
  final SettingsModel defaultTestSettings = SettingsModel(id: testUserId);
  final SettingsModel customTestSettings = SettingsModel(
    id: testUserId,
    includedWeekdays: ['monday', 'wednesday', 'friday'],
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    settingsRepository = SettingsRepository(firestore: fakeFirestore);
  });

  group('SettingsRepository', () {
    test('saveSettings saves settings to Firestore', () async {
      await settingsRepository.saveSettings(testUserId, customTestSettings);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('preferences')
          .doc('settings')
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data(), customTestSettings.toJson());
    });

    test('getSettings returns a stream of settings', () async {
      // Set initial settings in Firestore
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('preferences')
          .doc('settings')
          .set(customTestSettings.toJson());

      final resultStream = settingsRepository.getSettings(testUserId);

      expect(resultStream, emits(customTestSettings));
    });

    test('getSettings returns default settings if none exist', () async {
      final resultStream = settingsRepository.getSettings(testUserId);

      expect(resultStream, emits(defaultTestSettings));
    });
  });
}
