import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'shopping_list_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ShoppingListItemModel {
  final String id; // Unique ID for the item
  final String name;
  final int quantity; // Changed from double to int
  final String unit; // e.g., 'kg', 'g', 'ml', 'unit', 'cup'. Default "item".
  final bool isChecked;
  final String dailyMenuId; // ID of the WeeklyMenuItemModel it came from
  final String? recipeName; // Added for display in shopping list

  ShoppingListItemModel({
    String? id,
    required this.name,
    this.quantity = 1, // Default quantity to 1
    this.unit = 'item', // Default unit to 'item'
    this.isChecked = false,
    required this.dailyMenuId,
    this.recipeName,
  }) : id = id ?? const Uuid().v4();

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingListItemModelToJson(this);

  ShoppingListItemModel copyWith({
    String? id,
    String? name,
    int? quantity,
    String? unit,
    bool? isChecked,
    String? dailyMenuId,
  }) {
    return ShoppingListItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      dailyMenuId: dailyMenuId ?? this.dailyMenuId,
    );
  }
}
