import 'package:flutter/material.dart';

/// Provider encargado de gestionar el estado del tema (Claro, Oscuro o Sistema).
///
/// Attributes:
///   - _themeMode (ThemeMode): Modo de tema actual seleccionado por el usuario.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  /// Constructor de ThemeProvider.
  ///
  /// Args:
  ///   initialThemeMode (ThemeMode): Modo inicial del tema. Por defecto es ThemeMode.system.
  ThemeProvider({ThemeMode initialThemeMode = ThemeMode.system})
    : _themeMode = initialThemeMode;

  /// Obtiene el modo de tema actual.
  ThemeMode get themeMode => _themeMode;

  /// Indica si actualmente está activo el modo oscuro estricto.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Establece un nuevo modo de tema y notifica a los escuchas.
  ///
  /// Args:
  ///   mode (ThemeMode): Nuevo modo de tema a aplicar.
  ///
  /// Returns:
  ///   void
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  /// Alterna entre el modo claro y el modo oscuro.
  ///
  /// Returns:
  ///   void
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}
