import 'package:flutter/material.dart';

/// Componente visual que representa el estado vacío cuando no existen registros de logs a mostrar.
///
/// Returns:
///   - `EmptyLogs`: Widget pasivo que maqueta un mensaje e ícono descriptivo usando el tema actual.
class EmptyLogs extends StatelessWidget {
  /// Crea una instancia de [EmptyLogs].
  const EmptyLogs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.outline;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 48.0, color: color),
            const SizedBox(height: 12.0),
            Text(
              'No hay registros de eventos para mostrar',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
