/// Represents severity levels for system log entries following standard logging hierarchies.
///
/// Attributes:
/// -  `verbose`: Fine-grained informational events, useful for detailed step-by-step tracing.
/// -  `debug`: Diagnostic information useful during development and troubleshooting.
/// -  `info`: General operational messages highlighting normal application progress.
/// -  `warning`: Potential harmful situations or unexpected events that do not halt operation.
/// -  `error`: Error events that might still allow the application to continue running.
/// -  `fatal`: Severe error events that lead the application to abort or crash.
/// -  `label` (String): Display title in Spanish intended for user interface rendering.
enum LogLevel {
  verbose('Detalle'),
  debug('Depuración'),
  info('Información'),
  warning('Advertencia'),
  error('Error'),
  fatal('Crítico');

  final String label;

  const LogLevel(this.label);
}
