import 'package:flutter/material.dart';

/// Clase que define la jerarquía tipográfica unificada para la aplicación.
class AppTextTheme {
  AppTextTheme._();

  /// Nombre de la fuente para encabezados y números (Space Grotesk).
  static const String displayFontFamily = 'SpaceGrotesk';

  /// Nombre de la fuente para cuerpo y texto general (Plus Jakarta Sans).
  static const String bodyFontFamily = 'PlusJakartaSans';

  /// Crea la configuración de TextTheme para Material 3 basada en un color principal de texto.
  ///
  /// Args:
  ///   textColor (Color): Color del texto principal para esta variación de tema.
  ///   mutedColor (Color): Color secundario/atenuado para etiquetas e información de contexto.
  ///
  /// Returns:
  ///   TextTheme: Configuración completa de tipografías y tamaños.
  static TextTheme createTextTheme({
    required Color textColor,
    required Color mutedColor,
  }) {
    return TextTheme(
      // Encabezados Grandes y Títulos de Secciones Principales (Space Grotesk)
      displayLarge: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.03,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.02,
      ),
      displaySmall: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.02,
      ),

      // Títulos de Cards y Subsecciones
      titleLarge: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Cuerpo General de Texto (Plus Jakarta Sans)
      bodyLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: mutedColor,
      ),

      // Botones, Badges y Campos de Entrada
      labelLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 0.01,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: mutedColor,
        letterSpacing: 0.05,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: mutedColor,
        letterSpacing: 0.08,
      ),
    );
  }
}
