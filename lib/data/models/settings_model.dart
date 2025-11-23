import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'settings_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SettingsModel extends Equatable {
  final String? id; // Corresponds to the user ID
  final List<String> includedWeekdays; // e.g., ['monday', 'tuesday']

  const SettingsModel({
    this.id,
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

  SettingsModel copyWith({String? id, List<String>? includedWeekdays}) {
    return SettingsModel(
      id: id ?? this.id,
      includedWeekdays: includedWeekdays ?? this.includedWeekdays,
    );
  }

  @override
  List<Object?> get props => [id, includedWeekdays];
}
