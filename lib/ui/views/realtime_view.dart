import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/realtime_provider.dart';
import '../components/calculator_card.dart';
import '../components/compact_rate_card.dart';
import '../components/rate_card.dart';
import '../layouts/main_layout.dart';

/// Vista que exhibe los precios del dólar y criptoactivos en tiempo real.
///
/// Attributes:
///   - currentPath (String): Ruta actual de GoRouter para mantener la barra de navegación sincronizada.
class RealtimeView extends StatefulWidget {
  final String currentPath;

  /// Constructor de RealtimeView.
  ///
  /// Args:
  ///   key (Key?): Llave identificadora del widget.
  ///   currentPath (String): URI de la ruta en GoRouter.
  const RealtimeView({super.key, required this.currentPath});

  @override
  State<RealtimeView> createState() => _RealtimeViewState();
}

class _RealtimeViewState extends State<RealtimeView> {
  @override
  void initState() {
    super.initState();
    /* Solicitud inicial de datos en tiempo real aprovechando la caché */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealtimeProvider>().fetchRealtimeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<RealtimeProvider>();
    final data = provider.realtimeData;

    return MainLayout(
      title: 'Tiempo Real',
      currentPath: widget.currentPath,
      isRefreshing: provider.isLoading,
      onRefresh: () => provider.fetchRealtimeData(forceRefresh: true),
      child: RefreshIndicator(
        onRefresh: () => provider.fetchRealtimeData(forceRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Banner para la notificación de errores */
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

              /* Estado de carga inicial */
              if (provider.isLoading && data == null) ...<Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else ...<Widget>[
                /* Tarjeta Prominente de USDT Binance */
                RateCard(
                  title: 'Binance USDT (P2P)',
                  rate: data?.binanceUsdtVesBuy?.averagePrice,
                  isPrimary: true,
                  badgeText: 'En vivo',
                  icon: Icons.currency_bitcoin_rounded,
                ),
                const SizedBox(height: 12.0),

                /* Fila de tarjetas compactas para las cotizaciones secundarias */
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CompactRateCard(
                        title: 'BCV Dólar',
                        rate: data?.bcvDolar?.rate,
                        badgeText: 'Oficial',
                        icon: Icons.account_balance_rounded,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: CompactRateCard(
                        title: 'BCV Euro',
                        rate: data?.bcvEuro?.rate,
                        badgeText: 'Oficial',
                        icon: Icons.euro_rounded,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: CompactRateCard(
                        title: 'Promedio',
                        rate: data?.averageUsdtVes,
                        badgeText: 'Promedio',
                        icon: Icons.storefront_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                /* Sección de la Calculadora en Tiempo Real */
                Text(
                  'Calculadora en Tiempo Real',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12.0),

                CalculatorCard(
                  mode: provider.calculatorMode,
                  result: provider.calculatorResult,
                  onModeChanged: (mode) => provider.setCalculatorMode(mode),
                  onAmountChanged: (amount) =>
                      provider.setCalculatorAmount(amount),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
