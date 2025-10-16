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
              title: const Text('Progress'),
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
                  const SizedBox(height: 20),
                  StepCircle(
                    stepNumber: controller.steps,
                    progress: controller.progress,
                    isActive: true,
                    isCompleted: controller.progress >= 1,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoCard(title: "Steps", value: "${controller.steps}"),
                      _InfoCard(title: "Goal", value: "${controller.goal}"),
                      _InfoCard(title: "Progress", value: "${(controller.progress * 100).toStringAsFixed(1)}%"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Graph Placeholder",
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => controller.incrementSteps(500),
                    child: const Text("Add 500 steps"),
                  )
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

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}