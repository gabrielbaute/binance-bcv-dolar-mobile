import 'package:permission_handler/permission_handler.dart';
import 'log_service.dart';

/// Servicio encargado de gestionar la suscripción a notificaciones push mediante NTFY
/// y la verificación de permisos en el dispositivo.
///
/// Attributes:
///   - _logService (LogService): Instancia del servicio de logs para trazabilidad.
///   - _isSubscribed (bool): Estado actual de la suscripción al tópico.
class NtfyService {
  final LogService _logService = LogService();
  bool _isSubscribed = false;

  /// Retorna si el cliente se encuentra suscrito actualmente.
  ///
  /// Returns:
  ///   - bool: True si está suscrito, false en caso contrario.
  bool get isSubscribed => _isSubscribed;

  /// Solicita el permiso de notificaciones al sistema operativo utilizando [permission_handler].
  ///
  /// Returns:
  ///   - Future&lt;bool&gt;: True si el permiso fue concedido, false en caso contrario.
  ///
  /// Raises:
  ///   - Exception: Si ocurre un error al solicitar los permisos.
  Future<bool> requestNotificationPermission() async {
    try {
      _logService.info('Solicitando permiso de notificaciones...');
      final status = await Permission.notification.request();

      if (status.isGranted) {
        _logService.info('Permiso de notificaciones concedido por el usuario.');
        return true;
      } else if (status.isPermanentlyDenied) {
        _logService.warning(
          'El permiso de notificaciones fue denegado permanentemente.',
        );
        // Aquí el usuario tendría que activarlo manualmente en ajustes si lo desea
        return false;
      } else {
        _logService.warning('Permiso de notificaciones denegado.');
        return false;
      }
    } catch (e, stackTrace) {
      _logService.error(
        'Error al solicitar permiso de notificaciones',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Suscribe la aplicación al tópico de NTFY configurado.
  ///
  /// Args:
  ///   - topicUrl (String): URL completa del tópico NTFY (ej. https://dolarpulsentfy.samanbooks.site/mi_topico).
  ///   - username (String?): Usuario opcional para autenticación básica en el servidor NTFY.
  ///   - password (String?): Contraseña opcional para autenticación básica.
  ///
  /// Returns:
  ///   - Future&lt;bool&gt;: True si la suscripción fue exitosa.
  Future<bool> subscribe({
    required String topicUrl,
    String? username,
    String? password,
  }) async {
    try {
      // 1. Validar permisos primero
      final hasPermission = await requestNotificationPermission();
      if (!hasPermission) {
        _logService.warning(
          'No se puede suscribir: Permisos de notificación insuficientes.',
        );
        return false;
      }

      _logService.info('Iniciando suscripción al tópico NTFY: $topicUrl');

      // TODO: Integrar aquí la lógica específica del paquete `ntfy` para conectar
      // al servidor, configurar credenciales si aplican y escuchar los eventos.
      // Ejemplo conceptual de filtrado de eventos (bcv_update / binance_update):
      // - El payload recibido contendrá metadatos como 'event'.
      // - Si event == 'bcv_update' o event == 'binance_update', disparamos la notificación local.

      _isSubscribed = true;
      _logService.info('Suscripción a NTFY establecida exitosamente.');
      return true;
    } catch (e, stackTrace) {
      _logService.error('Error al suscribirse al tópico NTFY', e, stackTrace);
      _isSubscribed = false;
      return false;
    }
  }

  /// Cancela la suscripción al tópico de NTFY.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  Future<void> unsubscribe() async {
    try {
      _logService.info('Cancelando suscripción al tópico NTFY...');

      // TODO: Desconectar el cliente/servicio de NTFY.

      _isSubscribed = false;
      _logService.info('Suscripción cancelada correctamente.');
    } catch (e, stackTrace) {
      _logService.error('Error al cancelar la suscripción NTFY', e, stackTrace);
    }
  }
}
