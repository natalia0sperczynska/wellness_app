import 'package:wellness_app/commons.dart';

class HabitsController extends ChangeNotifier {
  final HabitService _habitService = HabitService();
  List<Habit> _habits = [];
  Map<String, bool> _completionStatus = {};
  bool _isLoading = true;
  List<Habit> get habits => _habits;
  Map<String, bool> get completionStatus => _completionStatus;
  bool get isLoading => _isLoading;
  int get completedCount => _completionStatus.values.where((v) => v).length;
  int get totalCount => _habits.length;

  HabitsController() {
    loadHabits();
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
  }

  Future<void> toggleHabit(String habitId) async {
    await _habitService.toggleHabitCompletion(habitId, DateTime.now());
    await loadHabits();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitService.addHabit(habit);
    await loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitService.updateHabit(habit);
    await loadHabits();
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitService.deleteHabit(habitId);
    await loadHabits();
  }
}