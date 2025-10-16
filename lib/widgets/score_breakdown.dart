import 'package:wellness_app/commons.dart';

class ScoreBreakdown extends StatelessWidget {
  final int stepsScore;
  final int moodScore;
  final int habitsScore;
  final int hydrationScore;

  const ScoreBreakdown({
    super.key,
    required this.stepsScore,
    required this.moodScore,
    required this.habitsScore,
    required this.hydrationScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Score Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildScoreRow('Steps', stepsScore, 30, Icons.directions_walk),
            _buildScoreRow('Mood', moodScore, 30, Icons.emoji_emotions),
            _buildScoreRow('Habits', habitsScore, 30, Icons.check_circle),
            _buildScoreRow('Hydration', hydrationScore, 10, Icons.local_drink),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, int maxScore, IconData icon) {
    final percentage = score / maxScore;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: _getCategoryColor(label), size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(label)),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$score/$maxScore',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Steps':
        return Colors.blue;
      case 'Mood':
        return Colors.orange;
      case 'Habits':
        return Colors.green;
      case 'Hydration':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}