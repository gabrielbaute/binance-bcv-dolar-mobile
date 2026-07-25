/// Fiat currencies available for Binance P2P operations.
///
/// - `ves`: Venezuelan Bolívar (VES)
/// - `pen`: Peruvian Sol (PEN)
/// - `usd`: United States Dollar (USD)
/// - `usdt`: Tether (USDT)
/// - `eur`: Euro (EUR)
enum FiatCurrency {
  ves('VES'),
  pen('PEN'),
  usd('USD'),
  usdt('USDT'),
  eur('EUR');

  final String value;
  const FiatCurrency(this.value);
}
