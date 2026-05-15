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
        extensions: [FlatNestTheme.light],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF46A7AE),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _textTheme.apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
        ),
        extensions: [FlatNestTheme.dark],
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
