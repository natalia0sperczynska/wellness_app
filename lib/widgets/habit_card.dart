import 'package:wellness_app/commons.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isCompleted
                ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.onSurface.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    habit.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        decorationColor: colorScheme.onSurface.withValues(alpha: 0.4),
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
                    : null,
              ),
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                  ],
                  icon: Icon(
                    Icons.more_horiz,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  tooltip: 'More options',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
