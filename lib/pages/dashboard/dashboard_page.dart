import 'package:wellness_app/commons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreProvider = context.watch<ScoreProvider>();
    final DailyScore? todayScore = scoreProvider.todayScore;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Wellness Score')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.gapMedium),
          child: Column(
            children: [
              _StaticDashboardHeader(),
              const SizedBox(height: 30),
              ScoreCircle(score: todayScore?.totalScore ?? 0),
              const SizedBox(height: 20),
              ScoreBreakdown(
                stepsScore: todayScore?.stepsScore ?? 0,
                moodScore: todayScore?.moodScore ?? 0,
                habitsScore: todayScore?.habitsScore ?? 0,
                hydrationScore: todayScore?.hydrationScore ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticDashboardHeader extends StatelessWidget {
  const _StaticDashboardHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(children: [GreetingHeader()]);
  }
}
