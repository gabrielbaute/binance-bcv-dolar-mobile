import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../enums/log_level.dart';
import '../models/log_entry.dart';

/// Servicio centralizado que gestiona las entradas de registro mediante almacenamiento en búfer circular en memoria.
///
/// Attributes:
///   - `_instance` (LogService): Instancia singleton del servicio.
///   - `_maxLogs` (int): Número máximo de entradas de registro conservadas en memoria.
///   - `_logs` (List&lt;LogEntry&gt;): Lista interna que almacena entradas de registro acumuladas.
///
/// Args:
///   - `maxLogs` (int?): Límite de capacidad opcional para el búfer circular. El valor predeterminado es 200.
///
/// Returns:
///   - `LogService`: La instancia singleton del servicio de registro.
class LogService extends ChangeNotifier {
  static final LogService _instance = LogService._internal();

  factory LogService() => _instance;

  LogService._internal();

  static const int _maxLogs = 200;
  final List<LogEntry> _logs = [];

  /// Gets an unmodifiable view of the accumulated log entries.
  ///
  /// Returns:
  ///   - `List<LogEntry>`: Read-only list of log entries stored in memory.
  List<LogEntry> get logs => List.unmodifiable(_logs);

  /// Records a fine-grained trace message for detailed step-by-step logging.
  ///
  /// Args:
  ///   - `message` (String): Descriptive text detailing the verbose event.
  ///
  /// Returns:
  ///   - `void`
  void verbose(String message) {
    _addLog(LogEntry(message: message, level: LogLevel.verbose));
  }

  /// Records a diagnostic message intended for debugging during development.
  ///
  /// Args:
  ///   - `message` (String): Diagnostic text describing the internal state or event.
  ///
  /// Returns:
  ///   - `void`
  void debug(String message) {
    _addLog(LogEntry(message: message, level: LogLevel.debug));
  }

  /// Records a general operational message highlighting normal application flow.
  ///
  /// Args:
  ///   - `message` (String): Descriptive text outlining standard operation progress.
  ///
  /// Returns:
  ///   - `void`
  void info(String message) {
    _addLog(LogEntry(message: message, level: LogLevel.info));
  }

  /// Records a potential issue or anomalous event that does not interrupt execution.
  ///
  /// Args:
  ///   - `message` (String): Warning message describing the unusual condition.
  ///   - `error` (Object?): Optional error or exception instance linked to the warning.
  ///
  /// Returns:
  ///   - `void`
  void warning(String message, [Object? error]) {
    _addLog(LogEntry(message: message, level: LogLevel.warning, error: error));
  }

  /// Records an error event indicating a process failure.
  ///
  /// Args:
  ///   - `message` (String): Explanatory message regarding the error.
  ///   - `error` (Object?): Captured exception or error object.
  ///   - `stackTrace` (StackTrace?): Call stack trace associated with the failure.
  ///
  /// Returns:
  ///   - `void`
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _addLog(
      LogEntry(
        message: message,
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Records a severe error event leading to a critical failure or application crash.
  ///
  /// Args:
  ///   - `message` (String): Message describing the critical fault.
  ///   - `error` (Object?): Exception or error object that caused the crash.
  ///   - `stackTrace` (StackTrace?): Call stack trace associated with the critical error.
  ///
  /// Returns:
  ///   - `void`
  void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _addLog(
      LogEntry(
        message: message,
        level: LogLevel.fatal,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Clears all stored log entries from memory and notifies listeners.
  ///
  /// Returns:
  ///   - `void`
  void clear() {
    _logs.clear();
    notifyListeners();
  }

  /// Concatenates all current log entries into a single formatted text string.
  ///
  /// Returns:
  ///   - `String`: All accumulated logs separated by newlines, ready for export.
  String exportLogsText() {
    return _logs.map((entry) => entry.toString()).join('\n');
  }

  /// Internal helper to push a new entry into the buffer, enforce capacity limits, and output to developer log.
  ///
  /// Args:
  ///   - `entry` (LogEntry): The log entry instance to be added.
  ///
  /// Returns:
  ///   - `void`
  void _addLog(LogEntry entry) {
    if (_logs.length >= _maxLogs) {
      _logs.removeAt(0);
    }
    _logs.add(entry);

    developer.log(
      entry.message,
      time: entry.timestamp,
      name: 'AppLog',
      error: entry.error,
      stackTrace: entry.stackTrace,
    );

    notifyListeners();
  }
}
