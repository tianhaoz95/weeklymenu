// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListItemModel _$ShoppingListItemModelFromJson(
  Map<String, dynamic> json,
) => ShoppingListItemModel(
  name: json['name'] as String,
  isChecked: json['is_checked'] as bool? ?? false,
  fromDay: json['from_day'] as String?,
);

Map<String, dynamic> _$ShoppingListItemModelToJson(
  ShoppingListItemModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'is_checked': instance.isChecked,
  'from_day': instance.fromDay,
};
