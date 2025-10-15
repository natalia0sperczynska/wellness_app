import 'package:wellness_app/commons.dart';

class MoodIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;
  final String tooltip;
  final VoidCallback onTap;

  const MoodIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: isSelected
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Icon(
            icon,
            size: 40,
            color: color,
          ),
        ),
      ),
    );
  }
}