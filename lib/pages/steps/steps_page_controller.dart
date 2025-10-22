import 'package:wellness_app/commons.dart';

class StepsPageController extends ChangeNotifier {
  final ScoreProvider _scoreProvider;
  int _steps = 0;
  final int _goal = 8000;
  final TextEditingController _stepsController = TextEditingController();

  int get steps => _steps;

  int get goal => _goal;

  TextEditingController get stepsController => _stepsController;

  double get progress => _steps / _goal;

  StepsPageController(this._scoreProvider) {
    _steps = _scoreProvider.steps;
    _stepsController.text = _steps.toString();
  }

  void _updateStateAndScore() {
    _scoreProvider.updateSteps(_steps);
    notifyListeners();
  }

  void incrementSteps(int amount) {
    _steps += amount;
    _updateControllerText();
    _updateStateAndScore(); // hej cos sie zmieniło
  }

  void resetSteps() {
    _steps = 0;
    _updateControllerText();
    _updateStateAndScore();
  }

  void setSteps() {
    final input = _stepsController.text;
    if (input.isNotEmpty) {
      _steps = int.tryParse(input) ?? _steps;
      _updateStateAndScore();
    }
  }

  void _updateControllerText() {
    _stepsController.text = _steps.toString();
  }
}
