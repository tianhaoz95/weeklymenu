// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyMenuModel _$WeeklyMenuModelFromJson(Map<String, dynamic> json) =>
    WeeklyMenuModel(
      id: json['id'] as String?,
      menuItems:
          (json['menu_items'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>)
                  .map(
                    (e) =>
                        WeeklyMenuItemModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$WeeklyMenuModelToJson(WeeklyMenuModel instance) =>
    <String, dynamic>{'id': instance.id, 'menu_items': instance.menuItems};
