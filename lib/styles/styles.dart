import 'package:wellness_app/commons.dart';
class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    color: AppColors.accentColor,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    color: AppColors.errorColor,
  );
}

class AppDecorations {
  static const InputDecoration inputStyle = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: AppColors.textColor),
  );

  static ButtonStyle filledButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
