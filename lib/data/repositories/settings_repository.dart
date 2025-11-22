import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/settings_model.dart';

class SettingsRepository {
  final FirebaseFirestore _firestore;

  SettingsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Save user settings to Firestore
  Future<void> saveSettings(String userId, SettingsModel settings) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .set(settings.toJson());
  }

  // Get user settings from Firestore
  Stream<SettingsModel> getSettings(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            return SettingsModel.fromJson(snapshot.data()!);
          }
          return SettingsModel(id: userId); // Default settings if none exist
        });
  }
}
