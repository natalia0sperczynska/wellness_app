import 'package:wellness_app/commons.dart';

class DailyScore {
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

  static DailyScore calculateDailyScore({
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

    return DailyScore(
      id: DateTime
          .now()
          .microsecondsSinceEpoch
          .toString(),
      date: DateTime.now(),
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

  static _calculateStepScore(int steps) {
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