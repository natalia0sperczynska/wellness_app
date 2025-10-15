import 'package:wellness_app/commons.dart';
import 'package:wellness_app/pages/mood/mood_selector.dart';

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
                    MoodSelector(
                      selectedMoodValue: controller.selectedMoodValue,
                      onMoodSelected: (moodValue) =>
                          controller.selectMood(moodValue),
                    ),
                    const SizedBox(height: 20),

                    if (controller.selectedMoodValue != null)
                      Text(
                        "Selected Mood: ${_getMoodText(controller.selectedMoodValue!)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => controller.setNote(value),
                      decoration: const InputDecoration(
                        hintText: 'Add a note about your mood (optional)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: controller.selectedMoodValue != null
                          ? () {
                              // logika w kontrolerze
                              controller.saveMood();
                              //_showSuccessSnackbar(context);
                            }
                          : null,
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

  String _getMoodText(int i) {
    switch (i) {
      case 1:
        return 'Terrible';
      case 2:
        return 'Bad';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Terrific';
      default:
        return 'Not selected';
    }
  }
}
