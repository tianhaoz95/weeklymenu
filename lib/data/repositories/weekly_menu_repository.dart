import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/weekly_menu_model.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';

class WeeklyMenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper to get the base collection for a user's weekly menu
  CollectionReference _weeklyMenuCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('weekly');
  }

  // Helper to delete all day documents for a user's weekly menu
  Future<void> _deleteAllDayMenus(String userId) async {
    final snapshot = await _weeklyMenuCollection(userId).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Helper to serialize List<WeeklyMenuItemModel> to a Firestore document data
  Map<String, dynamic> _serializeDayMenu(List<WeeklyMenuItemModel> items) {
    return {'items': items.map((item) => item.toJson()).toList()};
  }

  // Helper to deserialize Firestore document data to List<WeeklyMenuItemModel>
  List<WeeklyMenuItemModel> _deserializeDayMenu(Map<String, dynamic> data) {
    if (data['items'] is! List) return [];
    return (data['items'] as List)
        .map((itemJson) => WeeklyMenuItemModel.fromJson(itemJson))
        .toList();
  }

  Future<void> createOrUpdateWeeklyMenu(
    String userId,
    Map<String, List<WeeklyMenuItemModel>> weeklyMenuMap,
  ) async {
    try {
      // First, delete all existing day menus for the user
      await _deleteAllDayMenus(userId);

      // Then, write each day's menu as a separate document
      for (var dayEntry in weeklyMenuMap.entries) {
        final day = dayEntry.key;
        final menuItems = dayEntry.value;
        if (menuItems.isNotEmpty) {
          await _weeklyMenuCollection(
            userId,
          ).doc(day).set(_serializeDayMenu(menuItems));
        }
      }
    } catch (e) {
      throw Exception('Error creating or updating weekly menu: $e');
    }
  }

  // Retrieves the entire weekly menu for a user
  Future<WeeklyMenuModel?> getWeeklyMenu(String userId) async {
    try {
      final snapshot = await _weeklyMenuCollection(userId).get();
      final Map<String, List<WeeklyMenuItemModel>> menuItemsMap = {};

      for (var doc in snapshot.docs) {
        if (doc.exists && doc.data() != null) {
          menuItemsMap[doc.id] = _deserializeDayMenu(
            doc.data() as Map<String, dynamic>,
          );
        }
      }
      return WeeklyMenuModel(id: userId, menuItems: menuItemsMap);
    } catch (e) {
      throw Exception('Error getting weekly menu: $e');
    }
  }

  // Streams the entire weekly menu for a user
  Stream<WeeklyMenuModel?> streamWeeklyMenu(String userId) {
    return _weeklyMenuCollection(userId).snapshots().map((snapshot) {
      final Map<String, List<WeeklyMenuItemModel>> menuItemsMap = {};
      for (var doc in snapshot.docs) {
        if (doc.exists && doc.data() != null) {
          menuItemsMap[doc.id] = _deserializeDayMenu(
            doc.data() as Map<String, dynamic>,
          );
        }
      }
      return WeeklyMenuModel(id: userId, menuItems: menuItemsMap);
    });
  }

  Future<void> deleteWeeklyMenu(String userId) async {
    try {
      await _deleteAllDayMenus(userId);
    } catch (e) {
      throw Exception('Error deleting weekly menu: $e');
    }
  }
}
