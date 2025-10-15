import 'package:wellness_app/commons.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  fontFamily: 'IndieFlower',
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 24, color: AppColors.textColor),
    titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
  ),
);
//todo
final ThemeData darkTheme = ThemeData();
final ThemeData zenTheme = ThemeData();
final ThemeData energyTheme = ThemeData();
