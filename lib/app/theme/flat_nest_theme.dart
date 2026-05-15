import 'package:flutter/material.dart';

class FlatNestTheme extends ThemeExtension<FlatNestTheme> {
  final Color ink;
  final Color inkMid;
  final Color inkSoft;
  final Color surface;
  final Color borderSoft;

  FlatNestTheme({
    required this.ink,
    required this.inkMid,
    required this.inkSoft,
    required this.surface,
    required this.borderSoft,
  });

  @override
  ThemeExtension<FlatNestTheme> copyWith({
    Color? ink,
    Color? inkMid,
    Color? inkSoft,
    Color? surface,
    Color? borderSoft,
  }) {
    return FlatNestTheme(
      ink: ink ?? this.ink,
      inkMid: inkMid ?? this.inkMid,
      inkSoft: inkSoft ?? this.inkSoft,
      surface: surface ?? this.surface,
      borderSoft: borderSoft ?? this.borderSoft,
    );
  }

  @override
  ThemeExtension<FlatNestTheme> lerp(ThemeExtension<FlatNestTheme>? other, double t) {
    if (other is! FlatNestTheme) return this;
    return FlatNestTheme(
      ink: Color.lerp(ink, other.ink, t)!,
      inkMid: Color.lerp(inkMid, other.inkMid, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t)!,
    );
  }
}
