import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_list_item_model.dart';
// Import UserModel for userId

class ShoppingListRepository {
  final FirebaseFirestore _firestore;

  ShoppingListRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference for shopping lists
  CollectionReference<Map<String, dynamic>> _shoppingListCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('shoppingLists');
  }

  // Save/Update the entire daily-grouped shopping list to Firestore
  Future<void> saveShoppingList(
    String userId,
    Map<String, List<ShoppingListItemModel>> shoppingList,
  ) async {
    final batch = _firestore.batch();
    final collection = _shoppingListCollection(userId);

    // First, clear existing shopping list items for this user/menu
    // This is a simplified approach, a more robust solution might track menu versions
    // For now, it assumes a full replacement on each save.
    final existingDocs = await collection.get();
    for (var doc in existingDocs.docs) {
      batch.delete(doc.reference);
    }

    // Add new items
    shoppingList.forEach((day, items) {
      for (var item in items) {
        batch.set(collection.doc(item.id), item.toJson());
      }
    });

    await batch.commit();
  }

  // Streams the user's shopping list from Firestore
  Stream<Map<String, List<ShoppingListItemModel>>> getShoppingList(
    String userId,
  ) {
    return _shoppingListCollection(userId).snapshots().map((snapshot) {
      final Map<String, List<ShoppingListItemModel>> groupedList = {};
      for (var doc in snapshot.docs) {
        final item = ShoppingListItemModel.fromJson(doc.data());
        groupedList.update(
          item.dailyMenuId, // Assuming dailyMenuId acts as the day group for now
          (value) => [...value, item],
          ifAbsent: () => [item],
        );
      }
      return groupedList;
    });
  }

  // Update the checked status of a single shopping list item
  Future<void> updateShoppingListItem(
    String userId,
    String itemId,
    bool isChecked,
  ) async {
    await _shoppingListCollection(
      userId,
    ).doc(itemId).update({'is_checked': isChecked});
  }

  // Delete a specific shopping list item
  Future<void> deleteShoppingListItem(String userId, String itemId) async {
    await _shoppingListCollection(userId).doc(itemId).delete();
  }

  // Clear all shopping list items for a user
  Future<void> clearShoppingList(String userId) async {
    final batch = _firestore.batch();
    final existingDocs = await _shoppingListCollection(userId).get();
    for (var doc in existingDocs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
