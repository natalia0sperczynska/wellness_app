import 'package:wellness_app/commons.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitsController(),
      child: Consumer<HabitsController>(
        builder: (context, controller, _) {
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;

          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openHabitForm(context, controller),
              icon: const Icon(Icons.add),
              label: const Text('Add habit'),
            ),
            body: SafeArea(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GreetingHeader(),
                          const SizedBox(height: 36),
                          ProgressRing(completed: controller.completedCount, total: controller.totalCount),
                          const SizedBox(height: 40),
                          Text('Today\'s Habits', style: textTheme.headlineMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Build your best self, one habit at a time',
                            style: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final habit = controller.habits[index];
                          final isCompleted = controller.completionStatus[habit.id] ?? false;

                          return Padding(
                            padding: EdgeInsets.only(bottom: index == controller.habits.length - 1 ? 0 : 16),
                            child: HabitCard(
                              habit: habit,
                              isCompleted: isCompleted,
                              onToggle: () => controller.toggleHabit(habit.id),
                              onEdit: () => _openHabitForm(context, controller, habit: habit),
                              onDelete: () => _confirmDeleteHabit(context, controller, habit),
                            ),
                          );
                        },
                        childCount: controller.habits.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openHabitForm(BuildContext context, HabitsController controller, {Habit? habit}) async {
    final result = await showModalBottomSheet<HabitFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => HabitFormSheet(initialHabit: habit),
    );

    if (result == null) return;

    final now = DateTime.now();
    if (habit == null) {
      final newHabit = Habit(
        id: now.millisecondsSinceEpoch.toString(),
        name: result.name.trim(),
        emoji: result.emoji.trim(),
        category: result.category.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await controller.addHabit(newHabit);
      _showSnackBar(context, 'Habit added');
    } else {
      final updatedHabit = habit.copyWith(
        name: result.name.trim(),
        emoji: result.emoji.trim(),
        category: result.category.trim(),
        updatedAt: now,
      );
      await controller.updateHabit(updatedHabit);
      _showSnackBar(context, 'Habit updated');
    }
  }

  Future<void> _confirmDeleteHabit(BuildContext context, HabitsController controller, Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('This will remove "${habit.name}" and its progress history.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton.tonal(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    ) ??
        false;

    if (!shouldDelete) return;

    await controller.deleteHabit(habit.id);
    _showSnackBar(context, 'Habit removed');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}