import 'package:flutter/material.dart';

/// Componente visual que renderiza la barra de botones de acción para copiar y limpiar logs.
///
/// Attributes:
///   - `isEmpty` (bool): Indica si no existen registros almacenados para deshabilitar las acciones.
///   - `onCopy` (VoidCallback): Función callback que se ejecuta al presionar el botón de copiar.
///   - `onClear` (VoidCallback): Función callback que se ejecuta al presionar el botón de limpiar.
///
/// Returns:
///   - `LogActions`: Widget desacoplado que renderiza la fila de botones de acción.
class LogActions extends StatelessWidget {
  final bool isEmpty;
  final VoidCallback onCopy;
  final VoidCallback onClear;

  /// Crea una instancia de [LogActions] recibiendo el estado y los callbacks de acción.
  ///
  /// Args:
  ///   - `isEmpty` (bool): Estado de disponibilidad de registros.
  ///   - `onCopy` (VoidCallback): Callback para la acción de copiar.
  ///   - `onClear` (VoidCallback): Callback para la acción de limpiar.
  const LogActions({
    super.key,
    required this.isEmpty,
    required this.onCopy,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isEmpty ? null : onClear,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Limpiar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: FilledButton.icon(
              onPressed: isEmpty ? null : onCopy,
              icon: const Icon(Icons.copy),
              label: const Text('Copiar'),
            ),
          ),
        ],
      ),
    );
  }
}
