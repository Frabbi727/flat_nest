import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppFontSize {
  static const double xs = 10.0;
  static const double sm = 12.0;
  static const double md = 14.0;
  static const double lg = 16.0;
  static const double xl = 18.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;
  static const double display = 32.0;
}

class AppTextStyles {
  static TextStyle get base => GoogleFonts.poppins();

  static TextStyle get h1 => base.copyWith(
        fontSize: AppFontSize.xxxl,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => base.copyWith(
        fontSize: AppFontSize.xxl,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => base.copyWith(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => base.copyWith(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => base.copyWith(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => base.copyWith(
        fontSize: AppFontSize.xs,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );
}
