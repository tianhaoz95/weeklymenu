// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListItemModel _$ShoppingListItemModelFromJson(
  Map<String, dynamic> json,
) => ShoppingListItemModel(
  name: json['name'] as String,
  unit: json['unit'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  isChecked: json['is_checked'] as bool? ?? false,
);

Map<String, dynamic> _$ShoppingListItemModelToJson(
  ShoppingListItemModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'unit': instance.unit,
  'quantity': instance.quantity,
  'is_checked': instance.isChecked,
};
