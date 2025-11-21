import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class RecipeModel {
  final String id; // Firestore document ID
  final String name;
  final List<String> ingredients;
  final String style; // e.g., "daily", "gourmet", "quick"
  final List<String> type; // e.g., ["breakfast", "lunch", "dinner", "snack"]
  final int rating; // 1-5 stars

  RecipeModel({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.style,
    required this.type,
    required this.rating,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  // Helper for creating a new recipe with default values
  factory RecipeModel.newRecipe({required String name}) {
    return RecipeModel(
      id: '', // Will be set by Firestore
      name: name,
      ingredients: [],
      style: 'daily',
      type: [],
      rating: 1,
    );
  }
}
