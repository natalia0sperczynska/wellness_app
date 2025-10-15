import 'package:wellness_app/commons.dart';

class MoodController extends ChangeNotifier{
 String? _selectedMood;

  void selectMood(String mood){
    _selectedMood = mood;
    notifyListeners();
  }

  void saveMood(){
    //zapisanei do bazy danych todo
  }

}