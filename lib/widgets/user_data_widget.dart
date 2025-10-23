import 'package:wellness_app/commons.dart';

class UserDataWidget extends StatelessWidget {

  const UserDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (user == null) {
      return const SizedBox.shrink();
    }
    return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 0,
        color: colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                children: [
                CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primary,
                child: Text(
                  user.email?.isNotEmpty == true ? user.email![0].toUpperCase() : 'U',
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
                ),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                  'Signed in as:',
                  style: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                ),
                const SizedBox(height: 4),
                Text(user.email ?? 'No email available',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                  ],
                ),
            ),
                ],
            ),
        ),
    );
  }
}