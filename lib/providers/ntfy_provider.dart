import 'package:flutter/foundation.dart';
import '../services/ntfy_service.dart';

/// Provider encargado de gestionar el estado de las notificaciones push NTFY en la aplicación.
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
    : _ntfyService = ntfyService ?? NtfyService();

  bool get isSubscribed => _ntfyService.isSubscribed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
      } else {
        final success = await _ntfyService.subscribe(
          topicUrl: topicUrl,
          username: username,
          password: password,
        );
        if (!success) {
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
