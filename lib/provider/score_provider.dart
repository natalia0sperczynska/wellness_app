import 'package:wellness_app/commons.dart';

class ScoreProvider extends ChangeNotifier {
  DailyScore? _todayScore;
  List<DailyScore> _scoreHistory = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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


  CollectionReference<Map<String, dynamic>> _userScoresCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    return _firestore.collection('users').doc(userId).collection('dailyScores');
  }
  Future<void> loadData() async {
    final user = _auth.currentUser;
    if (user == null) {
      _clearLocalData();
      notifyListeners();
      print("Firestore Load: User not logged in, clearing data.");
      return;
    }

    final today = DateTime.now();
    final scoreIdForToday = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    try {
      final todayDocSnapshot = await _userScoresCollection().doc(scoreIdForToday).get();

      if (todayDocSnapshot.exists && todayDocSnapshot.data() != null) {
        _todayScore = DailyScore.fromFirestore(todayDocSnapshot.data()!, todayDocSnapshot.id);
        _updateLocalFieldsFromTodayScore();
        print("Firestore Load: Loaded score for today: ID=${_todayScore?.id}");
      } else {
        _todayScore = DailyScore.emptyForDate(today);
        _resetLocalFields();
        print("Firestore Load: No score found for today, created empty: ID=${_todayScore?.id}");
      }

      final historySnapshot = await _userScoresCollection()
          .orderBy('date', descending: true)
          .limit(7)
          .get();

      _scoreHistory = historySnapshot.docs
          .map((doc) => DailyScore.fromFirestore(doc.data(), doc.id))
          .toList()
          .reversed
          .toList();
      print("Firestore Load: Loaded ${_scoreHistory.length} scores for history.");

    } catch (e) {
      print("Firestore Load Error: $e");
      _clearLocalData();
    }

    notifyListeners();
  }


  Future<void> saveTodayScore() async {
    final user = _auth.currentUser;
    if (_todayScore != null && user != null) {
      try {
        await _userScoresCollection()
            .doc(_todayScore!.id)
            .set(_todayScore!.toFirestore(), SetOptions(merge: true));
        print("Firestore Save: Saved score ID=${_todayScore!.id}");

        _updateHistoryCache(_todayScore!);

        notifyListeners();
      } catch (e) {
        print("Firestore Save Error: $e");
      }
    } else {
      print("Firestore Save: Cannot save - score or user is null.");
    }
  }

  void _updateHistoryCache(DailyScore scoreToUpdate) {
    final existingIndex = _scoreHistory.indexWhere((s) => s.id == scoreToUpdate.id);
    if (existingIndex != -1) {

      _scoreHistory[existingIndex] = scoreToUpdate;
    } else {
      _scoreHistory.add(scoreToUpdate);
      _scoreHistory.sort((a,b) => a.date.compareTo(b.date));
      if (_scoreHistory.length > 7) {
        _scoreHistory.removeAt(0);
      }
    }
  }

  void _recalculateScore() {
    final dateToUse = _todayScore?.date ?? DateTime.now();
    _todayScore = DailyScore.calculateDailyScore(
      date:dateToUse,
      steps: _steps,
      moodValue: _moodValue,
      completedHabits: _completedHabits,
      totalHabits: _totalHabits,
      glassesDrunk: _glassesDrunk,
    );
    notifyListeners();
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
  void _clearLocalData() {
    _todayScore = null;
    _scoreHistory = [];
    _resetLocalFields();
  }
  void _resetLocalFields() {
    _steps = 0;
    _moodValue = null;
    _completedHabits = 0;
    _glassesDrunk = 0;
  }
  void _updateLocalFieldsFromTodayScore() {
    if (_todayScore != null) {
      _steps = _todayScore!.steps;
      _moodValue = _todayScore!.moodValue;
      _completedHabits = _todayScore!.completedHabits;
      _totalHabits = _todayScore!.totalHabits;
      _glassesDrunk = _todayScore!.glassesDrunk;
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