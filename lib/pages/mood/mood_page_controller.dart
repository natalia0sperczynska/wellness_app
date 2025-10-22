import 'package:wellness_app/commons.dart';

class MoodController extends ChangeNotifier {
  final ScoreProvider _scoreProvider;
  int? _selectedMoodValue;
  String? _note;

  List<Mood> _moods = [];

  int? get selectedMoodValue => _selectedMoodValue;

  String? get selectedNote => _note;

  List<Mood> get moods => _moods;

  MoodController(this._scoreProvider) {
    _selectedMoodValue = _scoreProvider.moodValue;
  }

  void selectMood(int mood) {
    _selectedMoodValue = mood;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void saveMood() {
    _scoreProvider.updateMood(_selectedMoodValue);
    //zapisanei do bazy danych todo
  }

  void clear() {
    _selectedMoodValue = null;
    _note = null;
    _scoreProvider.updateMood(null);
    notifyListeners();
  }
}
