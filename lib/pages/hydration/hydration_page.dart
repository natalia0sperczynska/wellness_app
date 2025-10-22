import 'package:wellness_app/commons.dart';
import 'package:wellness_app/pages/hydration/hydration_page_controller.dart';

class HydrationPage extends StatelessWidget {
  const HydrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ChangeNotifierProvider(
      create: (_) => HydrationPageController(),
      child: Consumer<HydrationPageController>(
        child: const _StaticContentHydrationPage(),
        builder: (context, controller, staticContent) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Track your hydration'),
            ),
            body: Column(
              children: [
                staticContent!,
                _GlassCounter(glasses: controller.glassesOfWater),
                _GlassGrid(
                  totalGlasses: controller.glassesOfWater,
                  maxGlasses: controller.maxGlasses,
                  onGlassTapped: controller.toggleGlasses,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: controller.resetGlasses,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class _StaticContentHydrationPage extends StatelessWidget {
  const _StaticContentHydrationPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Hydration', style: textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Mark how many glasses of water have you drunk today!',
                style: textTheme.bodyLarge),
          ],
        ),
      );
  }
}

class _GlassCounter extends StatelessWidget {
  final int glasses;
  const _GlassCounter({required this.glasses});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
        child: Text('$glasses glasses of water',
          style: Theme.of(context).textTheme.headlineLarge,
    )
    );
  }
}

class _GlassGrid extends StatelessWidget {
  final int totalGlasses;
  final int maxGlasses;
  final Function(int) onGlassTapped;

  const _GlassGrid({
    required this.totalGlasses,
    required this.maxGlasses,
    required this.onGlassTapped,
});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  return Expanded(
    child: GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,

  ),
        itemCount: maxGlasses,
        itemBuilder: (context, index){
        final isFilled = index< totalGlasses;

        return GestureDetector(
          onTap: () => onGlassTapped(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: Image.asset(
              isFilled
                  ? 'assets/glass_filled.png'
                  : 'assets/glass_empty.png',
              fit: BoxFit.contain,
            ),
          ),
        );
        },
    ),
  );
  }
}
