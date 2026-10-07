import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'logging_interceptor_service.dart';
import '../errors/api_exceptions.dart';

/// Cliente HTTP de bajo nivel para consumir la API.
///
/// Encargado únicamente de la capa de transporte y normalización de errores.
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  /// Fábrica para obtener la instancia singleton.
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());
  }

  /// Realiza una petición GET genérica.
  ///
  /// Args:
  ///   - `endpoint` (String): Ruta relativa del endpoint a consultar.
  ///   - `queryParameters` (Map&lt;String, dynamic&gt;?): Parámetros de consulta opcionales para la URL.
  ///
  /// Returns:
  ///   - `Future<dynamic>`: Respuesta devuelta por el servidor tras la petición.
  ///
  /// Raises:
  ///   - `ApiException`: Si ocurre un error durante la comunicación de red o en el servidor.
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _validateAndParse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Valida el código de estado HTTP y retorna los datos crudos.
  dynamic _validateAndParse(Response response) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode >= 200 && statusCode < 300) {
      return response.data;
    }

    throw ApiException(
      message: 'Error en la respuesta del servidor (${response.statusMessage})',
      statusCode: statusCode,
      body: response.data?.toString(),
    );
  }

  /// Procesa las excepciones generadas por Dio y las transforma en excepciones del dominio [ApiException].
  ///
  /// Args:
  ///   - `error` (DioException): Excepción capturada durante la ejecución de una petición.
  ///
  /// Returns:
  ///   - `ApiException`: Excepción transformada adecuada para ser gestionada por los repositorios.
  ApiException _handleDioError(DioException error) {
    String message;
    int statusCode = error.response?.statusCode ?? 500;
    String? body = error.response?.data?.toString();

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Tiempo de espera de conexión agotado';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Tiempo de espera de envío agotado';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Tiempo de espera de respuesta agotado';
        break;
      case DioExceptionType.badResponse:
        // Intenta extraer el mensaje descriptivo retornado por FastAPI/Flask en el JSON
        if (error.response?.data is Map &&
            error.response?.data['detail'] != null) {
          message =
              error.response?.data['detail'].toString() ??
              'Error en la petición';
        } else if (error.response?.data is Map &&
            error.response?.data['message'] != null) {
          message =
              error.response?.data['message'].toString() ??
              'Error en la petición';
        } else {
          message =
              error.response?.statusMessage ?? 'Respuesta fallida del servidor';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Petición cancelada';
        break;
      case DioExceptionType.connectionError:
        message = 'Error de conexión a internet o servidor inalcanzable';
        break;
      default:
        message = 'Error imprevisto de red: ${error.message}';
    }

    return ApiException(message: message, statusCode: statusCode, body: body);
  }
}
