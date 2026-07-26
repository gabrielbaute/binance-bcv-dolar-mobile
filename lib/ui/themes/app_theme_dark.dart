import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

/// Configuración de ThemeData para el tema oscuro de la aplicación.
class AppThemeDark {
  AppThemeDark._();

  /// Genera la instancia de ThemeData para el modo oscuro.
  ///
  /// Returns:
  ///   ThemeData: Objeto de tema configurado para Material 3 en modo oscuro.
  static ThemeData get theme {
    final textTheme = AppTextTheme.createTextTheme(
      textColor: AppColors.textPrimaryDark,
      mutedColor: AppColors.textMutedDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      scaffoldBackgroundColor: AppColors.bg1,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: const BorderSide(color: AppColors.lineDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceStrongDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.accentSky, width: 2.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentSky,
          foregroundColor: const Color(0xFF082F49),
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
