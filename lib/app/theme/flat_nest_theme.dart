import 'package:flutter/material.dart';

class FlatNestTheme extends ThemeExtension<FlatNestTheme> {
  final Color primary;
  final Color primarySoft;
  final Color primaryInk;
  final Color secondary;
  final Color secondarySoft;
  final Color bg;
  final Color bgAlt;
  final Color surface;
  final Color border;
  final Color borderSoft;
  final Color ink;
  final Color inkMid;
  final Color inkSoft;
  final Color inkFaint;
  final Color success;
  final Color warning;
  final Color error;
  final Color successSoft;
  final Color warningSoft;
  final Color errorSoft;
  final bool isDark;

  FlatNestTheme({
    required this.primary,
    required this.primarySoft,
    required this.primaryInk,
    required this.secondary,
    required this.secondarySoft,
    required this.bg,
    required this.bgAlt,
    required this.surface,
    required this.border,
    required this.borderSoft,
    required this.ink,
    required this.inkMid,
    required this.inkSoft,
    required this.inkFaint,
    required this.success,
    required this.warning,
    required this.error,
    required this.successSoft,
    required this.warningSoft,
    required this.errorSoft,
    this.isDark = false,
  });

  @override
  ThemeExtension<FlatNestTheme> copyWith({
    Color? primary,
    Color? primarySoft,
    Color? primaryInk,
    Color? secondary,
    Color? secondarySoft,
    Color? bg,
    Color? bgAlt,
    Color? surface,
    Color? border,
    Color? borderSoft,
    Color? ink,
    Color? inkMid,
    Color? inkSoft,
    Color? inkFaint,
    Color? success,
    Color? warning,
    Color? error,
    Color? successSoft,
    Color? warningSoft,
    Color? errorSoft,
    bool? isDark,
  }) {
    return FlatNestTheme(
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryInk: primaryInk ?? this.primaryInk,
      secondary: secondary ?? this.secondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      bg: bg ?? this.bg,
      bgAlt: bgAlt ?? this.bgAlt,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      borderSoft: borderSoft ?? this.borderSoft,
      ink: ink ?? this.ink,
      inkMid: inkMid ?? this.inkMid,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      successSoft: successSoft ?? this.successSoft,
      warningSoft: warningSoft ?? this.warningSoft,
      errorSoft: errorSoft ?? this.errorSoft,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  ThemeExtension<FlatNestTheme> lerp(ThemeExtension<FlatNestTheme>? other, double t) {
    if (other is! FlatNestTheme) return this;
    return FlatNestTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryInk: Color.lerp(primaryInk, other.primaryInk, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondarySoft: Color.lerp(secondarySoft, other.secondarySoft, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      bgAlt: Color.lerp(bgAlt, other.bgAlt, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMid: Color.lerp(inkMid, other.inkMid, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      errorSoft: Color.lerp(errorSoft, other.errorSoft, t)!,
      isDark: other.isDark,
    );
  }

  static FlatNestTheme get light => FlatNestTheme(
        primary: const Color(0xFF1A6B72),
        primarySoft: const Color(0xFFE6F0F1),
        primaryInk: const Color(0xFF0E484D),
        secondary: const Color(0xFFFF6B6B),
        secondarySoft: const Color(0xFFFFE9E9),
        bg: const Color(0xFFF7F8FA),
        bgAlt: const Color(0xFFEEF0F4),
        surface: const Color(0xFFFFFFFF),
        border: const Color(0xFFE5E7EB),
        borderSoft: const Color(0xFFEFF1F4),
        ink: const Color(0xFF1C1C1E),
        inkMid: const Color(0xFF5B5B62),
        inkSoft: const Color(0xFF8A8A8E),
        inkFaint: const Color(0xFFC7C7CC),
        success: const Color(0xFF34C759),
        warning: const Color(0xFFFF9500),
        error: const Color(0xFFFF3B30),
        successSoft: const Color(0xFFE6F8EC),
        warningSoft: const Color(0xFFFFF1DD),
        errorSoft: const Color(0xFFFFE5E3),
        isDark: false,
      );

  static FlatNestTheme get dark => FlatNestTheme(
        primary: const Color(0xFF46A7AE),
        primarySoft: const Color(0xFF0F2C2E),
        primaryInk: const Color(0xFFA7DDE1),
        secondary: const Color(0xFFFF8585),
        secondarySoft: const Color(0xFF3A1F1F),
        bg: const Color(0xFF0E1113),
        bgAlt: const Color(0xFF16191C),
        surface: const Color(0xFF1B1F22),
        border: const Color(0xFF2A2F33),
        borderSoft: const Color(0xFF23262A),
        ink: const Color(0xFFF4F5F7),
        inkMid: const Color(0xFFB6BABE),
        inkSoft: const Color(0xFF8A8E92),
        inkFaint: const Color(0xFF4C5054),
        success: const Color(0xFF34C759),
        warning: const Color(0xFFFF9F0F),
        error: const Color(0xFFFF453A),
        successSoft: const Color(0xFF0F2A18),
        warningSoft: const Color(0xFF2D1F08),
        errorSoft: const Color(0xFF2A0F0D),
        isDark: true,
      );
}
