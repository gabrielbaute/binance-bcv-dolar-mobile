import 'package:shared_preferences/shared_preferences.dart';

/// Servicio centralizado para gestionar la persistencia local de preferencias con SharedPreferences.
class PreferencesService {
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyNtfySubscribed = 'ntfy_subscribed';

  /// Guarda el estado del modo oscuro.
  ///
  /// Args:
  ///   - isDark (bool): Verdadero si el modo oscuro está activo.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  /// Lee el estado guardado del modo oscuro.
  ///
  /// Returns:
  ///   - Future&lt;bool?&gt;: El valor almacenado, o null si no se ha configurado previamente.
  static Future<bool?> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode);
  }

  /// Guarda el estado de la suscripción a notificaciones NTFY.
  ///
  /// Args:
  ///   - isSubscribed (bool): Verdadero si el usuario está suscrito.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  static Future<void> saveNtfySubscribed(bool isSubscribed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNtfySubscribed, isSubscribed);
  }

  /// Lee el estado guardado de la suscripción NTFY.
  ///
  /// Returns:
  ///   - Future&lt;bool?&gt;: El valor almacenado, o null si no existe.
  static Future<bool?> getNtfySubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNtfySubscribed);
  }
}
