// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      selectedMeals:
          (json['selected_meals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['breakfast', 'lunch', 'dinner', 'snack'],
      selectedWeekdays:
          (json['selected_weekdays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday',
            'sunday',
          ],
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'selected_meals': instance.selectedMeals,
      'selected_weekdays': instance.selectedWeekdays,
    };
