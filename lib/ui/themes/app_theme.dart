import 'package:flutter/material.dart';
import 'app_theme_dark.dart';
import 'app_theme_light.dart';

/// Punto de acceso centralizado para los temas de la aplicación.
class AppTheme {
  AppTheme._();

  /// Obtiene la configuración del Tema Oscuro.
  static ThemeData get darkTheme => AppThemeDark.theme;

  /// Obtiene la configuración del Tema Claro.
  static ThemeData get lightTheme => AppThemeLight.theme;
}
