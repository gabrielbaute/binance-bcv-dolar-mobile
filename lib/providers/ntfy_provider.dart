import 'package:flutter/foundation.dart';
import '../services/ntfy_service.dart';
import '../services/preferences_service.dart';

/// Provider encargado de gestionar el estado de las notificaciones push NTFY con persistencia local.
///
/// Attributes:
///   - _ntfyService (NtfyService): Instancia del servicio de comunicación NTFY.
///   - _isLoading (bool): Estado de carga durante las operaciones de suscripción.
///   - _errorMessage (String?): Mensaje de error en caso de fallos.
class NtfyProvider extends ChangeNotifier {
  final NtfyService _ntfyService;

  bool _isLoading = false;
  String? _errorMessage;

  /// Crea una instancia de [NtfyProvider].
  ///
  /// Args:
  ///   - ntfyService (NtfyService?): Instancia opcional de [NtfyService] para inyección.
  NtfyProvider({NtfyService? ntfyService})
    : _ntfyService = ntfyService ?? NtfyService() {
    _loadInitialState();
  }

  bool get isSubscribed => _ntfyService.isSubscribed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga el estado inicial de suscripción guardado localmente
  /// y reanuda la escucha si el usuario la había dejado activa.
  Future<void> _loadInitialState() async {
    final savedState = await PreferencesService.getNtfySubscribed();
    if (savedState == true) {
      // Como el usuario tenía las notificaciones activas, intentamos reanudar la suscripción.
      // Usamos las mismas credenciales y URL por defecto configuradas para NTFY.
      const String topicUrl = String.fromEnvironment(
        'NTFY_TOPIC_URL',
        defaultValue: 'https://your-ntfy-service',
      );
      const String username = String.fromEnvironment(
        'NTFY_USERNAME',
        defaultValue: 'your-user',
      );
      const String password = String.fromEnvironment(
        'NTFY_PASSWORD',
        defaultValue: 'your-pass',
      );

      _isLoading = true;
      notifyListeners();

      try {
        final success = await _ntfyService.subscribe(
          topicUrl: topicUrl,
          username: username.isNotEmpty ? username : null,
          password: password.isNotEmpty ? password : null,
        );

        if (!success) {
          // Si falla la reconexión automática, actualizamos la preferencia a false
          // para evitar bucles o estados inconsistentes.
          await PreferencesService.saveNtfySubscribed(false);
        }
      } catch (e) {
        debugPrint('Error al reconectar NTFY automáticamente: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Alterna el estado de las notificaciones (Activar / Desactivar).
  ///
  /// Args:
  ///   - topicUrl (String): URL del tópico NTFY.
  ///   - username (String?): Usuario de autenticación opcional.
  ///   - password (String?): Contraseña opcional.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  Future<void> toggleNotifications({
    required String topicUrl,
    String? username,
    String? password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_ntfyService.isSubscribed) {
        await _ntfyService.unsubscribe();
        await PreferencesService.saveNtfySubscribed(false);
      } else {
        final success = await _ntfyService.subscribe(
          topicUrl: topicUrl,
          username: username,
          password: password,
        );
        if (success) {
          await PreferencesService.saveNtfySubscribed(true);
        } else {
          _errorMessage =
              'No se pudo completar la suscripción a las notificaciones.';
        }
      }
    } catch (e) {
      _errorMessage =
          'Error inesperado al cambiar el estado de las notificaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
