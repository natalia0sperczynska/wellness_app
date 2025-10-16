import 'package:wellness_app/commons.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final HabitService _habitService = HabitService();
  List<Habit> _habits = [];
  Map<String, bool> _completionStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    final habits = await _habitService.getAllHabits();
    final status = <String, bool>{};

    for (final habit in habits) {
      status[habit.id] = await _habitService.isHabitCompletedToday(habit.id);
    }

    setState(() {
      _habits = habits;
      _completionStatus = status;
      _isLoading = false;
    });
  }

  Future<void> _toggleHabit(String habitId) async {
    await _habitService.toggleHabitCompletion(habitId, DateTime.now());
    await _loadHabits();
  }

  Future<void> _openHabitForm({Habit? habit}) async {
    final result = await showModalBottomSheet<_HabitFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _HabitFormSheet(initialHabit: habit),
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
      await _habitService.addHabit(newHabit);
      _showSnackBar('Habit added');
    } else {
      final updatedHabit = habit.copyWith(
        name: result.name.trim(),
        emoji: result.emoji.trim(),
        category: result.category.trim(),
        updatedAt: now,
      );
      await _habitService.updateHabit(updatedHabit);
      _showSnackBar('Habit updated');
    }

    await _loadHabits();
  }

  Future<void> _confirmDeleteHabit(Habit habit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('This will remove "${habit.name}" and its progress history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;

    if (!shouldDelete) return;

    await _habitService.deleteHabit(habit.id);
    _showSnackBar('Habit removed');
    await _loadHabits();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  int get _completedCount => _completionStatus.values.where((v) => v).length;
  int get _totalCount => _habits.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openHabitForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add habit'),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
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
                    ProgressRing(completed: _completedCount, total: _totalCount),
                    const SizedBox(height: 40),
                    Text(
                      'Today\'s Habits',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Build your best self, one habit at a time',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor),
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
                    final habit = _habits[index];
                    final isCompleted = _completionStatus[habit.id] ?? false;

                    return Padding(
                      padding: EdgeInsets.only(bottom: index == _habits.length - 1 ? 0 : 16),
                      child: HabitCard(
                        habit: habit,
                        isCompleted: isCompleted,
                        onToggle: () => _toggleHabit(habit.id),
                        onEdit: () => _openHabitForm(habit: habit),
                        onDelete: () => _confirmDeleteHabit(habit),
                      ),
                    );
                  },
                  childCount: _habits.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitFormResult {
  final String name;
  final String emoji;
  final String category;

  const _HabitFormResult({
    required this.name,
    required this.emoji,
    required this.category,
  });
}

class _HabitFormSheet extends StatefulWidget {
  final Habit? initialHabit;

  const _HabitFormSheet({this.initialHabit});

  @override
  State<_HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<_HabitFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emojiController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialHabit?.name ?? '');
    _emojiController = TextEditingController(text: widget.initialHabit?.emoji ?? '');
    _categoryController = TextEditingController(text: widget.initialHabit?.category ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      _HabitFormResult(
        name: _nameController.text,
        emoji: _emojiController.text,
        category: _categoryController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = widget.initialHabit == null ? 'Add habit' : 'Edit habit';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emojiController,
                        decoration: const InputDecoration(
                          labelText: 'Emoji',
                          hintText: '🌟',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Add a mood emoji';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Habit name',
                          hintText: 'Evening stretch',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name your habit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'Movement, Mindfulness…',
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Add a category';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(widget.initialHabit == null ? 'Add habit' : 'Save changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
