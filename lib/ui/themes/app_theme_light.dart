import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

/// Configuración de ThemeData para el tema claro de la aplicación.
class AppThemeLight {
  AppThemeLight._();

  /// Genera la instancia de ThemeData para el modo claro.
  ///
  /// Returns:
  ///   ThemeData: Objeto de tema configurado para Material 3 en modo claro.
  static ThemeData get theme {
    final textTheme = AppTextTheme.createTextTheme(
      textColor: AppColors.textPrimaryLight,
      mutedColor: AppColors.textMutedLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      scaffoldBackgroundColor: AppColors.bg1Light,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: const BorderSide(color: AppColors.lineLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.accentSky, width: 2.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentSky,
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }
}
