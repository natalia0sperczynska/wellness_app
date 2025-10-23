import 'package:wellness_app/commons.dart';
class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HabitCompletion.fromFirestore(Map<String, dynamic> data, String documentId) {
    return HabitCompletion(
      id: documentId,
      habitId: data['habitId'] as String? ?? '',
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'completedAt': Timestamp.fromDate(completedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HabitCompletion(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    completedAt: completedAt ?? this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
