import 'package:wellness_app/commons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DashboardPageController(),
        child: Consumer<DashboardPageController>(
            child: const _StaticDashboardHeader(),
            builder: (context, controller, StaticDashboardHeader) {
              return Scaffold(
                appBar: AppBar(
                  // Używamy tytułu z motywu
                  title: const Text('Your Wellness Score'),
                ),
                body:SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.gapMedium),
                    child: Column(
                        children: [
                      StaticDashboardHeader!,
                const SizedBox(height: 30),
                ScoreCircle(score: controller.wellnessScore),
                const SizedBox(height: 20),
                ScoreBreakdown(stepsScore: 8500,
                    moodScore: 4,
                    habitsScore: 3,
                    hydrationScore: 6)
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

class _StaticDashboardHeader extends StatelessWidget {
  const _StaticDashboardHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [ GreetingHeader()]);}}