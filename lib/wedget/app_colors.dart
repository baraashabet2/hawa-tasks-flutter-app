import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color low;
  final Color medium;
  final Color high;
  final Color lowBg;
  final Color mediumBg;
  final Color highBg;

  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.low,
    required this.medium,
    required this.high,
    required this.lowBg,
    required this.mediumBg,
    required this.highBg,
  });

  static const light = AppColors(
    background: Color(0xFFF4F6F0),
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFF1D9E75),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF666666),
    low: Color(0xFF1D9E75),
    medium: Color(0xFFBA7517),
    high: Color(0xFFD85A30),
    lowBg: Color(0xFFE8F5EE),
    mediumBg: Color(0xFFFFF3E4),
    highBg: Color(0xFFFFE8E1),
  );

  static const dark = AppColors(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    primary: Color(0xFF2DC98F),
    textPrimary: Color(0xFFF1F1F1),
    textSecondary: Color(0xFF9E9E9E),
    low: Color(0xFF2DC98F),
    medium: Color(0xFFE09B2A),
    high: Color(0xFFE8714A),
    lowBg: Color(0xFF1A3328),
    mediumBg: Color(0xFF2E2210),
    highBg: Color(0xFF2E1A13),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? textPrimary,
    Color? textSecondary,
    Color? low,
    Color? medium,
    Color? high,
    Color? lowBg,
    Color? mediumBg,
    Color? highBg,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
      lowBg: lowBg ?? this.lowBg,
      mediumBg: mediumBg ?? this.mediumBg,
      highBg: highBg ?? this.highBg,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      low: Color.lerp(low, other.low, t)!,
      medium: Color.lerp(medium, other.medium, t)!,
      high: Color.lerp(high, other.high, t)!,
      lowBg: Color.lerp(lowBg, other.lowBg, t)!,
      mediumBg: Color.lerp(mediumBg, other.mediumBg, t)!,
      highBg: Color.lerp(highBg, other.highBg, t)!,
    );
  }
}
