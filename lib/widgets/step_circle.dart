import 'package:wellness_app/commons.dart';

class StepCircle extends StatelessWidget{
  final int stepNumber;
  final double progress;
  final bool isActive;
  final bool isCompleted;

  const StepCircle({
    super.key,
    required this.stepNumber,
    required this.progress,
    required this.isActive,
    required this.isCompleted,
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [CircularProgressIndicator(
          value:progress,
          strokeWidth: 10,
          backgroundColor: Colors.white10,
          valueColor: const AlwaysStoppedAnimation(AppColors.accentColor),
      ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_walk, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                "$stepNumber",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "steps",
                style: TextStyle(color: Colors.white70),
              )
            ],
          ),
        ],
      ),
    );
  }
}