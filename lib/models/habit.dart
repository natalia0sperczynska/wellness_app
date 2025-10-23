import 'package:wellness_app/commons.dart';
class Habit {
  final String id;
  final String name;
  final String emoji;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Habit.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Habit(
      id: documentId,
      name: data['name'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '',
      category: data['category'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'emoji': emoji,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    String? emoji,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
