import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ShoppingListItemModel {
  final String name;
  final bool isChecked;
  final String? fromDay; // The day this ingredient is needed for, if applicable

  ShoppingListItemModel({
    required this.name,
    this.isChecked = false,
    this.fromDay,
  });

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingListItemModelToJson(this);
}
