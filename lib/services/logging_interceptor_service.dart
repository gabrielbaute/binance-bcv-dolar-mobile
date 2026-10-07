import 'package:dio/dio.dart';

import 'log_service.dart';

/// Interceptor de red para Dio que registra automáticamente el tráfico HTTP en [LogService].
///
/// Attributes:
///   - `_logService` (LogService): Instancia del servicio centralizado de logs utilizado para almacenar eventos de red.
///
/// Returns:
///   - `LoggingInterceptor`: Instancia del interceptor listo para ser registrado en la tubería de Dio.
class LoggingInterceptor extends Interceptor {
  final LogService _logService = LogService();

  /// Captura y registra la información de una petición HTTP saliente antes de ser enviada.
  ///
  /// Args:
  ///   - `options` (RequestOptions): Configuración y datos de la petición saliente.
  ///   - `handler` (RequestInterceptorHandler): Manejador para continuar la ejecución de la petición.
  ///
  /// Returns:
  ///   - `void`
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri.toString();
    final method = options.method;
    _logService.info('HTTP [OUT] $method ->$uri');
    super.onRequest(options, handler);
  }

  /// Captura y registra la respuesta devuelta por el servidor tras una petición exitosa.
  ///
  /// Args:
  ///   - `response` (Response): Datos y estado devueltos por el servidor.
  ///   - `handler` (ResponseInterceptorHandler): Manejador para continuar el procesamiento de la respuesta.
  ///
  /// Returns:
  ///   - `void`
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri.toString();
    final statusCode = response.statusCode;
    _logService.info('HTTP [IN] $statusCode <-$uri');
    super.onResponse(response, handler);
  }

  /// Captura y registra los errores ocurridos durante el procesamiento de la petición de red.
  ///
  /// Args:
  ///   - `err` (DioException): Excepción o error devuelto por Dio durante la comunicación.
  ///   - `handler` (ErrorInterceptorHandler): Manejador para continuar la propagación del error.
  ///
  /// Returns:
  ///   - `void`
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final uri = err.requestOptions.uri.toString();
    final method = err.requestOptions.method;
    final statusCode = err.response?.statusCode;

    final errorMessage =
        'HTTP [ERR] $method$uri (Status: ${statusCode ?? "N/A"}) - ${err.message}';
    _logService.error(errorMessage, err.error ?? err, err.stackTrace);

    super.onError(err, handler);
  }
}
