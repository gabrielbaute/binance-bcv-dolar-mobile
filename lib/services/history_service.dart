import '../enums/binance_assets.dart';
import '../enums/bcv_currencies.dart';
import '../enums/fiat_currencies.dart';
import '../enums/trade_type.dart';
import '../models/bcv_currency_list_response.dart';
import '../models/binance_currency_list_response.dart';
import '../models/fiat_pair_response.dart';
import 'api_client_service.dart';
import 'api_endpoints.dart';

/// Servicio para operaciones de histórico.
///
/// Proporciona métodos para obtener registros históricos de tasas de cambio
/// del BCV, Binance P2P y pares de monedas fiat.
class HistoryService {
  final ApiClient _apiClient;

  HistoryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Obtiene el histórico de tasas del BCV para una moneda específica.
  ///
  /// [currency] es la moneda a consultar (DOLAR, EURO, YUAN, LIRA, RUBLO).
  /// [tradeType] es el tipo de operación (BUY, SELL).
  /// [startDate] es la fecha de inicio (opcional).
  /// [endDate] es la fecha de fin (opcional).
  /// [skip] es el número de registros a saltar (paginación).
  /// [limit] es el número máximo de registros a retornar.
  ///
  /// Retorna un [BCVCurrencyListResponse] con los registros históricos.
  Future<BCVCurrencyListResponse> getHistoryBcv({
    BcvCurrency currency = BcvCurrency.dolar,
    TradeType tradeType = TradeType.sell,
    DateTime? startDate,
    DateTime? endDate,
    int skip = 0,
    int limit = 100,
  }) async {
    final Map<String, dynamic> queryParams = {
      'currency': currency.value,
      'trade_type': tradeType.value,
      'skip': skip,
      'limit': limit,
    };

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    final responseData = await _apiClient.get(
      ApiEndpoints.historyBCV,
      queryParameters: queryParams,
    );
    return BCVCurrencyListResponse.fromJson(responseData);
  }

  /// Obtiene el histórico de tasas de Binance P2P para un par específico.
  ///
  /// [fiat] es la moneda fiat (VES, PEN, COP, etc.).
  /// [asset] es el activo cripto (USDT, BTC, etc.).
  /// [tradeType] es el tipo de operación (BUY, SELL).
  /// [startDate] es la fecha de inicio (opcional).
  /// [endDate] es la fecha de fin (opcional).
  /// [skip] es el número de registros a saltar (paginación).
  /// [limit] es el número máximo de registros a retornar.
  ///
  /// Retorna un [BinanceCurrencyListResponse] con los registros históricos.
  Future<BinanceCurrencyListResponse> getHistoryBinance({
    FiatCurrency fiat = FiatCurrency.ves,
    BinanceAsset asset = BinanceAsset.usdt,
    TradeType tradeType = TradeType.buy,
    DateTime? startDate,
    DateTime? endDate,
    int skip = 0,
    int limit = 100,
  }) async {
    final Map<String, dynamic> queryParams = {
      'fiat': fiat.value,
      'asset': asset.value,
      'trade_type': tradeType.value,
      'skip': skip,
      'limit': limit,
    };

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    final responseData = await _apiClient.get(
      ApiEndpoints.historyBinance,
      queryParameters: queryParams,
    );
    return BinanceCurrencyListResponse.fromJson(responseData);
  }

  /// Obtiene el histórico de tasas cruzadas entre dos monedas fiat.
  ///
  /// [fiat1] es la moneda fiat origen.
  /// [fiat2] es la moneda fiat destino.
  /// [startDate] es la fecha de inicio (obligatoria).
  /// [endDate] es la fecha de fin (obligatoria).
  /// [skip] es el número de registros a saltar (paginación).
  /// [limit] es el número máximo de registros a retornar.
  ///
  /// Retorna una lista de [FiatPairResponse] con los registros históricos.
  ///
  /// **ADVERTENCIA**: Este endpoint es experimental y puede no ser preciso.
  Future<List<FiatPairResponse>> getHistoryFiatPair({
    required FiatCurrency fiat1,
    required FiatCurrency fiat2,
    required DateTime startDate,
    required DateTime endDate,
    int skip = 0,
    int limit = 100,
  }) async {
    final responseData = await _apiClient.get(
      ApiEndpoints.historyFiatPair,
      queryParameters: {
        'fiat_1': fiat1.value,
        'fiat_2': fiat2.value,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'skip': skip,
        'limit': limit,
      },
    );
    final List<dynamic> data = responseData as List<dynamic>;
    return data
        .map((e) => FiatPairResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}