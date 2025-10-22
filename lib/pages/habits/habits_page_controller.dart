import 'package:wellness_app/commons.dart';

class HabitsController extends ChangeNotifier {
  final ScoreProvider _scoreProvider;
  final HabitService _habitService = HabitService();
  List<Habit> _habits = [];
  Map<String, bool> _completionStatus = {};
  bool _isLoading = true;
  List<Habit> get habits => _habits;
  Map<String, bool> get completionStatus => _completionStatus;
  bool get isLoading => _isLoading;
  int get completedCount => _completionStatus.values.where((v) => v).length;
  int get totalCount => _habits.length;

  HabitsController(this._scoreProvider) {
    loadHabits();
  }
  void _updateGlobalScore() {
    _scoreProvider.updateHabits(completedCount, totalCount);
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    final loadedHabits = await _habitService.getAllHabits();
    final status = <String, bool>{};
    for (final habit in loadedHabits) {
      status[habit.id] = await _habitService.isHabitCompletedToday(habit.id);
    }

    _habits = loadedHabits;
    _completionStatus = status;
    _isLoading = false;
    notifyListeners();
    _updateGlobalScore();
  }

  Future<void> toggleHabit(String habitId) async {
    await _habitService.toggleHabitCompletion(habitId, DateTime.now());
    final currentStatus = _completionStatus[habitId] ?? false;
    _completionStatus[habitId] = !currentStatus;

    notifyListeners();
    _updateGlobalScore();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitService.addHabit(habit);
    await loadHabits();
    _updateGlobalScore();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitService.updateHabit(habit);
    await loadHabits();
    _updateGlobalScore();
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitService.deleteHabit(habitId);
    await loadHabits();
    _updateGlobalScore();
  }
}