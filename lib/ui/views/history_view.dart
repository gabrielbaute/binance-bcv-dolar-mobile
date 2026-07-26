import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/history_filter.dart';
import '../../providers/history_provider.dart';
import '../components/history_chart_card.dart';
import '../components/rate_card.dart';
import '../layouts/main_layout.dart';

/// Vista de historial que despliega gráficas interactivas y filtros por tipo de tasa.
///
/// Attributes:
///   - currentPath (String): Ruta de navegación activa enviada al MainLayout.
class HistoryView extends StatefulWidget {
  final String currentPath;

  /// Constructor de HistoryView.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   currentPath (String): Ruta activa en GoRouter.
  const HistoryView({super.key, required this.currentPath});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    /* Solicitud inicial de datos históricos de BCV y Binance */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().fetchAllHistory();
    });
  }

  /// Devuelve el color adecuado de la línea según el filtro seleccionado.
  Color _getFilterColor(BuildContext context, HistoryFilter filter) {
    final theme = Theme.of(context);
    switch (filter) {
      case HistoryFilter.bcvDolar:
        return theme.colorScheme.primary;
      case HistoryFilter.bcvEuro:
        return Colors.indigo;
      case HistoryFilter.binanceUsdt:
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<HistoryProvider>();

    return MainLayout(
      title: 'Histórico',
      currentPath: widget.currentPath,
      isRefreshing: provider.isLoading,
      onRefresh: () => provider.fetchAllHistory(forceRefresh: true),
      child: RefreshIndicator(
        onRefresh: () => provider.fetchAllHistory(forceRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Banner de error */
              if (provider.errorMessage != null) ...<Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    provider.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              /* Controles de Filtrado */
              Text('Seleccionar Indicador', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8.0),

              /* SegmentedButton para alternar entre Dólar BCV, Euro BCV y USDT Binance */
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<HistoryFilter>(
                  segments: const <ButtonSegment<HistoryFilter>>[
                    ButtonSegment<HistoryFilter>(
                      value: HistoryFilter.bcvDolar,
                      label: Text('BCV Dólar'),
                      icon: Icon(Icons.account_balance_rounded),
                    ),
                    ButtonSegment<HistoryFilter>(
                      value: HistoryFilter.bcvEuro,
                      label: Text('BCV Euro'),
                      icon: Icon(Icons.euro_rounded),
                    ),
                    ButtonSegment<HistoryFilter>(
                      value: HistoryFilter.binanceUsdt,
                      label: Text('USDT Binance'),
                      icon: Icon(Icons.currency_bitcoin_rounded),
                    ),
                  ],
                  selected: <HistoryFilter>{provider.selectedFilter},
                  onSelectionChanged: (Set<HistoryFilter> newSelection) {
                    provider.setSelectedFilter(newSelection.first);
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              /* Renderizado de la gráfica según el tipo de datos seleccionado */
              if (provider.isLoading &&
                  provider.bcvDolarHistory == null &&
                  provider.binanceUsdtHistory == null) ...<Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else ...<Widget>[
                /* Gráfica pasando los modelos según el filtro activo */
                HistoryChartCard(
                  title: 'Evolución - ${provider.selectedFilterLabel}',
                  bcvData: provider.isBcvFilter
                      ? provider.currentBcvPoints
                      : null,
                  binanceData: !provider.isBcvFilter
                      ? provider.currentBinancePoints
                      : null,
                  lineColor: _getFilterColor(context, provider.selectedFilter),
                ),
                const SizedBox(height: 16.0),

                /* Tarjeta con el último valor de la serie histórica actual */
                RateCard(
                  title: 'Último Registro (${provider.selectedFilterLabel})',
                  rate: provider.latestRate,
                  isPrimary: true,
                  badgeText: 'Reciente',
                  icon: Icons.history_toggle_off_rounded,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
