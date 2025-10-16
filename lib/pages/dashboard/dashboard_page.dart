import 'package:wellness_app/commons.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme =Theme.of(context).textTheme;
    return ChangeNotifierProvider(
      create: (_) => DashboardPageController(),
      child: Consumer<DashboardPageController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Your wellness score for today '),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: SingleChildScrollView(
                child:Column(
                  children: [
                    const GreetingHeader(),
                    const SizedBox(height: 20),
                  ScoreCircle(score: controller.wellnessScore),
                    const SizedBox(height:20),
                    ScoreBreakdown(stepsScore: 8500, moodScore: 4, habitsScore: 3, hydrationScore: 6),
                  const SizedBox(height: 20),
                ]
            ),
            )
          )
          );
        },
      ),
    );
  }
}