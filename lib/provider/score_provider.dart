import 'package:wellness_app/commons.dart';

class ScoreProvider extends ChangeNotifier {
  DailyScore? _todayScore;
  List<DailyScore> _scoreHistory = [];

  final Box<DailyScore>_scoreBox = Hive.box<DailyScore>('daily_scores');

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

  void loadData(){
    _scoreHistory = _scoreBox.values.toList();

    _scoreHistory.sort((a, b) => a.date.compareTo(b.date));

    final today = DateTime.now();
    final todayEntry = _scoreHistory.firstWhere(
        (score) => isSameDay(score.date, today),
        orElse: () => DailyScore.empty(),
        );
    if (todayEntry.id.isNotEmpty) {
      _todayScore = todayEntry;
      _steps = todayEntry.steps;
      _moodValue = todayEntry.moodValue;
      _completedHabits = todayEntry.completedHabits;
      _totalHabits = todayEntry.totalHabits;
      _glassesDrunk = todayEntry.glassesDrunk;
    } else{
      _todayScore = todayEntry;
    }
    notifyListeners();
  }
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _recalculateScore() {
    _todayScore = DailyScore.calculateDailyScore(
      id: _todayScore?.id,
      steps: steps,
      moodValue: moodValue,
      completedHabits: completedHabits,
      totalHabits: totalHabits,
      glassesDrunk: glassesDrunk,
    );
    saveTodayScore();
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
      _scoreBox.put(_todayScore!.id, _todayScore!);
      final existingIndex = _scoreHistory.indexWhere((s)=>s.id==_todayScore!.id);
      if(existingIndex!=-1){
        _scoreHistory[existingIndex] = _todayScore!;
        // _scoreBox.putAt(existingIndex, _todayScore!);
      }else{
        _scoreHistory.add(_todayScore!);
      }
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