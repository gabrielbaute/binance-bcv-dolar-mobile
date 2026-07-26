/// Filtros disponibles para consultar el historial de cotizaciones.
///
/// - `bcvDolar`: Dólar emitido por el Banco Central de Venezuela (BCV).
/// - `bcvEuro`: Euro emitido por el Banco Central de Venezuela (BCV).
/// - `binanceUsdt`: Cotización P2P de USDT en Binance.
enum HistoryFilter {
  bcvDolar('Dólar'),
  bcvEuro('Euro'),
  binanceUsdt('USDT');

  final String value;
  const HistoryFilter(this.value);
}
