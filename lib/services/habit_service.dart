import 'package:wellness_app/commons.dart';

class HabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _userHabitsCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in for habits");
    return _firestore.collection('users').doc(userId).collection('habits');
  }
  CollectionReference<Map<String, dynamic>> _userCompletionsCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in for completions");
    return _firestore.collection('users').doc(userId).collection('habitCompletions');
  }

  Future<void> initializeDefaultHabitsIfNeeded() async {
    try {
      final snapshot = await _userHabitsCollection().limit(1).get();
      if (snapshot.docs.isEmpty) {
        print("No habits found for user, adding defaults...");
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
        final batch = _firestore.batch();
        for (final habit in defaultHabits) {
          final docRef = _userHabitsCollection().doc();
          batch.set(docRef, habit.toFirestore());
        }
        await batch.commit();
        print("Default habits added.");
      }
    } catch (e) {
      print("Error initializing default habits: $e");
    }
  }

  Future<List<Habit>> getAllHabits() async {
    await initializeDefaultHabitsIfNeeded();
    try {
      final snapshot = await _userHabitsCollection().orderBy('createdAt').get();
      return snapshot.docs.map((doc) => Habit.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Error getting habits: $e");
      return []; }
  }

  Future<void> addHabit(Habit habit) async {
    try {
      await _userHabitsCollection().add(habit.toFirestore());
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _userHabitsCollection().doc(habit.id).update(habit.toFirestore());
    } catch (e) {
      print("Error updating habit: $e");
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _userHabitsCollection().doc(habitId).delete();
      final completionsSnapshot = await _userCompletionsCollection()
          .where('habitId', isEqualTo: habitId)
          .get();

      if (completionsSnapshot.docs.isNotEmpty) {
        final batch = _firestore.batch();
        for (final doc in completionsSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        print("Deleted ${completionsSnapshot.docs.length} completions for habit $habitId");
      }
    } catch (e) {
      print("Error deleting habit or its completions: $e");
    }
  }
  Future<List<HabitCompletion>> getCompletions({DateTime? since}) async {
    try {
      Query<Map<String, dynamic>> query = _userCompletionsCollection();
      if (since != null) {
        query = query.where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(since));
      }
      final snapshot = await query.orderBy('completedAt', descending: true).get();
      return snapshot.docs.map((doc) => HabitCompletion.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Error getting completions: $e");
      return [];
    }
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final completionTimestamp = Timestamp.fromDate(dateOnly);

    try {
      final querySnapshot = await _userCompletionsCollection()
          .where('habitId', isEqualTo: habitId)
          .where('completedAt', isEqualTo: completionTimestamp)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _userCompletionsCollection().doc(docId).delete();
        print("Removed completion for habit $habitId on $dateOnly");
      } else {
        final now = DateTime.now();
        final newCompletion = HabitCompletion(
          id: '',
          habitId: habitId,
          completedAt: dateOnly,
          createdAt: now,
          updatedAt: now,
        );
        await _userCompletionsCollection().add(newCompletion.toFirestore());
        print("Added completion for habit $habitId on $dateOnly");
      }
    } catch (e) {
      print("Error toggling habit completion: $e");
    }
  }

  Future<bool> isHabitCompletedToday(String habitId) async {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final todayTimestamp = Timestamp.fromDate(todayDateOnly);

    try {
      final querySnapshot = await _userCompletionsCollection()
          .where('habitId', isEqualTo: habitId)
          .where('completedAt', isEqualTo: todayTimestamp)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if habit completed today: $e");
      return false;
    }
  }

  Future<int> getStreakForHabit(String habitId) async {
    try {
      final completionsSnapshot = await _userCompletionsCollection()
          .where('habitId', isEqualTo: habitId)
          .orderBy('completedAt', descending: true)
          .get();

      final habitCompletions = completionsSnapshot.docs
          .map((doc) => (doc.data()['completedAt'] as Timestamp).toDate())
          .map((dt) => DateTime(dt.year, dt.month, dt.day))
          .toSet()
          .toList();

      if (habitCompletions.isEmpty) return 0;

      int streak = 0;
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      DateTime checkDate = todayDate;
      int completionIndex = 0;


      while (completionIndex < habitCompletions.length) {
        final completionDate = habitCompletions[completionIndex];

        if (completionDate.isAtSameMomentAs(checkDate)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
          completionIndex++;
        } else if (completionDate.isBefore(checkDate)) {
          break;
        } else {
          completionIndex++;
        }
      }
      if (streak > 0 && !habitCompletions.first.isAtSameMomentAs(todayDate)) {
        final yesterday = todayDate.subtract(const Duration(days: 1));
        if (!habitCompletions.first.isAtSameMomentAs(yesterday)) {
          return 0;
        }
      }

      return streak;
    } catch (e) {
      print("Error calculating streak: $e");
      return 0;
    }
  }
}
