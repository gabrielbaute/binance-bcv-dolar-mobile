/// Clase para manejo de las rutas de conexión a la API
/// Inyecta baseUrl como variable de entorno.
class ApiEndpoints {
  // Constructor. Previene la instanciación.
  ApiEndpoints._();

  // --- Base URL ---
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://dolar-vzla.rafnixg.dev',
  );

  // --- Health / Server info ---
  static const String healthCheck = '/api/v1/health';

  // --- BCV ---
  static const String bcvRealTime = '/api/v1/bcv/realtime';
  static const String bcvDolar = '/api/v1/bcv/dolar';
  static const String bcvEuro = '/api/v1/bcv/euro';
  static const String bcvQuery = '/api/v1/bcv/query';
  static const String bcvAll = '/api/v1/bcv/all';

  // --- Dolar Promedio ---
  static const String dolarPromedio = '/api/v1/dolar/dolar_promedio';
  static const String dolarPromedioRealTime =
      '/api/v1/dolar/realtime_dolar_promedio';

  // --- Binance ---
  static const String binanceRealTimeVES = '/api/v1/binance/realtime_ves';
  static const String binanceRealTimePair = '/api/v1/binance/real_time_pair';
  static const String binanceVesUsdtPair = '/api/v1/binance/ves_usdt_pair';
  static const String binancePairLastRecord =
      '/api/v1/binance/pairs_last_record';

  // --- History ---
  static const String historyBCV = '/api/v1/history/bcv';
  static const String historyBinance = '/api/v1/history/binance';
  static const String historyFiatPair = '/api/v1/history/fiat-pair';

  // --- Remesas/Arbitraje ---
  static const String arbitragePair = '/api/v1/arbitrage/pair';
  static const String arbitrageRealTimePair =
      '/api/v1/arbitrage/real_time_pair';
}
