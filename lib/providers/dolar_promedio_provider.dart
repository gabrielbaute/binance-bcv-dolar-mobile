import 'package:flutter/foundation.dart';
import '../enums/currency_mode.dart';
import '../models/calculator_result.dart';
import '../models/dolar_response.dart';
import '../services/calculator_service.dart';
import '../services/dolar_promedio_service.dart';
import '../errors/api_exceptions.dart';

/// Provider encargado de gestionar el estado, la caché y la calculadora para la vista de Dólar Promedio.
///
/// Attributes:
///   - _dolarService (DolarPromedioService): Servicio para la obtención de datos del dólar promedio.
///   - _calculatorService (CalculatorService): Servicio para realizar los cálculos de conversión.
///   - _dolarData (DolarResponse?): Objeto en memoria que almacena las tasas actuales.
///   - _isLoading (bool): Estado que indica si la petición HTTP está en curso.
///   - _errorMessage (String?): Mensaje descriptivo de error en caso de fallas.
///   - _lastFetchTime (DateTime?): Marca de tiempo de la última actualización.
///   - _calculatorAmount (double): Monto actual ingresado en la calculadora.
///   - _calculatorMode (CurrencyMode): Moneda origen seleccionada en la calculadora (USD o VES).
///   - _calculatorResult (CalculatorResult): Resultados calculados en tiempo real.
class DolarPromedioProvider extends ChangeNotifier {
  final DolarPromedioService _dolarService;
  final CalculatorService _calculatorService;

  DolarResponse? _dolarData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchTime;

  double _calculatorAmount = 0.0;
  CurrencyMode _calculatorMode = CurrencyMode.usd;
  CalculatorResult _calculatorResult = CalculatorResult.zero();

  /// Constructor de DolarPromedioProvider.
  ///
  /// Args:
  ///   dolarService (DolarPromedioService?): Instancia del servicio de dólar promedio opcional.
  ///   calculatorService (CalculatorService?): Instancia del servicio de calculadora opcional.
  DolarPromedioProvider({
    DolarPromedioService? dolarService,
    CalculatorService? calculatorService,
  }) : _dolarService = dolarService ?? DolarPromedioService(),
       _calculatorService = calculatorService ?? CalculatorService();

  DolarResponse? get dolarData => _dolarData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastFetchTime => _lastFetchTime;

  double get calculatorAmount => _calculatorAmount;
  CurrencyMode get calculatorMode => _calculatorMode;
  CalculatorResult get calculatorResult => _calculatorResult;

  /// Carga los datos del dólar promedio aplicando almacenamiento en caché en memoria.
  ///
  /// Args:
  ///   forceRefresh (bool): Si es true, omite la caché y realiza una consulta HTTP. Por defecto es false.
  ///
  /// Returns:
  ///   Future[void]: Operación asíncrona completada.
  ///
  /// Raises:
  ///   ApiException: Excepción capturada internamente y expuesta vía errorMessage.
  Future<void> fetchDolarPromedio({bool forceRefresh = false}) async {
    if (!forceRefresh && _dolarData != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dolarData = await _dolarService.getDolarPromedio();
      _lastFetchTime = DateTime.now();
      _recalculate();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error imprevisto al consultar el dólar promedio: $e';
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

  /// Borra el estado de la API y la caché guardada en memoria.
  ///
  /// Returns:
  ///   void
  void clearCache() {
    _dolarData = null;
    _lastFetchTime = null;
    _errorMessage = null;
    resetCalculator();
  }

  /// Ejecuta el recálculo interno invocando al CalculatorService con los datos actuales.
  ///
  /// Returns:
  ///   void
  void _recalculate() {
    if (_dolarData == null) {
      _calculatorResult = CalculatorResult.zero();
      return;
    }

    _calculatorResult = _calculatorService.calculate(
      amount: _calculatorAmount,
      mode: _calculatorMode,
      bcvDolarRate: _dolarData?.bcvDolar?.rate,
      binanceUsdtRate: _dolarData?.binanceUsdtVesBuy?.averagePrice,
      bcvEuroRate: _dolarData?.bcvEuro?.rate,
      averageRate: _dolarData?.averageUsdtVes,
    );
  }
}
