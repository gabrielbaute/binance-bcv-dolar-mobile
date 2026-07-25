import '../enums/binance_assets.dart';
import '../enums/fiat_currencies.dart';
import '../enums/trade_type.dart';

/// Schema for the real time response from Binance P2P.
///
/// Attributes:
///   - fiat (FiatCurrency): Fiat currency (e.g., VES, PEN).
///   - asset (BinanceAsset): Asset (USDT, BTC, etc).
///   - tradeType (TradeType): Trade type (BUY or SELL).
///   - prices (List[double]?): List of prices. Can be empty or None if Binance returns no data.
///   - averagePrice (double?): Average price. Null if no data.
///   - medianPrice (double?): Median price. Null if no data.
class BinanceRealTimeResponse {
  final FiatCurrency fiat;
  final BinanceAsset asset;
  final TradeType tradeType;
  final List<double>? prices;
  final double? averagePrice;
  final double? medianPrice;

  BinanceRealTimeResponse({
    required this.fiat,
    required this.asset,
    required this.tradeType,
    this.prices,
    this.averagePrice,
    this.medianPrice,
  });

  factory BinanceRealTimeResponse.fromJson(Map<String, dynamic> json) {
    return BinanceRealTimeResponse(
      fiat: _parseFiatCurrency(json['fiat'] as String),
      asset: _parseBinanceAsset(json['asset'] as String),
      tradeType: _parseTradeType(json['trade_type'] as String),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      averagePrice: (json['average_price'] as num?)?.toDouble(),
      medianPrice: (json['median_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fiat': fiat.value,
      'asset': asset.value,
      'trade_type': tradeType.value,
      'prices': prices,
      'average_price': averagePrice,
      'median_price': medianPrice,
    };
  }

  static FiatCurrency _parseFiatCurrency(String value) {
    return FiatCurrency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw FormatException('Invalid FiatCurrency: $value'),
    );
  }

  static BinanceAsset _parseBinanceAsset(String value) {
    return BinanceAsset.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw FormatException('Invalid BinanceAsset: $value'),
    );
  }

  static TradeType _parseTradeType(String value) {
    return TradeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw FormatException('Invalid TradeType: $value'),
    );
  }
}
