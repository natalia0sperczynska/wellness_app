import 'package:flutter/material.dart';
import '../models/daily_score.dart';

class ScoreProvider extends ChangeNotifier {
  DailyScore? _todayScore;
  List<DailyScore> _scoreHistory = [];

  DailyScore? get todayScore => _todayScore;
  List<DailyScore> get scoreHistory => _scoreHistory;

  void calculateTodayScore({
    required int steps,
    int? moodValue,
    required int completedHabits,
    required int totalHabits,
    required int glassesDrunk,
  }) {
    _todayScore = DailyScore.calculateDailyScore(
      steps: steps,
      moodValue: moodValue,
      completedHabits: completedHabits,
      totalHabits: totalHabits,
      glassesDrunk: glassesDrunk,
    );

    notifyListeners();
  }

  void saveTodayScore() {
    if (_todayScore != null) {
      _scoreHistory.add(_todayScore!);
      notifyListeners();
    }
  }

  //data for test
  void loadMockData() {
    calculateTodayScore(
      steps: 8500,
      moodValue: 4,
      completedHabits: 3,
      totalHabits: 5,
      glassesDrunk: 6,
    );
  }
}