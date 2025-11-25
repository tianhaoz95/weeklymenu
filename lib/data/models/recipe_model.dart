import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'recipe_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeModel {
  final String? id;
  final String name;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> categories; // e.g., 'main_course', 'dessert', 'breakfast'
  final List<String> cuisines; // e.g., 'italian', 'mexican', 'indian'
  final int servingSize;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final double rating; // 1.0 to 5.0
  final String userId;

  RecipeModel({
    this.id,
    required this.name,
    this.imageUrl,
    this.ingredients = const [],
    this.instructions = const [],
    this.categories = const [],
    this.cuisines = const [],
    this.servingSize = 1,
    this.prepTimeMinutes = 0,
    this.cookTimeMinutes = 0,
    this.rating = 0.0,
    required this.userId,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  factory RecipeModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel.fromJson({...data, 'id': doc.id});
  }

  // Helper to create a new recipe with a generated ID
  factory RecipeModel.newRecipe({required String name, String? userId}) {
    return RecipeModel(
      id: FirebaseFirestore.instance
          .collection('recipes')
          .doc()
          .id, // Generate a new ID
      name: name,
      userId: userId ?? '', // Assign a default or throw if user ID is critical
    );
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? instructions,
    List<String>? categories,
    List<String>? cuisines,
    int? servingSize,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    double? rating,
    String? userId,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      categories: categories ?? this.categories,
      cuisines: cuisines ?? this.cuisines,
      servingSize: servingSize ?? this.servingSize,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      rating: rating ?? this.rating,
      userId: userId ?? this.userId,
    );
  }
}
