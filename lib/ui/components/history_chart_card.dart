import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/bcv_currency_response.dart';
import '../../models/binance_currency_response.dart';

/// Tarjeta genérica para renderizar datos históricos de BCV o Binance usando fl_chart.
///
/// Attributes:
///   - bcvData (List[BCVCurrencyResponse]?): Colección de registros históricos BCV.
///   - binanceData (List[BinanceCurrencyResponse]?): Colección de registros históricos Binance.
///   - lineColor (Color): Color distintivo de la serie.
///   - title (String): Título descriptivo del indicador.
class HistoryChartCard extends StatelessWidget {
  final List<BCVCurrencyResponse>? bcvData;
  final List<BinanceCurrencyResponse>? binanceData;
  final Color lineColor;
  final String title;

  /// Constructor de HistoryChartCard.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   bcvData (List[BCVCurrencyResponse]?): Registros de BCV.
  ///   binanceData (List[BinanceCurrencyResponse]?): Registros de Binance.
  ///   lineColor (Color): Color de la línea del gráfico.
  ///   title (String): Título superior.
  const HistoryChartCard({
    super.key,
    this.bcvData,
    this.binanceData,
    required this.lineColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Extracción estandarizada de fecha y precio
    final List<({DateTime date, double rate})> points = [];

    if (bcvData != null && bcvData!.isNotEmpty) {
      points.addAll(bcvData!.map((e) => (date: e.date, rate: e.rate)));
    } else if (binanceData != null && binanceData!.isNotEmpty) {
      points.addAll(
        binanceData!
            .where((e) => e.averagePrice != null)
            .map((e) => (date: e.date, rate: e.averagePrice!)),
      );
    }

    if (points.isEmpty) {
      return Card(
        child: SizedBox(
          height: 220.0,
          child: Center(
            child: Text(
              'No hay registros históricos disponibles.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    /* Mapeo de registros a coordenadas FlSpot */
    final spots = points.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.rate);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /* Título del indicador */
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),

            /* Gráfico de líneas interactivas */
            SizedBox(
              height: 220.0,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                      strokeWidth: 1.0,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index >= 0 && index < points.length) {
                            if (index == 0 ||
                                index == points.length ~/ 2 ||
                                index == points.length - 1) {
                              final date = points[index].date;
                              return Text(
                                '${date.day}/${date.month}',
                                style: theme.textTheme.labelSmall,
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3.0,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
