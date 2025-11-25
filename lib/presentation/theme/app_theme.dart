import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.textLight,
    required this.textDark,
    required this.subtleLight,
    required this.subtleDark,
    required this.borderLight,
    required this.borderDark,
    required this.primaryHover,
  });

  final Color? primary;
  final Color? backgroundLight;
  final Color? backgroundDark;
  final Color? textLight;
  final Color? textDark;
  final Color? subtleLight;
  final Color? subtleDark;
  final Color? borderLight;
  final Color? borderDark;
  final Color? primaryHover;

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? backgroundLight,
    Color? backgroundDark,
    Color? textLight,
    Color? textDark,
    Color? subtleLight,
    Color? subtleDark,
    Color? borderLight,
    Color? borderDark,
    Color? primaryHover,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      textLight: textLight ?? this.textLight,
      textDark: textDark ?? this.textDark,
      subtleLight: subtleLight ?? this.subtleLight,
      subtleDark: subtleDark ?? this.subtleDark,
      borderLight: borderLight ?? this.borderLight,
      borderDark: borderDark ?? this.borderDark,
      primaryHover: primaryHover ?? this.primaryHover,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t),
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t),
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t),
      textLight: Color.lerp(textLight, other.textLight, t),
      textDark: Color.lerp(textDark, other.textDark, t),
      subtleLight: Color.lerp(subtleLight, other.subtleLight, t),
      subtleDark: Color.lerp(subtleDark, other.subtleDark, t),
      borderLight: Color.lerp(borderLight, other.borderLight, t),
      borderDark: Color.lerp(borderDark, other.borderDark, t),
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t),
    );
  }
}

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.workSans(fontSize: 57, fontWeight: FontWeight.bold),
  titleLarge: GoogleFonts.workSans(fontSize: 22, fontWeight: FontWeight.w500),
  bodyMedium: GoogleFonts.workSans(fontSize: 14),
  headlineSmall: GoogleFonts.workSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ), // For Welcome Back!
  bodySmall: GoogleFonts.workSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ), // For Log in to your cookbook.
  labelLarge: GoogleFonts.workSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ), // For buttons
  labelMedium: GoogleFonts.workSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ), // For labels
  labelSmall: GoogleFonts.workSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ), // For small text
);

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3E665C), // primary
    brightness: Brightness.light,
  ),
  textTheme: appTextTheme,
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFF3E665C),
      backgroundLight: Color(0xFFF8F6F4),
      backgroundDark: Color(0xFF1A1C1A),
      textLight: Color(0xFF1A1C1A),
      textDark: Color(0xFFE2E3E0),
      subtleLight: Color(0xFF687974),
      subtleDark: Color(0xFFAEBEB9),
      borderLight: Color(0xFFDCE5E2),
      borderDark: Color(0xFF404945),
      primaryHover: Color(0xFF36584F),
    ),
  ],
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFFF8F6F4), // Use backgroundLight
    selectedItemColor: const Color(0xFF3E665C), // Use primary
    unselectedItemColor: const Color(0xFF687974), // Use subtleLight
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3E665C), // primary
    brightness: Brightness.dark,
  ),
  textTheme: appTextTheme,
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      primary: Color(0xFF3E665C),
      backgroundLight: Color(0xFFF8F6F4),
      backgroundDark: Color(0xFF1A1C1A),
      textLight: Color(0xFF1A1C1A),
      textDark: Color(0xFFE2E3E0),
      subtleLight: Color(0xFF687974),
      subtleDark: Color(0xFFAEBEB9),
      borderLight: Color(0xFFDCE5E2),
      borderDark: Color(0xFF404945),
      primaryHover: Color(0xFF36584F),
    ),
  ],
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1A1C1A), // Use backgroundDark
    selectedItemColor: const Color(0xFFAEBEB9), // Use subtleDark
    unselectedItemColor: const Color(
      0xFF687974,
    ), // Use subtleLight or another appropriate color
  ),
);
