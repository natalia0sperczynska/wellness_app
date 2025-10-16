import 'package:wellness_app/commons.dart';
class DashboardPageController extends ChangeNotifier {
  int _steps = 4567;
  int _goal = 8000;
  int _wellnessScore = 75;

  int get steps => _steps;
  int get goal => _goal;

  double get progress => _steps / _goal;

  int get wellnessScore => _wellnessScore;


  void incrementSteps(int amount) {
    _steps += amount;
    notifyListeners(); // hej cos sie zmieniło
  }

  void resetSteps() {
    _steps = 0;
    notifyListeners();
  }
}
