import 'package:flutter/material.dart';

import '../../enums/log_level.dart';

/// Componente visual tipo desplegable para seleccionar el nivel de severidad de logs a filtrar.
///
/// Attributes:
///   - `selectedFilter` (LogLevel?): Nivel de severidad actualmente seleccionado, o null si se muestran todos.
///   - `onFilterSelected` (ValueChanged&lt;LogLevel?&gt;): Función callback invocada al cambiar el nivel seleccionado.
///
/// Returns:
///   - `LogFilter`: Widget desacoplado que renderiza el selector desplegable de filtros.
class LogFilter extends StatelessWidget {
  final LogLevel? selectedFilter;
  final ValueChanged<LogLevel?> onFilterSelected;

  /// Crea una instancia de [LogFilter] recibiendo el filtro activo y el callback de selección.
  ///
  /// Args:
  ///   - `selectedFilter` (LogLevel?): Nivel actualmente seleccionado.
  ///   - `onFilterSelected` (ValueChanged&lt;LogLevel?&gt;): Invocación al cambiar el filtro.
  const LogFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<LogLevel?>(
        value: selectedFilter,
        isExpanded: true,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: 'Filtrar por nivel',
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        items: [
          DropdownMenuItem<LogLevel?>(
            value: null,
            child: Text(
              'Todos los niveles',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          ...LogLevel.values.map((level) {
            return DropdownMenuItem<LogLevel?>(
              value: level,
              child: Text(
                level.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }),
        ],
        onChanged: onFilterSelected,
      ),
    );
  }
}
