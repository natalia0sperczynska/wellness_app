import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wellness_app/commons.dart';

class ScoreCircle extends StatelessWidget {
  final int score;
  final double size;

  const ScoreCircle({
    super.key,
    required this.score,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = score / 100;
    final color = _getScoreColor(score);

    return CircularPercentIndicator(
      radius: size,
      lineWidth: 12.0,
      percent: percentage,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '/100',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      progressColor: color,
      backgroundColor: Colors.grey,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }

  _getScoreColor(int score) {
    if(score >= 80) return Color.fromRGBO(30, 67, 32, 1);
    if(score >= 60) return Colors.lightGreen;
    if(score >= 40) return Colors.yellow;
    return Colors.red;
  }
}
