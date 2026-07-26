import 'package:flutter/material.dart';
import '../../enums/currency_mode.dart';
import '../../models/calculator_result.dart';

/// Componente modular que representa la calculadora de conversión de monedas.
///
/// Attributes:
///   - mode (CurrencyMode): Modo de moneda seleccionado actualmente (USD o VES).
///   - result (CalculatorResult): Objeto con los montos calculados para cada tasa.
///   - onModeChanged (ValueChanged[CurrencyMode]): Callback ejecutado al cambiar de USD a VES o viceversa.
///   - onAmountChanged (ValueChanged[double]): Callback ejecutado al modificar la cantidad ingresada.
class CalculatorCard extends StatefulWidget {
  final CurrencyMode mode;
  final CalculatorResult result;
  final ValueChanged<CurrencyMode> onModeChanged;
  final ValueChanged<double> onAmountChanged;

  /// Constructor de CalculatorCard.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   mode (CurrencyMode): Modo de divisa origen.
  ///   result (CalculatorResult): Resultados procesados.
  ///   onModeChanged (ValueChanged[CurrencyMode]): Notificador de cambio de modo.
  ///   onAmountChanged (ValueChanged[double]): Notificador de cambio de monto.
  const CalculatorCard({
    super.key,
    required this.mode,
    required this.result,
    required this.onModeChanged,
    required this.onAmountChanged,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Retorna el prefijo del símbolo monetario según el modo activo.
  String get _symbolPrefix => widget.mode == CurrencyMode.usd ? 'Bs.' : '\$';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            /* Selector de tipo de moneda (USD/VES) */
            SegmentedButton<CurrencyMode>(
              segments: const <ButtonSegment<CurrencyMode>>[
                ButtonSegment<CurrencyMode>(
                  value: CurrencyMode.usd,
                  label: Text('USD (\$)'),
                  icon: Icon(Icons.attach_money),
                ),
                ButtonSegment<CurrencyMode>(
                  value: CurrencyMode.ves,
                  label: Text('VES (Bs)'),
                  icon: Icon(Icons.currency_exchange),
                ),
              ],
              selected: <CurrencyMode>{widget.mode},
              onSelectionChanged: (Set<CurrencyMode> newSelection) {
                widget.onModeChanged(newSelection.first);
              },
            ),
            const SizedBox(height: 16.0),

            /* Input para ingresar la cifra */
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Monto a calcular',
                hintText: '0.00',
                prefixIcon: Icon(
                  widget.mode == CurrencyMode.usd
                      ? Icons.attach_money
                      : Icons.numbers,
                ),
              ),
              onChanged: (String value) {
                final amount = double.tryParse(value) ?? 0.0;
                widget.onAmountChanged(amount);
              },
            ),
            const SizedBox(height: 20.0),

            /* Desglose de resultados procesados */
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  _buildResultRow(
                    context,
                    label: 'Promedio:',
                    value:
                        '$_symbolPrefix ${widget.result.averageResult.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  _buildResultRow(
                    context,
                    label: 'BCV Dólar:',
                    value:
                        '$_symbolPrefix ${widget.result.bcvDolarResult.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  _buildResultRow(
                    context,
                    label: 'BCV Euro:',
                    value:
                        '$_symbolPrefix ${widget.result.bcvEuroResult.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  _buildResultRow(
                    context,
                    label: 'USDT Binance:',
                    value:
                        '$_symbolPrefix ${widget.result.binanceUsdtResult.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una fila estilizada de resultado de conversión.
  ///
  /// Args:
  ///   context (BuildContext): Contexto de construcción.
  ///   label (String): Título de la tasa.
  ///   value (String): Resultado formateado.
  ///
  /// Returns:
  ///   Widget: Fila de texto clave-valor.
  Widget _buildResultRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
