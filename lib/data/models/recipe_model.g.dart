// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  imageUrl: json['image_url'] as String?,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  instructions:
      (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  cuisines:
      (json['cuisines'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  servingSize: (json['serving_size'] as num?)?.toInt() ?? 1,
  prepTimeMinutes: (json['prep_time_minutes'] as num?)?.toInt() ?? 0,
  cookTimeMinutes: (json['cook_time_minutes'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'categories': instance.categories,
      'cuisines': instance.cuisines,
      'serving_size': instance.servingSize,
      'prep_time_minutes': instance.prepTimeMinutes,
      'cook_time_minutes': instance.cookTimeMinutes,
      'rating': instance.rating,
      'user_id': instance.userId,
    };
