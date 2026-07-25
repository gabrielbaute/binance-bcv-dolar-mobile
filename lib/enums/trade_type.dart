/// Trade types available in Binance P2P platform.
///
/// - `buy`: Buy trade type (BUY)
/// - `sell`: Sell trade type (SELL)
enum TradeType {
  buy('BUY'),
  sell('SELL');

  final String value;
  const TradeType(this.value);
}
