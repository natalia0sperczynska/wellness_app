import 'package:wellness_app/commons.dart';

class MoodController extends ChangeNotifier{
  int? _selectedMoodValue;
 String? _note;

 List<Mood>_moods=[];

  int? get selectedMoodValue => _selectedMoodValue;
  String? get selectedNote => _note;
  List<Mood> get moods => _moods;

  void selectMood(int mood){
    _selectedMoodValue = mood;
    notifyListeners();
  }

  void setNote(String note){
    _note = note;
    notifyListeners();
  }


  void saveMood(){
    //zapisanei do bazy danych todo
  }

  void clear(){
    _selectedMoodValue=null;
    _note=null;
    notifyListeners();

  }

}