import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.softWhite,

    colorScheme: const ColorScheme.light(
      primary: AppColors.luxuryGold,
      secondary: AppColors.darkGold,
      tertiary: AppColors.lightGold,

      background: AppColors.pureWhite,
      surface: AppColors.softWhite,

      onPrimary: AppColors.pureWhite,
      onSecondary: AppColors.pureWhite,
      onTertiary: AppColors.deepBlack,

      onBackground: AppColors.deepBlack,
      onSurface: AppColors.deepBlack,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.pureWhite,
      foregroundColor: AppColors.deepBlack,
    ),

    cardTheme: CardTheme(
      color: AppColors.pureWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldLight,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.deepBlack,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.luxuryGold,
      secondary: AppColors.darkGold,
      tertiary: AppColors.lightGold,

      background: AppColors.deepBlack,
      surface: AppColors.charcoalBlack,

      onPrimary: AppColors.deepBlack,
      onSecondary: AppColors.pureWhite,
      onTertiary: AppColors.deepBlack,

      onBackground: AppColors.pureWhite,
      onSurface: AppColors.pureWhite,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.deepBlack,
      foregroundColor: AppColors.pureWhite,
    ),

    cardTheme: CardTheme(
      color: AppColors.darkModeCard,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldDark,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
