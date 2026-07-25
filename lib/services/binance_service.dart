import '../enums/binance_assets.dart';
import '../enums/fiat_currencies.dart';
import '../enums/trade_type.dart';
import '../models/binance_currency_response.dart';
import '../models/binance_realtime_response.dart';
import 'api_client_service.dart';
import 'api_endpoints.dart';

/// Servicio para operaciones relacionadas con Binance P2P.
///
/// Proporciona métodos para obtener tasas de cambio del mercado P2P de Binance,
/// tanto en tiempo real como históricas.
class BinanceService {
  final ApiClient _apiClient;

  BinanceService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Obtiene la tasa de cambio promedio en tiempo real del par USDT/VES
  /// en el mercado P2P de Binance.
  ///
  /// Retorna un [BinanceRealTimeResponse] con los datos del par USDT/VES,
  /// o `null` si no hay datos disponibles.
  Future<BinanceRealTimeResponse?> getRealTimeVes() async {
    final responseData = await _apiClient.get(ApiEndpoints.binanceRealTimeVES);
    if (responseData.isEmpty) {
      return null;
    }
    return BinanceRealTimeResponse.fromJson(responseData);
  }

  /// Obtiene la tasa de cambio promedio en tiempo real para un par específico
  /// en el mercado P2P de Binance.
  ///
  /// [fiat] es la moneda fiat local (VES, PEN, etc.).
  /// [asset] es el activo cripto (USDT por defecto).
  /// [tradeType] es el tipo de operación (BUY o SELL).
  ///
  /// Retorna un [BinanceRealTimeResponse] con los datos del par solicitado,
  /// o `null` si no hay datos disponibles.
  Future<BinanceRealTimeResponse?> getRealTimePair({
    required FiatCurrency fiat,
    BinanceAsset asset = BinanceAsset.usdt,
    TradeType tradeType = TradeType.buy,
  }) async {
    final responseData = await _apiClient.get(
      ApiEndpoints.binanceRealTimePair,
      queryParameters: {
        'fiat': fiat.value,
        'asset': asset.value,
        'trade_type': tradeType.value,
      },
    );
    if (responseData.isEmpty) {
      return null;
    }
    return BinanceRealTimeResponse.fromJson(responseData);
  }

  /// Obtiene los últimos registros guardados en base de datos para el par
  /// VES/USDT en ambos tipos de operación (BUY y SELL).
  ///
  /// Retorna una lista de [BinanceCurrencyResponse] con dos elementos:
  /// - Índice 0: Registro SELL.
  /// - Índice 1: Registro BUY.
  Future<List<BinanceCurrencyResponse?>> getVesUsdtPair() async {
    final responseData = await _apiClient.get(ApiEndpoints.binanceVesUsdtPair);
    final List<dynamic> data = responseData as List<dynamic>;
    return data.map((e) {
      if (e == null) return null;
      return BinanceCurrencyResponse.fromJson(e as Map<String, dynamic>);
    }).toList();
  }

  /// Obtiene los últimos registros guardados en base de datos para un par
  /// específico en ambos tipos de operación (BUY y SELL).
  ///
  /// [fiat] es la moneda fiat local (VES, PEN, etc.).
  /// [asset] es el activo cripto (USDT por defecto).
  ///
  /// Retorna una lista de [BinanceCurrencyResponse] con dos elementos:
  /// - Índice 0: Registro SELL.
  /// - Índice 1: Registro BUY.
  Future<List<BinanceCurrencyResponse?>> getPairsLastRecord({
    required FiatCurrency fiat,
    BinanceAsset asset = BinanceAsset.usdt,
  }) async {
    final responseData = await _apiClient.get(
      ApiEndpoints.binancePairLastRecord,
      queryParameters: {'fiat': fiat.value, 'asset': asset.value},
    );
    final List<dynamic> data = responseData as List<dynamic>;
    return data.map((e) {
      if (e == null) return null;
      return BinanceCurrencyResponse.fromJson(e as Map<String, dynamic>);
    }).toList();
  }
}
