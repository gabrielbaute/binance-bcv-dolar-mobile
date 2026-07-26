import 'package:flutter/foundation.dart';
import '../enums/bcv_currencies.dart';
import '../enums/binance_assets.dart';
import '../enums/fiat_currencies.dart';
import '../enums/trade_type.dart';
import '../models/bcv_currency_list_response.dart';
import '../models/binance_currency_list_response.dart';
import '../services/history_service.dart';
import '../errors/api_exceptions.dart';

/// Provider encargado de gestionar el estado, filtros y caché para la vista de Historiales.
///
/// Attributes:
///   - _historyService (HistoryService): Servicio para la consulta de históricos de tasas.
///   - _bcvDolarHistory (BCVCurrencyListResponse?): Contenedor de registros históricos para el Dólar BCV.
///   - _bcvEuroHistory (BCVCurrencyListResponse?): Contenedor de registros históricos para el Euro BCV.
///   - _binanceUsdtHistory (BinanceCurrencyListResponse?): Contenedor de registros históricos para USDT/VES Buy en Binance.
///   - _isLoading (bool): Estado que indica si la carga de históricos está en proceso.
///   - _errorMessage (String?): Mensaje de error en caso de fallo en la petición.
///   - _lastFetchTime (DateTime?): Marca de tiempo de la última actualización exitosa.
class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService;

  BCVCurrencyListResponse? _bcvDolarHistory;
  BCVCurrencyListResponse? _bcvEuroHistory;
  BinanceCurrencyListResponse? _binanceUsdtHistory;

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchTime;

  /// Constructor de HistoryProvider.
  ///
  /// Args:
  ///   historyService (HistoryService?): Instancia opcional del servicio de historial para inyección.
  HistoryProvider({HistoryService? historyService})
    : _historyService = historyService ?? HistoryService();

  BCVCurrencyListResponse? get bcvDolarHistory => _bcvDolarHistory;
  BCVCurrencyListResponse? get bcvEuroHistory => _bcvEuroHistory;
  BinanceCurrencyListResponse? get binanceUsdtHistory => _binanceUsdtHistory;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastFetchTime => _lastFetchTime;

  /// Carga simultáneamente el historial de Dólar BCV, Euro BCV y Binance USDT/VES Buy aplicando caché en memoria.
  ///
  /// Args:
  ///   forceRefresh (bool): Si es true, ignora la caché local y consulta nuevamente la API. Por defecto es false.
  ///   startDate (DateTime?): Fecha inicial opcional para filtrar los registros históricos.
  ///   endDate (DateTime?): Fecha final opcional para filtrar los registros históricos.
  ///   skip (int): Cantidad de registros a omitir para paginación. Por defecto es 0.
  ///   limit (int): Límite máximo de registros a retornar por consulta. Por defecto es 100.
  ///
  /// Returns:
  ///   Future<void>: Operación asíncrona completada.
  ///
  /// Raises:
  ///   ApiException: Excepción capturada e interpretada en errorMessage.
  Future<void> fetchAllHistory({
    bool forceRefresh = false,
    DateTime? startDate,
    DateTime? endDate,
    int skip = 0,
    int limit = 100,
  }) async {
    if (!forceRefresh &&
        _bcvDolarHistory != null &&
        _bcvEuroHistory != null &&
        _binanceUsdtHistory != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _historyService.getHistoryBcv(
          currency: BcvCurrency.dolar,
          tradeType: TradeType.sell,
          startDate: startDate,
          endDate: endDate,
          skip: skip,
          limit: limit,
        ),
        _historyService.getHistoryBcv(
          currency: BcvCurrency.euro,
          tradeType: TradeType.sell,
          startDate: startDate,
          endDate: endDate,
          skip: skip,
          limit: limit,
        ),
        _historyService.getHistoryBinance(
          fiat: FiatCurrency.ves,
          asset: BinanceAsset.usdt,
          tradeType: TradeType.buy,
          startDate: startDate,
          endDate: endDate,
          skip: skip,
          limit: limit,
        ),
      ]);

      _bcvDolarHistory = results[0] as BCVCurrencyListResponse;
      _bcvEuroHistory = results[1] as BCVCurrencyListResponse;
      _binanceUsdtHistory = results[2] as BinanceCurrencyListResponse;
      _lastFetchTime = DateTime.now();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error imprevisto al cargar los historiales: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpia la caché en memoria y resetea todos los datos históricos almacenados.
  ///
  /// Returns:
  ///   void
  void clearCache() {
    _bcvDolarHistory = null;
    _bcvEuroHistory = null;
    _binanceUsdtHistory = null;
    _lastFetchTime = null;
    _errorMessage = null;
    notifyListeners();
  }
}
