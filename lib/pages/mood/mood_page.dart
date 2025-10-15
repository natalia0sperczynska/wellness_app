import 'package:wellness_app/commons.dart';

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoodController(),
      child: Consumer<MoodController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Track Your Mood', style: TextStyle()),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // ikony do wyboru nastroju
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.sentiment_very_satisfied,
                          size: 50,
                          color: Colors.green,
                        ),
                        Icon(
                          Icons.sentiment_satisfied,
                          size: 50,
                          color: Colors.lightGreen,
                        ),
                        Icon(
                          Icons.sentiment_neutral,
                          size: 50,
                          color: Colors.amber,
                        ),
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 50,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 50,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // logika w kontrolerze
                        controller.saveMood();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Save Mood',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
