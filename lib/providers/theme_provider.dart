import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Provider encargado de gestionar el estado del tema (Claro, Oscuro o Sistema) con persistencia local.
///
/// Attributes:
///   - _themeMode (ThemeMode): Modo de tema actual seleccionado por el usuario.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Constructor de ThemeProvider.
  ///
  /// Args:
  ///   initialThemeMode (ThemeMode): Modo inicial opcional.
  ThemeProvider({ThemeMode initialThemeMode = ThemeMode.system})
    : _themeMode = initialThemeMode {
    _loadThemePreference();
  }

  /// Obtiene el modo de tema actual.
  ThemeMode get themeMode => _themeMode;

  /// Indica si actualmente está activo el modo oscuro estricto.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Carga la preferencia de tema guardada en el almacenamiento local.
  Future<void> _loadThemePreference() async {
    final isDark = await PreferencesService.getDarkMode();
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  /// Establece un nuevo modo de tema, lo persiste y notifica a los escuchas.
  ///
  /// Args:
  ///   mode (ThemeMode): Nuevo modo de tema a aplicar.
  ///
  /// Returns:
  ///   void
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    PreferencesService.saveDarkMode(mode == ThemeMode.dark);
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
