import 'dart:convert';
import 'dart:async';
import 'package:ntfy/ntfy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'log_service.dart';

/// Servicio encargado de gestionar la suscripción a notificaciones push mediante NTFY,
/// el control de permisos y el filtrado inteligente de eventos de tasas de cambio.
///
/// Attributes:
///   - _logService (LogService): Instancia del servicio centralizado de logs.
///   - _isSubscribed (bool): Bandera que indica si el cliente se encuentra suscrito.
///   - _ntfyPlugin (Ntfy): Instancia del plugin ntfy para manejo de streams.
///   - _messageSubscription (StreamSubscription?): Suscripción activa al flujo de mensajes.
class NtfyService {
  final LogService _logService = LogService();
  final Ntfy _ntfyPlugin = Ntfy();

  bool _isSubscribed = false;
  StreamSubscription? _messageSubscription;

  /// Retorna si el cliente se encuentra suscrito actualmente.
  ///
  /// Returns:
  ///   - bool: True si está activo, false en caso contrario.
  bool get isSubscribed => _isSubscribed;

  /// Suscribe la aplicación al tópico de NTFY aplicando una estructura atómica.
  ///
  /// Args:
  ///   - topicUrl (String): URL completa del tópico NTFY (ej. https://dolarpulsentfy.samanbooks.site/dolar_test).
  ///   - username (String?): Usuario opcional para autenticación.
  ///   - password (String?): Contraseña opcional para autenticación.
  ///
  /// Returns:
  ///   - Future&lt;bool&gt;: True si la suscripción y escucha se iniciaron con éxito.
  Future<bool> subscribe({
    required String topicUrl,
    String? username,
    String? password,
  }) async {
    try {
      _logService.info('Iniciando proceso de suscripción a NTFY...');

      // 1. Validar permisos mediante helper atómico
      final hasPermission = await _validatePermissions();
      if (!hasPermission) {
        _logService.warning(
          'Suscripción abortada: Permisos de notificación insuficientes.',
        );
        return false;
      }

      // 2. Configurar parámetros de conexión y parsear URL/Tópico vía helper
      final connectionConfig = _buildConnectionParameters(
        topicUrl: topicUrl,
        username: username,
        password: password,
      );

      _logService.debug(
        'Configuración de conexión preparada - Base: ${connectionConfig['baseUrl']}, Tópico: ${connectionConfig['topicName']}',
      );

      // 3. Inicializar la escucha de eventos en segundo plano vía helper
      await _listenToTopic(
        baseUrl: connectionConfig['baseUrl']!,
        topicName: connectionConfig['topicName']!,
        username: username,
        password: password,
      );

      _isSubscribed = true;
      _logService.info(
        'Suscripción a NTFY establecida y escuchando correctamente.',
      );
      return true;
    } catch (e, stackTrace) {
      _logService.error(
        'Error crítico al suscribirse al tópico NTFY',
        e,
        stackTrace,
      );
      _isSubscribed = false;
      return false;
    }
  }

