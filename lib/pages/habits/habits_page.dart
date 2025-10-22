import 'package:wellness_app/commons.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ChangeNotifierProvider(
      create: (context) => HabitsController(context.read<ScoreProvider>()),
      child: Consumer<HabitsController>(
        child: const _StaticHeader(),
      builder: (context, controller, staticHeader) {
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
                  child: staticHeader,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    child: ProgressRing(
                      completed: controller.completedCount,
                      total: controller.totalCount,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final habit = controller.habits[index];
                        final isCompleted = controller.completionStatus[habit
                            .id] ?? false;

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == controller.habits.length - 1
                                  ? 0
                                  : 16),
                          child: HabitCard(
                            habit: habit,
                            isCompleted: isCompleted,
                            onToggle: () => controller.toggleHabit(habit.id),
                            onEdit: () =>
                                _openHabitForm(
                                    context, controller, habit: habit),
                            onDelete: () =>
                                _confirmDeleteHabit(context, controller, habit),
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
}
class _StaticHeader extends StatelessWidget {
  const _StaticHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const GreetingHeader(),
          const SizedBox(height: 36),
          Text('Today\'s Habits', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Build your best self, one habit at a time',
            style: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
            ],
        ),
    );
  }
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
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
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
