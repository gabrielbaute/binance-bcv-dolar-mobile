import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dolar_promedio_provider.dart';
import '../components/calculator_card.dart';
import '../components/rate_card.dart';
import '../layouts/main_layout.dart';

/// Vista principal que exhibe las tasas de Dólar Promedio y la Calculadora.
///
/// Attributes:
///   - currentPath (String): Ruta actual para la sincronización con el layout principal.
class PromedioView extends StatefulWidget {
  final String currentPath;

  /// Constructor de PromedioView.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   currentPath (String): Dirección de navegación activa.
  const PromedioView({super.key, required this.currentPath});

  @override
  State<PromedioView> createState() => _PromedioViewState();
}

class _PromedioViewState extends State<PromedioView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DolarPromedioProvider>().fetchDolarPromedio();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<DolarPromedioProvider>();
    final response = provider.dolarData;

    return MainLayout(
      title: 'Dólar Promedio VE',
      currentPath: widget.currentPath,
      isRefreshing: provider.isLoading,
      onRefresh: () => provider.fetchDolarPromedio(forceRefresh: true),
      child: RefreshIndicator(
        onRefresh: () => provider.fetchDolarPromedio(forceRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Mapeo y presentación de mensajes de error */
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

              /* Renderizado según estado de carga y datos */
              if (provider.isLoading && response == null) ...<Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else ...<Widget>[
                /* Tarjeta prominente de Promedio General */
                RateCard(
                  title: 'Promedio General',
                  rate: response?.averageUsdtVes,
                  isPrimary: true,
                  badgeText: 'Promedio',
                  icon: Icons.analytics_rounded,
                ),
                const SizedBox(height: 12.0),

                /* Bloque secundario con tasas BCV y Paralelo */
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RateCard(
                        title: 'BCV Dólar',
                        rate: response?.bcvDolar?.rate,
                        badgeText: 'Oficial',
                        icon: Icons.account_balance_rounded,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: RateCard(
                        title: 'BCV Euro',
                        rate: response?.bcvEuro?.rate,
                        badgeText: 'Oficial',
                        icon: Icons.account_balance_rounded,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: RateCard(
                        title: 'USDT Binance',
                        rate: response?.binanceUsdtVesBuy?.averagePrice,
                        badgeText: 'P2P',
                        icon: Icons.storefront_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                /* Sección de Calculadora modularizada */
                Text(
                  'Calculadora de Conversión',
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
