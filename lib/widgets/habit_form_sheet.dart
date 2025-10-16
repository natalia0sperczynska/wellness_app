import 'package:wellness_app/commons.dart';

class HabitFormResult {
  final String name;
  final String emoji;
  final String category;

  const HabitFormResult({
    required this.name,
    required this.emoji,
    required this.category,
  });
}

class HabitFormSheet extends StatefulWidget {
  final Habit? initialHabit;

  const HabitFormSheet({super.key, this.initialHabit});

  @override
  State<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<HabitFormSheet> {
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
      HabitFormResult(
        name: _nameController.text,
        emoji: _emojiController.text,
        category: _categoryController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.initialHabit == null ? 'Add habit' : 'Edit habit';

    return Padding(
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
                Text(title, style: theme.textTheme.titleLarge),
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
                    decoration: const InputDecoration(labelText: 'Emoji', hintText: '🌟'),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Add an emoji' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Habit name', hintText: 'Evening stretch'),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Name your habit' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category', hintText: 'Movement, Mindfulness…'),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Add a category' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Cancel'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: _submit, child: Text(widget.initialHabit == null ? 'Add habit' : 'Save changes'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}