// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  enabledDays:
      (json['enabledDays'] as List<dynamic>?)
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
  enabledMeals:
      (json['enabledMeals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['breakfast', 'lunch', 'dinner', 'snack'],
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'enabledDays': instance.enabledDays,
  'enabledMeals': instance.enabledMeals,
};