  /// Cancela la suscripción al tópico de NTFY y libera recursos del stream.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  Future<void> unsubscribe() async {
    try {
      _logService.debug('Cancelando suscripción al tópico NTFY...');

      await _messageSubscription?.cancel();
      _messageSubscription = null;

      await _ntfyPlugin.unsubscribe();

      _isSubscribed = false;
      _logService.info('Suscripción cancelada exitosamente.');
    } catch (e, stackTrace) {
      _logService.error('Error al cancelar la suscripción NTFY', e, stackTrace);
    }
  }

  /// [Helper Atómico] Solicita y valida los permisos nativos de notificación en el dispositivo.
  ///
  /// Returns:
  ///   - Future&lt;bool&gt;: Verdadero si el permiso está concedido.
  Future<bool> _validatePermissions() async {
    try {
      _logService.verbose(
        'Verificando permisos de notificación con permission_handler...',
      );
      final status = await Permission.notification.request();

      if (status.isGranted) {
        _logService.info('Permiso de notificaciones concedido.');
        return true;
      } else if (status.isPermanentlyDenied) {
        _logService.warning(
          'El permiso de notificación fue denegado permanentemente.',
        );
        return false;
      } else {
        _logService.warning('El permiso de notificaciones fue denegado.');
        return false;
      }
    } catch (e, stackTrace) {
      _logService.error(
        'Excepción al validar permisos de notificación',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// [Helper Atómico] Desglosa la URL completa del tópico en URL Base y Nombre de Tópico,
  /// preparando además los metadatos de autenticación.
  ///
  /// Args:
  ///   - topicUrl (String): URL completa (ej. https://servidor.com/mi_topico).
  ///   - username (String?): Usuario opcional.
  ///   - password (String?): Contraseña opcional.
  ///
  /// Returns:
  ///   - Map&lt;String, String&gt;: Mapa con 'baseUrl', 'topicName' y 'hasAuth'.
  Map<String, String> _buildConnectionParameters({
    required String topicUrl,
    String? username,
    String? password,
  }) {
    _logService.verbose(
      'Construyendo y normalizando parámetros de conexión para NTFY...',
    );

    final uri = Uri.parse(topicUrl);
    final pathSegments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final topicName = pathSegments.isNotEmpty ? pathSegments.last : '';
    final baseUrl = '${uri.scheme}://${uri.authority}';

    return {
      'baseUrl': baseUrl,
      'topicName': topicName,
      'hasAuth': (username != null && password != null).toString(),
    };
  }

  /// [Helper Atómico] Conecta al servidor NTFY mediante el plugin y comienza a escuchar el flujo de mensajes.
  ///
  /// Args:
  ///   - baseUrl (String): URL base del servidor.
  ///   - topicName (String): Nombre del tópico a escuchar.
  ///   - username (String?): Usuario opcional.
  ///   - password (String?): Contraseña opcional.
  ///
  /// Returns:
  ///   - Future&lt;void&gt;
  Future<void> _listenToTopic({
    required String baseUrl,
    required String topicName,
    String? username,
    String? password,
  }) async {
    _logService.verbose(
      'Estableciendo conexión de escucha (stream) con NTFY en $baseUrl (Tópico: $topicName)...',
    );

    await _messageSubscription?.cancel();

    String? authHeader;
    if (username != null &&
        password != null &&
        username.isNotEmpty &&
        password.isNotEmpty) {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      authHeader = 'Basic $credentials';
      _logService.debug(
        'Autenticación Basic Auth configurada para el cliente NTFY.',
      );
    }

    _messageSubscription = _ntfyPlugin.messages.listen(
      (dynamic rawPayload) {
        _logService.debug('Mensaje recibido: $rawPayload');
        try {
          Map<String, dynamic> parsedMessage;
          if (rawPayload is String) {
            parsedMessage = jsonDecode(rawPayload);
          } else if (rawPayload is Map) {
            parsedMessage = Map<String, dynamic>.from(rawPayload);
          } else {
            parsedMessage = {'message': rawPayload.toString()};
          }

          _filterAndNotify(parsedMessage);
        } catch (e, stackTrace) {
          _logService.error(
            'Error al procesar el payload de NTFY',
            e,
            stackTrace,
          );
        }
      },
      onError: (error) {
        _logService.error('Error detectado en el stream de NTFY: $error');
      },
    );

    await _ntfyPlugin.subscribe(baseUrl, topicName, auth: authHeader);

    _logService.info('Suscripción al canal de streaming de NTFY completada.');
  }

  /// [Helper Atómico] Filtra los mensajes recibidos evaluando estrictamente
  /// que las etiquetas (tags) incluyan 'bcv_update' o 'binance_update'.
  ///
  /// Args:
  ///   - rawMessage (Map&lt;String, dynamic&gt;): Datos decodificados del mensaje NTFY.
  ///
  /// Returns:
  ///   - void
  void _filterAndNotify(Map<String, dynamic> rawMessage) {
    try {
      final title = rawMessage['title']?.toString() ?? 'Actualización de Tasa';
      final message =
          rawMessage['message']?.toString() ?? 'Nueva tasa disponible';
      final rawTags = rawMessage['tags'];

      // Normalizar los tags recibidos a una lista de cadenas en minúsculas
      List<String> tagsList = [];
      if (rawTags is List) {
        tagsList = rawTags
            .map((t) => t.toString().toLowerCase().trim())
            .toList();
      } else if (rawTags is String) {
        tagsList = rawTags
            .split(',')
            .map((t) => t.trim().toLowerCase())
            .toList();
      }

      _logService.verbose(
        'Evaluando mensaje NTFY -> Título: "$title" | Tags: $tagsList',
      );

      final bool isBcvUpdate = tagsList.contains('bcv_update');
      final bool isBinanceUpdate = tagsList.contains('binance_update');

      if (isBcvUpdate || isBinanceUpdate) {
        final eventType = isBcvUpdate ? 'bcv_update' : 'binance_update';
        _logService.debug(
          '¡Evento válido detectado ($eventType)! Título: "$title" | Mensaje: "$message"',
        );
      } else {
        _logService.debug(
          'Evento ignorado por política de filtrado: Los tags no incluyen bcv_update ni binance_update.',
        );
      }
    } catch (e, stackTrace) {
      _logService.error(
        'Error al filtrar el mensaje entrante de NTFY',
        e,
        stackTrace,
      );
    }
  }
}
