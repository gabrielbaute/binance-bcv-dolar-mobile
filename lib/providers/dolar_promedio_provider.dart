import 'package:flutter/foundation.dart';
import '../models/dolar_response.dart';
import '../services/dolar_promedio_service.dart';
import '../errors/api_exceptions.dart';

/// Provider encargado de gestionar el estado y la caché para la vista de Dólar Promedio.
///
/// Attributes:
///   - _dolarService (DolarPromedioService): Servicio para la obtención de datos del dólar promedio.
///   - _dolarData (DolarResponse?): Objeto en memoria que almacena las tasas de USDT/VES Buy, Dólar BCV, Euro BCV y Promedio.
///   - _isLoading (bool): Estado que indica si la petición HTTP está en curso.
///   - _errorMessage (String?): Mensaje descriptivo de error en caso de fallas en la llamada.
///   - _lastFetchTime (DateTime?): Marca de tiempo de la última actualización de datos.
class DolarPromedioProvider extends ChangeNotifier {
  final DolarPromedioService _dolarService;

  DolarResponse? _dolarData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchTime;

  /// Constructor de DolarPromedioProvider.
  ///
  /// Args:
  ///   dolarService (DolarPromedioService?): Instancia del servicio de dólar promedio opcional.
  DolarPromedioProvider({DolarPromedioService? dolarService})
    : _dolarService = dolarService ?? DolarPromedioService();

  DolarResponse? get dolarData => _dolarData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastFetchTime => _lastFetchTime;

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
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error imprevisto al consultar el dólar promedio: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Borra el estado y la caché guardados en memoria.
  ///
  /// Returns:
  ///   void
  void clearCache() {
    _dolarData = null;
    _lastFetchTime = null;
    _errorMessage = null;
    notifyListeners();
  }
}
