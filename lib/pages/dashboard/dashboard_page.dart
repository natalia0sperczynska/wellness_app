import 'package:wellness_app/commons.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardPageController(),
      child: Consumer<DashboardPageController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Progress', style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                children: [
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
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Graph Placeholder",
                        style: TextStyle(color: Colors.white54),
                      ),
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
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}