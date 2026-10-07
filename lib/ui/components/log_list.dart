import 'package:flutter/material.dart';

import '../../models/log_entry.dart';
import 'log_item.dart';

/// Componente encargado de renderizar la lista desplazable de registros de logs.
///
/// Attributes:
///   - `logs` (List&lt;LogEntry&gt;): Colección de entradas de log a ser renderizadas en la lista.
///
/// Returns:
///   - `LogList`: Widget que maqueta el listado de logs utilizando [LogItem] y un separador temático.
class LogList extends StatelessWidget {
  final List<LogEntry> logs;

  /// Crea una instancia de [LogList] recibiendo la lista de entradas a mostrar.
  ///
  /// Args:
  ///   - `logs` (List&lt;LogEntry&gt;): Colección de entradas de log.
  const LogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: logs.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1.0, color: theme.dividerColor),
      itemBuilder: (context, index) {
        return LogItem(entry: logs[index]);
      },
    );
  }
}
