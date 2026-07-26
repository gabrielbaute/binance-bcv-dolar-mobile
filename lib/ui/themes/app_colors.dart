import 'package:flutter/material.dart';

/// Clase estática que contiene la definición centralizada de colores de la aplicación.
class AppColors {
  AppColors._();

  // Colores Base del CSS
  static const Color bg1 = Color(0xFF020617);
  static const Color bg2 = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xBF0F172A);
  static const Color surfaceStrongDark = Color(0xF20F172A);

  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textMutedDark = Color(0xFFCBD5E1);

  // Colores Semánticos / Acentos (CSS variables)
  static const Color accentSky = Color(0xFF0EA5E9);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentAmber = Color(0xFFF59E0B);

  // Estados de Verificación / Alertas
  static const Color ok = Color(0xFF22C55E);
  static const Color warn = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Líneas y Bordes
  static const Color lineDark = Color(0x3D94A3B8);
  static const Color lineLight = Color(0x3364748B);

  // Colores Base para Light Mode
  static const Color bg1Light = Color(0xFFF8FAFC);
  static const Color bg2Light = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  /// Esquema de colores para el tema Oscuro.
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: accentSky,
    onPrimary: Color(0xFF082F49),
    primaryContainer: Color(0xFF0369A1),
    onPrimaryContainer: Color(0xFFE0F2FE),
    secondary: accentTeal,
    onSecondary: Color(0xFF042F2C),
    secondaryContainer: Color(0xFF0F766E),
    onSecondaryContainer: Color(0xFFCCFBF1),
    tertiary: accentAmber,
    onTertiary: Color(0xFF451A03),
    tertiaryContainer: Color(0xFFB45309),
    onTertiaryContainer: Color(0xFFFEF3C7),
    error: danger,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: bg2,
    onSurface: textPrimaryDark,
    onSurfaceVariant: textMutedDark,
    outline: lineDark,
  );

  /// Esquema de colores para el tema Claro.
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0284C7),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE0F2FE),
    onPrimaryContainer: Color(0xFF0369A1),
    secondary: Color(0xFF0D9488),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCCFBF1),
    onSecondaryContainer: Color(0xFF0F766E),
    tertiary: Color(0xFFD97706),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFFB45309),
    error: danger,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: bg1Light,
    onSurface: textPrimaryLight,
    onSurfaceVariant: textMutedLight,
    outline: lineLight,
  );
}
