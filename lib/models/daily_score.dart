import 'package:wellness_app/commons.dart';

class DailyScore extends HiveObject{
  final String id;
  final DateTime date;
  final int totalScore;
  final int stepsScore;
  final int moodScore;
  final int habitsScore;
  final int hydrationScore;
  final int steps;
  final int? moodValue;
  final int completedHabits;
  final int totalHabits;
  final int glassesDrunk;

  DailyScore({
    required this.id,
    required this.date,
    required this.totalScore,
    required this.stepsScore,
    required this.moodScore,
    required this.habitsScore,
    required this.hydrationScore,
    required this.steps,
    this.moodValue,
    required this.completedHabits,
    required this.totalHabits,
    required this.glassesDrunk,
  });
  //empty daily score
  factory DailyScore.emptyForDate(DateTime date) {
    String dateId = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return DailyScore(
      id: dateId,
      date: date,
      totalScore: 0,
      stepsScore: 0,
      moodScore: 0,
      habitsScore: 0,
      hydrationScore: 0,
      steps: 0,
      moodValue: null,
      completedHabits: 0,
      totalHabits: 0,
      glassesDrunk: 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'totalScore': totalScore,
      'stepsScore': stepsScore,
      'moodScore': moodScore,
      'habitsScore': habitsScore,
      'hydrationScore': hydrationScore,
      'steps': steps,
      'moodValue': moodValue,
      'completedHabits': completedHabits,
      'totalHabits': totalHabits,
      'glassesDrunk': glassesDrunk,
    };
  }
  factory DailyScore.fromFirestore(Map<String, dynamic> data, String documentId) {
    return DailyScore(
      id: documentId,
      date: (data['date'] as Timestamp).toDate(),
      totalScore: data['totalScore'] as int? ?? 0,
      stepsScore: data['stepsScore'] as int? ?? 0,
      moodScore: data['moodScore'] as int? ?? 0,
      habitsScore: data['habitsScore'] as int? ?? 0,
      hydrationScore: data['hydrationScore'] as int? ?? 0,
      steps: data['steps'] as int? ?? 0,
      moodValue: data['moodValue'] as int?,
      completedHabits: data['completedHabits'] as int? ?? 0,
      totalHabits: data['totalHabits'] as int? ?? 0,
      glassesDrunk: data['glassesDrunk'] as int? ?? 0,
    );
  }

  static DailyScore calculateDailyScore({
    required DateTime date,
    required int steps,
    required int? moodValue,
    required int completedHabits,
    required int totalHabits,
    required int glassesDrunk
  }) {
    final stepScore = _calculateStepScore(steps);
    final moodScore = _calculateMoodScore(moodValue);
    final habitsScore = _calculateHabitsScore(completedHabits, totalHabits);
    final hydrationScore = _calculateHydrationScore(glassesDrunk);
    int finalScore = stepScore + moodScore + habitsScore+hydrationScore;

    String dateId = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return DailyScore(
      id: dateId,
      date: date,
      totalScore: finalScore,
      moodScore: moodScore,
      habitsScore: habitsScore,
      hydrationScore: hydrationScore,
      steps: steps,
      moodValue: moodValue,
      completedHabits: completedHabits,
      totalHabits: totalHabits,
      glassesDrunk: glassesDrunk, stepsScore: stepScore,
    );
  }

  static int _calculateStepScore(int steps) {
    final score = (steps / 10000) * 30;
    return score.round().clamp(0, 30);
  }

  static int _calculateMoodScore(int? moodValue) {
    if (moodValue == null) return 0;
    final score = (moodValue / 5) * 30;
    return score.round().clamp(0, 30);
  }

  static int _calculateHabitsScore(int completedHabits, int totalHabits) {
    if (totalHabits == 0) return 0;
    final score = (completedHabits / totalHabits) * 30;
    return score.round().clamp(0, 30);
  }

  static int _calculateHydrationScore(int glassesDrunk) {
    final score = (glassesDrunk / 8) * 10;
    return score.round().clamp(0, 10);
  }
}