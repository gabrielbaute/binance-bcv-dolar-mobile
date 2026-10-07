import 'package:flutter/foundation.dart';

import '../enums/log_level.dart';
import '../models/log_entry.dart';
import '../services/log_service.dart';

/// Proveedor de estado que expone la historia de logs, gestión de filtros y acciones para la UI.
///
/// Attributes:
///   - `_logService` (LogService): Instancia del servicio centralizado de logs.
///   - `_selectedFilter` (LogLevel?): Nivel de severidad seleccionado para filtrar el historial.
///
/// Returns:
///   - `LogsProvider`: Instancia del proveedor encargado de la gestión de estado de los registros.
class LogsProvider extends ChangeNotifier {
  final LogService _logService;
  LogLevel? _selectedFilter;

  /// Crea una instancia de [LogsProvider] vinculada al servicio de logs.
  ///
  /// Args:
  ///   - `logService` (LogService?): Instancia opcional de [LogService] para inyección de dependencias.
  LogsProvider({LogService? logService})
    : _logService = logService ?? LogService() {
    _logService.addListener(notifyListeners);
  }

  /// Nivel de severidad actualmente seleccionado como filtro. Si es null, muestra todos.
  ///
  /// Returns:
  ///   - `LogLevel?`: El nivel de log activo o null si se muestran todos.
  LogLevel? get selectedFilter => _selectedFilter;

  /// Lista inmutable de registros de eventos almacenados sin aplicar filtro.
  ///
  /// Returns:
  ///   - `List<LogEntry>`: Colección completa de logs en memoria.
  List<LogEntry> get logs => _logService.logs;

  /// Lista de registros filtrada según el nivel de severidad seleccionado.
  ///
  /// Returns:
  ///   - `List<LogEntry>`: Colección de logs que coinciden con el filtro activo.
  List<LogEntry> get filteredLogs {
    if (_selectedFilter == null) {
      return logs;
    }
    return logs.where((entry) => entry.level == _selectedFilter).toList();
  }

  /// Indica si la lista de logs filtrados está vacía.
  ///
  /// Returns:
  ///   - `bool`: Verdadero si no hay elementos en la vista filtrada actual.
  bool get isEmpty => filteredLogs.isEmpty;

  /// Actualiza el filtro de severidad activo y notifica a los oyentes.
  ///
  /// Args:
  ///   - `level` (LogLevel?): Nivel de severidad a filtrar, o null para remover el filtro.
  ///
  /// Returns:
  ///   - `void`
  void setFilter(LogLevel? level) {
    if (_selectedFilter == level) return;
    _selectedFilter = level;
    notifyListeners();
  }

  /// Obtiene todo el historial de logs concatenado y formateado como texto plano.
  ///
  /// Returns:
  ///   - `String`: Cadena de texto lista para ser copiada o compartida.
  String getFormattedLogs() {
    return _logService.exportLogsText();
  }

  /// Limpia todo el historial de registros acumulados.
  ///
  /// Returns:
  ///   - `void`
  void clearLogs() {
    _logService.clear();
  }

  @override
  void dispose() {
    _logService.removeListener(notifyListeners);
    super.dispose();
  }
}
