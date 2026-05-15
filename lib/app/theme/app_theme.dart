import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'flat_nest_theme.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: _textTheme,
        extensions: [
          FlatNestTheme(
            ink: AppColors.textPrimary,
            inkMid: AppColors.textSecondary,
            inkSoft: AppColors.textFaint,
            surface: AppColors.surfaceLight,
            borderSoft: AppColors.borderSoft,
          ),
        ],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _textTheme.apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
        ),
        extensions: [
          FlatNestTheme(
            ink: AppColors.white,
            inkMid: Colors.white70,
            inkSoft: Colors.white54,
            surface: AppColors.surfaceDark,
            borderSoft: AppColors.borderSoftDark,
          ),
        ],
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelSmall: AppTextStyles.caption,
      );
}
