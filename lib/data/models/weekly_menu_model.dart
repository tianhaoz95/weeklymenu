import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeklymenu/data/models/weekly_menu_item_model.dart';

part 'weekly_menu_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WeeklyMenuModel {
  final String? id; // Corresponds to the user ID
  final Map<String, List<WeeklyMenuItemModel>>
  menuItems; // Map of weekday to list of menu items

  WeeklyMenuModel({this.id, this.menuItems = const {}});

  factory WeeklyMenuModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMenuModelFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menu_items'] = menuItems.map((key, value) =>
        MapEntry(key, value.map((item) => item.toJson()).toList()));
    return data;
  }

  factory WeeklyMenuModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WeeklyMenuModel.fromJson({...data, 'id': doc.id});
  }

  WeeklyMenuModel copyWith({
    String? id,
    Map<String, List<WeeklyMenuItemModel>>? menuItems,
  }) {
    return WeeklyMenuModel(
      id: id ?? this.id,
      menuItems: menuItems ?? this.menuItems,
    );
  }
}
