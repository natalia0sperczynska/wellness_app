import 'package:wellness_app/commons.dart';

class HydrationPageController extends ChangeNotifier {
  int _glassesOfWater = 0;
  final int _maxGlasses = 16;
  final TextEditingController _glassesOfWaterController =
      TextEditingController();

  int get glassesOfWater => _glassesOfWater;

  int get maxGlasses => _maxGlasses;

  void setGlasses(int count) {
    _glassesOfWater = count;
    notifyListeners();
  }

  void toggleGlasses(int index) {
    if (index < _glassesOfWater) {
      _glassesOfWater = index;
    } else {
      _glassesOfWater = index + 1;
    }
    notifyListeners();
  }

  void resetGlasses() {
    _glassesOfWater = 0;
    notifyListeners();
  }
}
