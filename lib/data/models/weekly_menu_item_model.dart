import 'package:json_annotation/json_annotation.dart';

part 'weekly_menu_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WeeklyMenuItemModel {
  final String? recipeId;
  final String recipeName;
  final String mealType; // e.g., 'breakfast', 'lunch', 'dinner', 'snack'

  WeeklyMenuItemModel({
    this.recipeId,
    required this.recipeName,
    required this.mealType,
  });

  factory WeeklyMenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyMenuItemModelToJson(this);

  WeeklyMenuItemModel copyWith({
    String? recipeId,
    String? recipeName,
    String? mealType,
  }) {
    return WeeklyMenuItemModel(
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      mealType: mealType ?? this.mealType,
    );
  }
}
