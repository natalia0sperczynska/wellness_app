import 'package:wellness_app/commons.dart';
class MoodSelector extends StatelessWidget {
  final int? selectedMoodValue;
  final ValueChanged<int> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMoodValue,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MoodIcon(
          icon: Icons.sentiment_very_dissatisfied,
          color: Colors.red,
          isSelected: selectedMoodValue == 1,
          tooltip: 'Terrible',
          onTap: () => onMoodSelected(1),
        ),
        MoodIcon(
          icon: Icons.sentiment_dissatisfied,
          color: Colors.orange,
          isSelected: selectedMoodValue == 2,
          tooltip: 'Bad',
          onTap: () => onMoodSelected(2),
        ),
        MoodIcon(
          icon: Icons.sentiment_neutral,
          color: Colors.amber,
          isSelected: selectedMoodValue == 3,
          tooltip: 'Okay',
          onTap: () => onMoodSelected(3),
        ),
        MoodIcon(
          icon: Icons.sentiment_satisfied,
          color: Colors.lightGreen,
          isSelected: selectedMoodValue == 4,
          tooltip: 'Good',
          onTap: () => onMoodSelected(4),
        ),
        MoodIcon(
          icon: Icons.sentiment_very_satisfied,
          color: Colors.green,
          isSelected: selectedMoodValue == 5,
          tooltip: 'Great',
          onTap: () => onMoodSelected(5),
        ),
      ],
    );
  }
}