import 'package:flutter/foundation.dart';
import '../models/dolar_realtime_response.dart';
import '../services/dolar_promedio_service.dart';
import '../errors/api_exceptions.dart';

/// Provider encargado de gestionar el estado y la caché para la vista en Tiempo Real.
///
/// Attributes:
///   - _dolarService (DolarPromedioService): Servicio para la consulta de datos en tiempo real.
///   - _realtimeData (RealTimeDolarResponse?): Objeto en memoria que almacena las tasas en tiempo real.
///   - _isLoading (bool): Estado que indica si la consulta HTTP está en progreso.
///   - _errorMessage (String?): Mensaje de error en caso de fallo en la petición.
///   - _lastFetchTime (DateTime?): Marca de tiempo de la última consulta realizada.
class RealtimeProvider extends ChangeNotifier {
  final DolarPromedioService _dolarService;

  RealTimeDolarResponse? _realtimeData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchTime;

  /// Constructor de RealtimeProvider.
  ///
  /// Args:
  ///   dolarService (DolarPromedioService?): Instancia opcional del servicio para inyección de dependencias.
  RealtimeProvider({DolarPromedioService? dolarService})
    : _dolarService = dolarService ?? DolarPromedioService();

  RealTimeDolarResponse? get realtimeData => _realtimeData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastFetchTime => _lastFetchTime;

  /// Carga los datos en tiempo real respetando el almacenamiento en caché.
  ///
  /// Args:
  ///   forceRefresh (bool): Si es true, ignora la caché local y consulta la API en tiempo real. Por defecto es false.
  ///
  /// Returns:
  ///   Future[void]: Operación asíncrona completada.
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
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error imprevisto al consultar datos en tiempo real: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpia la caché en memoria y resetea el estado del provider.
  ///
  /// Returns:
  ///   void
  void clearCache() {
    _realtimeData = null;
    _lastFetchTime = null;
    _errorMessage = null;
    notifyListeners();
  }
}
