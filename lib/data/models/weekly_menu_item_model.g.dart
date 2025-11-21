// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyMenuItemModel _$WeeklyMenuItemModelFromJson(Map<String, dynamic> json) =>
    WeeklyMenuItemModel(
      day: json['day'] as String,
      mealType: json['meal_type'] as String,
      recipeId: json['recipe_id'] as String,
      recipeName: json['recipe_name'] as String,
    );

Map<String, dynamic> _$WeeklyMenuItemModelToJson(
  WeeklyMenuItemModel instance,
) => <String, dynamic>{
  'day': instance.day,
  'meal_type': instance.mealType,
  'recipe_id': instance.recipeId,
  'recipe_name': instance.recipeName,
};
