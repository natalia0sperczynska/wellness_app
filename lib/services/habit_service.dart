import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellness_app/commons.dart';

class HabitService {
  static const String _habitsKey = 'habits';
  static const String _completionsKey = 'habit_completions';

  Future<void> _initializeDefaultHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final existingHabits = prefs.getString(_habitsKey);

    if (existingHabits == null) {
      final now = DateTime.now();
      final defaultHabits = [
        Habit(id: '1', name: 'Morning Meditation', emoji: '🧘', category: 'Mindfulness', createdAt: now, updatedAt: now),
        Habit(id: '2', name: 'Drink Water', emoji: '💧', category: 'Health', createdAt: now, updatedAt: now),
        Habit(id: '3', name: 'Exercise', emoji: '🏃', category: 'Fitness', createdAt: now, updatedAt: now),
        Habit(id: '4', name: 'Read', emoji: '📚', category: 'Learning', createdAt: now, updatedAt: now),
        Habit(id: '5', name: 'Journal', emoji: '✍️', category: 'Reflection', createdAt: now, updatedAt: now),
        Habit(id: '6', name: 'Gratitude Practice', emoji: '🙏', category: 'Mindfulness', createdAt: now, updatedAt: now),
        Habit(id: '7', name: 'Healthy Meal', emoji: '🥗', category: 'Nutrition', createdAt: now, updatedAt: now),
        Habit(id: '8', name: 'Walk Outside', emoji: '🌳', category: 'Nature', createdAt: now, updatedAt: now),
      ];

      final habitsJson = jsonEncode(defaultHabits.map((h) => h.toJson()).toList());
      await prefs.setString(_habitsKey, habitsJson);
    }
  }

  Future<List<Habit>> getAllHabits() async {
    await _initializeDefaultHabits();
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);

    if (habitsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(habitsJson);
    return decoded.map((json) => Habit.fromJson(json)).toList();
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getAllHabits();
    habits.add(habit);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_habitsKey, jsonEncode(habits.map((h) => h.toJson()).toList()));
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await getAllHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_habitsKey, jsonEncode(habits.map((h) => h.toJson()).toList()));
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getAllHabits();
    habits.removeWhere((h) => h.id == habitId);

    final completions = await getCompletions();
    completions.removeWhere((c) => c.habitId == habitId);

    await prefs.setString(
      _habitsKey,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
    await prefs.setString(
      _completionsKey,
      jsonEncode(completions.map((c) => c.toJson()).toList()),
    );
  }

  Future<List<HabitCompletion>> getCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    final completionsJson = prefs.getString(_completionsKey);

    if (completionsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(completionsJson);
    return decoded.map((json) => HabitCompletion.fromJson(json)).toList();
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final completions = await getCompletions();
    final dateOnly = DateTime(date.year, date.month, date.day);

    final existingIndex = completions.indexWhere((c) =>
    c.habitId == habitId &&
        c.completedAt.year == dateOnly.year &&
        c.completedAt.month == dateOnly.month &&
        c.completedAt.day == dateOnly.day
    );

    if (existingIndex != -1) {
      completions.removeAt(existingIndex);
    } else {
      final now = DateTime.now();
      completions.add(HabitCompletion(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        habitId: habitId,
        completedAt: dateOnly,
        createdAt: now,
        updatedAt: now,
      ));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_completionsKey, jsonEncode(completions.map((c) => c.toJson()).toList()));
  }

  Future<bool> isHabitCompletedToday(String habitId) async {
    final completions = await getCompletions();
    final today = DateTime.now();

    return completions.any((c) =>
    c.habitId == habitId &&
        c.completedAt.year == today.year &&
        c.completedAt.month == today.month &&
        c.completedAt.day == today.day
    );
  }

  Future<int> getStreakForHabit(String habitId) async {
    final completions = await getCompletions();
    final habitCompletions = completions
        .where((c) => c.habitId == habitId)
        .map((c) => DateTime(c.completedAt.year, c.completedAt.month, c.completedAt.day))
        .toSet()
        .toList()..sort((a, b) => b.compareTo(a));

    if (habitCompletions.isEmpty) return 0;

    int streak = 0;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    DateTime checkDate = todayDate;
    for (final completionDate in habitCompletions) {
      if (completionDate.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (completionDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }
}
