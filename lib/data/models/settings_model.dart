import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'settings_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SettingsModel {
  final String? id; // Corresponds to the user ID
  final List<String> includedMeals; // e.g., ['breakfast', 'lunch']
  final List<String> includedWeekdays; // e.g., ['monday', 'tuesday']

  SettingsModel({
    this.id,
    this.includedMeals = const ['breakfast', 'lunch', 'dinner', 'snack'],
    this.includedWeekdays = const [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ],
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  factory SettingsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SettingsModel.fromJson({...data, 'id': doc.id});
  }

  SettingsModel copyWith({
    String? id,
    List<String>? includedMeals,
    List<String>? includedWeekdays,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      includedMeals: includedMeals ?? this.includedMeals,
      includedWeekdays: includedWeekdays ?? this.includedWeekdays,
    );
  }
}
