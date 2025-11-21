import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SettingsModel {
  final List<String>
  selectedMeals; // e.g., ["breakfast", "lunch", "dinner", "snack"]
  final List<String> selectedWeekdays; // e.g., ["monday", "tuesday", ...]

  SettingsModel({
    this.selectedMeals = const ['breakfast', 'lunch', 'dinner', 'snack'],
    this.selectedWeekdays = const [
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
}
