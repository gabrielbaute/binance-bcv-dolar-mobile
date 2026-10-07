import 'package:flutter/material.dart';

import '../../enums/log_level.dart';
import '../../models/log_entry.dart';

/// Componente visual para la representación individual de una entrada de log.
///
/// Attributes:
///   - `entry` (LogEntry): Instancia del registro de evento a ser dibujado.
///
/// Returns:
///   - `LogItem`: Widget desacoplado que renderiza los datos del log utilizando los estilos del tema.
class LogItem extends StatelessWidget {
  final LogEntry entry;

  /// Crea una instancia de [LogItem] recibiendo la entrada de log correspondiente.
  ///
  /// Args:
  ///   - `entry` (LogEntry): Registro de evento a mostrar.
  const LogItem({super.key, required this.entry});

  /// Selecciona el color del texto y la severidad según las propiedades del tema activo.
  ///
  /// Args:
  ///   - `theme` (ThemeData): Objeto de tema actual del contexto de la aplicación.
  ///
  /// Returns:
  ///   - `Color`: Color correspondiente según el nivel de severidad del log.
  Color _getSeverityColor(ThemeData theme) {
    switch (entry.level) {
      case LogLevel.fatal:
      case LogLevel.error:
        return theme.colorScheme.error;
      case LogLevel.warning:
        return theme.colorScheme.tertiary;
      case LogLevel.verbose:
      case LogLevel.debug:
      case LogLevel.info:
        return theme.colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getSeverityColor(theme);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.toString(),
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
          if (entry.stackTrace != null) ...[
            const SizedBox(height: 4.0),
            Text(
              entry.stackTrace.toString(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
