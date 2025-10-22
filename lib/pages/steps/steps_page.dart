import 'package:flutter/services.dart';
import 'package:wellness_app/commons.dart';
class StepsPage extends StatelessWidget {
  const StepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme =Theme.of(context).textTheme;
    return ChangeNotifierProvider(
      create: (_) => StepsPageController(),
      child: Consumer<StepsPageController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Steps tracker'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: SingleChildScrollView(
                child:Column(
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
                    TextFormField(
                      controller: controller.stepsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Add your steps number',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      maxLines: 1,
                      onChanged: (_) => controller.setSteps(),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => controller.setSteps(),
                      child: const Text("Save"),
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
                    ElevatedButton(
                      onPressed: () => controller.resetSteps(),
                      child: const Text("Reset"),
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