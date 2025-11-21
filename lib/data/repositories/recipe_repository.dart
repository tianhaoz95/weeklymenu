import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      await _firestore
          .collection('recipes')
          .doc(recipe.id)
          .set(recipe.toJson());
    } catch (e) {
      throw Exception('Error creating recipe: $e');
    }
  }

  Future<RecipeModel?> getRecipe(String recipeId) async {
    try {
      final doc = await _firestore.collection('recipes').doc(recipeId).get();
      if (doc.exists) {
        return RecipeModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting recipe: $e');
    }
  }

  Stream<List<RecipeModel>> getRecipesForUser(String userId) {
    return _firestore
        .collection('recipes')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeModel.fromDocumentSnapshot(doc))
              .toList(),
        );
  }

  Future<void> updateRecipe(RecipeModel recipe) async {
    try {
      await _firestore
          .collection('recipes')
          .doc(recipe.id)
          .update(recipe.toJson());
    } catch (e) {
      throw Exception('Error updating recipe: $e');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception('Error deleting recipe: $e');
    }
  }
}
