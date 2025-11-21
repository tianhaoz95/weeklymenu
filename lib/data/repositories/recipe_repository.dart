import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeRepository({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _recipesCollection {
    if (currentUserId == null) {
      throw Exception('User not logged in.');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('cookbook');
  }

  // Add a new recipe
  Future<void> addRecipe(RecipeModel recipe) async {
    final docRef = await _recipesCollection.add(recipe.toJson());
    // Update the recipe with the generated ID
    await docRef.update({'id': docRef.id});
  }

  // Get all recipes for the current user
  Stream<List<RecipeModel>> getRecipes() {
    return _recipesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Get a single recipe by ID
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    final doc = await _recipesCollection.doc(recipeId).get();
    if (doc.exists) {
      return RecipeModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update an existing recipe
  Future<void> updateRecipe(RecipeModel recipe) async {
    await _recipesCollection.doc(recipe.id).update(recipe.toJson());
  }

  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    await _recipesCollection.doc(recipeId).delete();
  }
}
