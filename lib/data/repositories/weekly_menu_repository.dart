import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';

class WeeklyMenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateWeeklyMenu(WeeklyMenuModel weeklyMenu) async {
    try {
      await _firestore
          .collection('weekly_menus')
          .doc(weeklyMenu.id)
          .set(weeklyMenu.toJson());
    } catch (e) {
      throw Exception('Error creating or updating weekly menu: $e');
    }
  }

  Future<WeeklyMenuModel?> getWeeklyMenu(String userId) async {
    try {
      final doc = await _firestore.collection('weekly_menus').doc(userId).get();
      if (doc.exists) {
        return WeeklyMenuModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting weekly menu: $e');
    }
  }

  Stream<WeeklyMenuModel?> streamWeeklyMenu(String userId) {
    return _firestore.collection('weekly_menus').doc(userId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return WeeklyMenuModel.fromDocumentSnapshot(doc);
      }
      return null;
    });
  }

  Future<void> deleteWeeklyMenu(String userId) async {
    try {
      await _firestore.collection('weekly_menus').doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting weekly menu: $e');
    }
  }
}
