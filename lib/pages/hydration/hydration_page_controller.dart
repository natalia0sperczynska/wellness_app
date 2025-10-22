import 'package:wellness_app/commons.dart';

class HydrationPageController extends ChangeNotifier {
  final ScoreProvider _scoreProvider;
  int _glassesOfWater = 0;
  final int _maxGlasses = 16;
  final TextEditingController _glassesOfWaterController =
      TextEditingController();

  int get glassesOfWater => _glassesOfWater;

  int get maxGlasses => _maxGlasses;

  HydrationPageController(this._scoreProvider) {
    _glassesOfWater = _scoreProvider.glassesDrunk;
  }

  void _updateStateAndScore() {
    _scoreProvider.updateGlasses(_glassesOfWater);
    notifyListeners();
  }

  void setGlasses(int count) {
    _glassesOfWater = count;
    _updateStateAndScore();
  }

  void toggleGlasses(int index) {
    if (index < _glassesOfWater) {
      _glassesOfWater = index;
    } else {
      _glassesOfWater = index + 1;
    }
    _updateStateAndScore();
  }

  void resetGlasses() {
    _glassesOfWater = 0;
    _updateStateAndScore();
  }
}
