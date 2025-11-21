import 'package:json_annotation/json_annotation.dart';

part 'weekly_menu_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class WeeklyMenuItemModel {
  final String day; // e.g., "monday"
  final String mealType; // e.g., "breakfast", "lunch", "dinner", "snack"
  final String recipeId;
  final String recipeName;

  WeeklyMenuItemModel({
    required this.day,
    required this.mealType,
    required this.recipeId,
    required this.recipeName,
  });

  factory WeeklyMenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyMenuItemModelToJson(this);
}
