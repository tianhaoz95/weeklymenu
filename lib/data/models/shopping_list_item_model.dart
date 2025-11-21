import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ShoppingListItemModel {
  final String name;
  final String unit; // e.g., 'kg', 'g', 'ml', 'unit', 'cup'
  final double quantity;
  final bool isChecked;

  ShoppingListItemModel({
    required this.name,
    required this.unit,
    required this.quantity,
    this.isChecked = false,
  });

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingListItemModelToJson(this);

  ShoppingListItemModel copyWith({
    String? name,
    String? unit,
    double? quantity,
    bool? isChecked,
  }) {
    return ShoppingListItemModel(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
