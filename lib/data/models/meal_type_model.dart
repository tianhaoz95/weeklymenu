import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'meal_type_model.g.dart';

@JsonSerializable()
class MealTypeModel extends Equatable {
  final String id;
  final String name;
  final String userId;

  MealTypeModel({required this.id, required this.name, required this.userId});

  factory MealTypeModel.fromJson(Map<String, dynamic> json) =>
      _$MealTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealTypeModelToJson(this);

  @override
  List<Object?> get props => [id, name, userId];
}
