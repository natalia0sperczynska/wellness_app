import 'package:flutter/material.dart';
import '../models/daily_score.dart';

class ScoreProvider extends ChangeNotifier {
  DailyScore? _todayScore;
  List<DailyScore> _scoreHistory = [];

  int _steps = 0;
  int? _moodValue;
  int _completedHabits = 0;
  int _totalHabits = 5;
  int _glassesDrunk = 0;

  DailyScore? get todayScore => _todayScore;
  List<DailyScore> get scoreHistory => _scoreHistory;

  int get steps => _steps;
  int? get moodValue => _moodValue;
  int get completedHabits => _completedHabits;
  int get totalHabits => _totalHabits;
  int get glassesDrunk => _glassesDrunk;
  int get maxGlasses => 16;

  void _recalculateScore() {
    _todayScore = DailyScore.calculateDailyScore(
      steps: steps,
      moodValue: moodValue,
      completedHabits: completedHabits,
      totalHabits: totalHabits,
      glassesDrunk: glassesDrunk,
    );
    notifyListeners();
  }

  void updateSteps(int newSteps) {
    _steps = newSteps;
    _recalculateScore();
  }

  void updateMood(int? newMood) {
    _moodValue = newMood;
    _recalculateScore();
  }

  void updateHabits(int completed, int total) {
    _completedHabits = completed;
    _totalHabits = total;
    _recalculateScore();
  }

  void updateGlasses(int newGlasses) {
    _glassesDrunk = newGlasses;
    _recalculateScore();
  }

  void saveTodayScore() {
    if (_todayScore != null) {
      _scoreHistory.add(_todayScore!);
      notifyListeners();
    }
  }

  //data for test
  void loadMockData() {
    _steps = 8500;
    _moodValue = 4;
    _completedHabits = 3;
    _totalHabits = 5;
    _glassesDrunk = 6;
    _recalculateScore();
  }
}