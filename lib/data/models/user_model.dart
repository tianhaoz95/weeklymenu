import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final List<String> enabledDays; // e.g., ['monday', 'wednesday']
  final List<String> enabledMeals; // e.g., ['breakfast', 'lunch', 'dinner']

  UserModel({
    required this.id,
    required this.email,
    this.enabledDays = const [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ],
    this.enabledMeals = const ['breakfast', 'lunch', 'dinner', 'snack'],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
  }

  UserModel copyWith({
    String? id,
    String? email,
    List<String>? enabledDays,
    List<String>? enabledMeals,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      enabledDays: enabledDays ?? this.enabledDays,
      enabledMeals: enabledMeals ?? this.enabledMeals,
    );
  }
}
