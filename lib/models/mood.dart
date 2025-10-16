
class Mood{
  final String id;
  final DateTime dateTime;
  final int moodValue; //1-5
  final String? notes;

    Mood({
    required this.id,
    required this.dateTime,
    required this.moodValue,
    this.notes,
});

}