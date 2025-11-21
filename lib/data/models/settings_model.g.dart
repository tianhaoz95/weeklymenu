// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      id: json['id'] as String?,
      includedMeals:
          (json['included_meals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['breakfast', 'lunch', 'dinner', 'snack'],
      includedWeekdays:
          (json['included_weekdays'] as List<dynamic>?)
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
      'id': instance.id,
      'included_meals': instance.includedMeals,
      'included_weekdays': instance.includedWeekdays,
    };
