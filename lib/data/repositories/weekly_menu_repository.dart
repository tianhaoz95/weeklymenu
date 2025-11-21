import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';

class WeeklyMenuRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  WeeklyMenuRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> get _weeklyMenuDoc {
    if (currentUserId == null) {
      throw Exception('User not logged in.');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('weeklyMenu')
        .doc('currentMenu');
  }

  // Save the current weekly menu
  Future<void> saveWeeklyMenu(WeeklyMenuModel weeklyMenu) async {
    await _weeklyMenuDoc.set(weeklyMenu.toJson());
  }

  // Get the current weekly menu
  Stream<WeeklyMenuModel?> getWeeklyMenu() {
    return _weeklyMenuDoc.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return WeeklyMenuModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  // Delete the current weekly menu
  Future<void> deleteWeeklyMenu() async {
    await _weeklyMenuDoc.delete();
  }
}
