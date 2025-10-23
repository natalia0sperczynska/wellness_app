import 'package:wellness_app/commons.dart';

part 'daily_score.g.dart';

@HiveType(typeId: 0)
class DailyScore extends HiveObject{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final int totalScore;
  @HiveField(3)
  final int stepsScore;
  @HiveField(4)
  final int moodScore;
  @HiveField(5)
  final int habitsScore;
  @HiveField(6)
  final int hydrationScore;
  @HiveField(7)
  final int steps;
  @HiveField(8)
  final int? moodValue;
  @HiveField(9)
  final int completedHabits;
  @HiveField(10)
  final int totalHabits;
  @HiveField(11)
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
  factory DailyScore.empty() {
    return DailyScore(
      id: '',
      date: DateTime.now(),
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

  static DailyScore calculateDailyScore({
    String? id,
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
      id: (id != null && id.isNotEmpty) ? id : DateTime
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