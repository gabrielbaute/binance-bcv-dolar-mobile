/// Available crypto assets for Binance P2P operations.
///
/// Only stablecoins are supported for P2P trading in this platform.
///
/// - `usdt`: Tether (USDT)
/// - `usdc`: USD Coin (USDC)
/// - `dai`: Dai (DAI)
enum BinanceAsset {
  usdt('USDT'),
  usdc('USDC'),
  dai('DAI');

  final String value;
  const BinanceAsset(this.value);
}
