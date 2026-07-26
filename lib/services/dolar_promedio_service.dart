import '../models/dolar_response.dart';
import '../models/dolar_realtime_response.dart';
import 'api_client_service.dart';
import 'api_endpoints.dart';

/// Servicio para operaciones relacionadas con el Dólar Promedio.
///
/// Proporciona métodos para obtener el promedio entre las tasas del BCV
/// y Binance P2P para el par USDT/VES.
class DolarPromedioService {
  final ApiClient _apiClient;

  DolarPromedioService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Obtiene el promedio entre las tasas del BCV y Binance P2P
  /// a partir del último registro guardado en base de datos.
  ///
  /// Retorna un [DolarResponse] con los valores de USD y EUR del BCV,
  /// el valor de USDT en Binance P2P, y el promedio entre USD_BCV y USDT,
  /// o `null` si no hay datos disponibles.
  Future<DolarResponse?> getDolarPromedio() async {
    final responseData = await _apiClient.get(ApiEndpoints.dolarPromedio);
    if (responseData.isEmpty) {
      return null;
    }
    return DolarResponse.fromJson(responseData);
  }

  /// Obtiene el promedio en tiempo real entre las tasas del BCV y Binance P2P.
  ///
  /// Retorna un [RealTimeDolarResponse] con los valores de USD y EUR del BCV,
  /// el valor de USDT en Binance P2P, y el promedio entre USD_BCV y USDT.
  Future<RealTimeDolarResponse> getRealTimeDolarPromedio() async {
    final responseData = await _apiClient.get(
      ApiEndpoints.dolarPromedioRealTime,
    );
    return RealTimeDolarResponse.fromJson(responseData);
  }
}
