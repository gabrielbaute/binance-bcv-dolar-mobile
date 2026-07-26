import 'package:flutter/material.dart';
import '../../enums/history_filter.dart';

/// Componente modular para seleccionar el indicador del gráfico histórico.
///
/// Attributes:
///   - selectedFilter (HistoryFilter): Filtro actualmente activo.
///   - onFilterChanged (ValueChanged`\<HistoryFilter\>`): Callback emitido al cambiar la selección.
class IndicatorSelector extends StatelessWidget {
  final HistoryFilter selectedFilter;
  final ValueChanged<HistoryFilter> onFilterChanged;

  /// Constructor de IndicatorSelector.
  ///
  /// Args:
  ///   key (Key?): Llave identificadora del widget.
  ///   selectedFilter (HistoryFilter): Filtro seleccionado.
  ///   onFilterChanged (ValueChanged`\<HistoryFilter\>`): Callback ejecutado al seleccionar un filtro.
  const IndicatorSelector({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: HistoryFilter.values.map((filter) {
        final isSelected = selectedFilter == filter;
        return ChoiceChip(
          label: Text(filter.value),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              onFilterChanged(filter);
            }
          },
        );
      }).toList(),
    );
  }
}
