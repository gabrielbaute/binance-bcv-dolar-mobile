import 'package:flutter/foundation.dart';
import '../enums/currency_mode.dart';
import '../models/calculator_result.dart';
import '../models/dolar_realtime_response.dart';
import '../services/calculator_service.dart';
import '../services/dolar_promedio_service.dart';
import '../errors/api_exceptions.dart';

/// Provider encargado de gestionar el estado, la caché y los cálculos para la vista en Tiempo Real.
///
/// Attributes:
///   - _dolarService (DolarPromedioService): Servicio para la consulta de datos en tiempo real.
///   - _calculatorService (CalculatorService): Servicio para realizar los cálculos de conversión.
///   - _realtimeData (RealTimeDolarResponse?): Objeto en memoria que almacena las tasas en tiempo real.
///   - _isLoading (bool): Estado que indica si la consulta HTTP está en progreso.
///   - _errorMessage (String?): Mensaje de error en caso de fallo en la petición.
///   - _lastFetchTime (DateTime?): Marca de tiempo de la última consulta realizada.
///   - _calculatorAmount (double): Monto actual ingresado en la calculadora.
///   - _calculatorMode (CurrencyMode): Moneda origen seleccionada en la calculadora (USD o VES).
///   - _calculatorResult (CalculatorResult): Resultados calculados en tiempo real.
class RealtimeProvider extends ChangeNotifier {
  final DolarPromedioService _dolarService;
  final CalculatorService _calculatorService;

  RealTimeDolarResponse? _realtimeData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchTime;

  double _calculatorAmount = 0.0;
  CurrencyMode _calculatorMode = CurrencyMode.usd;
  CalculatorResult _calculatorResult = CalculatorResult.zero();

  /// Constructor de RealtimeProvider.
  ///
  /// Args:
  ///   dolarService (DolarPromedioService?): Instancia opcional del servicio de dólar para inyección.
  ///   calculatorService (CalculatorService?): Instancia opcional del servicio de calculadora para inyección.
  RealtimeProvider({
    DolarPromedioService? dolarService,
    CalculatorService? calculatorService,
  }) : _dolarService = dolarService ?? DolarPromedioService(),
       _calculatorService = calculatorService ?? CalculatorService();

  RealTimeDolarResponse? get realtimeData => _realtimeData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastFetchTime => _lastFetchTime;

  double get calculatorAmount => _calculatorAmount;
  CurrencyMode get calculatorMode => _calculatorMode;
  CalculatorResult get calculatorResult => _calculatorResult;

  /// Carga los datos en tiempo real respetando el almacenamiento en caché.
  ///
  /// Args:
  ///   forceRefresh (bool): Si es true, ignora la caché local y consulta la API en tiempo real. Por defecto es false.
  ///
  /// Returns:
  ///   Future<void>: Operación asíncrona completada.
  ///
  /// Raises:
  ///   ApiException: Excepción capturada e interpretada en errorMessage.
  Future<void> fetchRealtimeData({bool forceRefresh = false}) async {
    if (!forceRefresh && _realtimeData != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _realtimeData = await _dolarService.getRealTimeDolarPromedio();
      _lastFetchTime = DateTime.now();
      _recalculate();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error imprevisto al consultar datos en tiempo real: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza el monto en la calculadora y recalcula las conversiones.
  ///
  /// Args:
  ///   amount (double): Nuevo monto ingresado por el usuario.
  ///
  /// Returns:
  ///   void
  void setCalculatorAmount(double amount) {
    _calculatorAmount = amount;
    _recalculate();
    notifyListeners();
  }

  /// Cambia la moneda origen de la calculadora (USD/VES) y recalcula las conversiones.
  ///
  /// Args:
  ///   mode (CurrencyMode): Nuevo modo de moneda a establecer.
  ///
  /// Returns:
  ///   void
  void setCalculatorMode(CurrencyMode mode) {
    _calculatorMode = mode;
    _recalculate();
    notifyListeners();
  }

  /// Limpia los campos de la calculadora.
  ///
  /// Returns:
  ///   void
  void resetCalculator() {
    _calculatorAmount = 0.0;
    _calculatorResult = CalculatorResult.zero();
    notifyListeners();
  }

  /// Limpia la caché en memoria y resetea el estado del provider.
  ///
  /// Returns:
  ///   void
  void clearCache() {
    _realtimeData = null;
    _lastFetchTime = null;
    _errorMessage = null;
    resetCalculator();
  }

  /// Ejecuta el recálculo interno invocando al CalculatorService con los datos en tiempo real.
  ///
  /// Returns:
  ///   void
  void _recalculate() {
    if (_realtimeData == null) {
      _calculatorResult = CalculatorResult.zero();
      return;
    }

    _calculatorResult = _calculatorService.calculate(
      amount: _calculatorAmount,
      mode: _calculatorMode,
      bcvDolarRate: _realtimeData?.bcvDolar?.rate,
      binanceUsdtRate: _realtimeData?.binanceUsdtVesBuy?.averagePrice,
      bcvEuroRate: _realtimeData?.bcvEuro?.rate,
      averageRate: _realtimeData?.averageUsdtVes,
    );
  }
}
