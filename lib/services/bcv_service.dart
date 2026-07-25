import '../models/bcv_currency_realtime_response.dart';
import '../models/bcv_currency_response.dart';
import '../models/bcv_response.dart';
import 'api_client_service.dart';
import 'api_endpoints.dart';

/// Servicio para operaciones relacionadas con el BCV (Banco Central de Venezuela).
///
/// Proporciona métodos para obtener tasas de cambio oficiales del BCV,
/// tanto en tiempo real como históricas.
class BcvService {
  final ApiClient _apiClient;

  BcvService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Obtiene las tasas de cambio en tiempo real del BCV para Dólar y Euro.
  ///
  /// Retorna una lista de [BCVCurrencyRealTimeResponse] con las tasas
  /// actuales del Dólar y el Euro.
  Future<List<BCVCurrencyRealTimeResponse>> getRealTimeBcv() async {
    final responseData = await _apiClient.get(ApiEndpoints.bcvRealTime);
    final List<dynamic> data = responseData as List<dynamic>;
    return data
        .map(
          (e) =>
              BCVCurrencyRealTimeResponse.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  /// Obtiene la tasa de cambio histórica del Dólar.
  ///
  /// Retorna un [BCVCurrencyResponse] con la tasa del Dólar,
  /// o `null` si no hay datos disponibles.
  Future<BCVCurrencyResponse?> getDolar() async {
    final responseData = await _apiClient.get(ApiEndpoints.bcvDolar);
    if (responseData.isEmpty) {
      return null;
    }
    return BCVCurrencyResponse.fromJson(responseData);
  }

  /// Obtiene la tasa de cambio histórica del Euro.
  ///
  /// Retorna un [BCVCurrencyResponse] con la tasa del Euro,
  /// o `null` si no hay datos disponibles.
  Future<BCVCurrencyResponse?> getEuro() async {
    final responseData = await _apiClient.get(ApiEndpoints.bcvEuro);
    if (responseData.isEmpty) {
      return null;
    }
    return BCVCurrencyResponse.fromJson(responseData);
  }

  /// Obtiene la tasa de cambio histórica de una moneda específica.
  ///
  /// [currency] es la moneda a consultar (DOLAR, EURO, YUAN, LIRA, RUBLO).
  ///
  /// Retorna un [BCVCurrencyResponse] con la tasa de la moneda,
  /// o `null` si no hay datos disponibles.
  Future<BCVCurrencyResponse?> getQuery(String currency) async {
    final responseData = await _apiClient.get(
      ApiEndpoints.bcvQuery,
      queryParameters: {'currency': currency},
    );
    if (responseData.isEmpty) {
      return null;
    }
    return BCVCurrencyResponse.fromJson(responseData);
  }

  /// Obtiene todas las tasas de cambio históricas del BCV.
  ///
  /// Retorna un [BCVResponse] con todas las monedas (Dólar, Euro, Yuan,
  /// Lira, Rublo).
  Future<BCVResponse?> getAll() async {
    final responseData = await _apiClient.get(ApiEndpoints.bcvAll);
    if (responseData.isEmpty) {
      return null;
    }
    return BCVResponse.fromJson(responseData);
  }
}
