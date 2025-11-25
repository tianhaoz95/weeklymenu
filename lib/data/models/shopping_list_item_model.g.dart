// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListItemModel _$ShoppingListItemModelFromJson(
  Map<String, dynamic> json,
) => ShoppingListItemModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  unit: json['unit'] as String? ?? 'item',
  isChecked: json['is_checked'] as bool? ?? false,
  dailyMenuId: json['daily_menu_id'] as String,
  recipeName: json['recipe_name'] as String?,
);

Map<String, dynamic> _$ShoppingListItemModelToJson(
  ShoppingListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'is_checked': instance.isChecked,
  'daily_menu_id': instance.dailyMenuId,
  'recipe_name': instance.recipeName,
};
