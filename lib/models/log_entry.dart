import '../enums/log_level.dart';

/// Represents a single recorded log event within the application log history.
///
/// Attributes:
/// -  `timestamp` (DateTime): Exact date and time when the log entry was created.
/// -  `message` (String): Descriptive text detailing the logged event.
/// -  `level` (LogLevel): Severity level of the event.
/// -  `error` (Object?): Optional exception or error instance captured at runtime.
/// -  `stackTrace` (StackTrace?): Optional call stack trace associated with an error.
class LogEntry {
  final DateTime timestamp;
  final String message;
  final LogLevel level;
  final Object? error;
  final StackTrace? stackTrace;

  LogEntry({
    required this.message,
    this.level = LogLevel.info,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    final timeStr = timestamp.toIso8601String().substring(11, 19);
    final prefix = level.name.toUpperCase();
    final errStr = error != null ? ' | Error: $error' : '';
    return '[$timeStr] [$prefix] $message$errStr';
  }
}
