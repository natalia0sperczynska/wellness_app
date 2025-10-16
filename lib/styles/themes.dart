import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/commons.dart';

final  lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  fontFamily: 'IndieFlower',
  textTheme: TextTheme(
    displayLarge: GoogleFonts.indieFlower(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textColor),
    headlineMedium: GoogleFonts.indieFlower(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
    bodyMedium: GoogleFonts.indieFlower(fontSize: 16, color: AppColors.textColor),
    labelLarge: GoogleFonts.indieFlower(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.indieFlower(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColor),
    iconTheme: IconThemeData(color: AppColors.primaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      textStyle: GoogleFonts.indieFlower(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),

);
//todo
final ThemeData darkTheme = ThemeData();
final ThemeData zenTheme = ThemeData();
final ThemeData energyTheme = ThemeData();
