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

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'completedAt': completedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory HabitCompletion.fromJson(Map<String, dynamic> json) => HabitCompletion(
    id: json['id'] as String,
    habitId: json['habitId'] as String,
    completedAt: DateTime.parse(json['completedAt'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

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
