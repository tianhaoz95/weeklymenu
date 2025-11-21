import 'package:json_annotation/json_annotation.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';

part 'weekly_menu_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class WeeklyMenuModel {
  final List<WeeklyMenuItemModel> meals;

  WeeklyMenuModel({required this.meals});

  factory WeeklyMenuModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyMenuModelToJson(this);

  // Helper to get meals for a specific day and meal type
  List<WeeklyMenuItemModel> getMealsForDayAndType(String day, String mealType) {
    return meals
        .where((item) => item.day == day && item.mealType == mealType)
        .toList();
  }
}
