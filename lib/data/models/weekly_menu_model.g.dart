// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyMenuModel _$WeeklyMenuModelFromJson(Map<String, dynamic> json) =>
    WeeklyMenuModel(
      meals: (json['meals'] as List<dynamic>)
          .map((e) => WeeklyMenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyMenuModelToJson(WeeklyMenuModel instance) =>
    <String, dynamic>{'meals': instance.meals.map((e) => e.toJson()).toList()};
