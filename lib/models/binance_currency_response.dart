import '../enums/binance_assets.dart';
import '../enums/fiat_currencies.dart';
import '../enums/trade_type.dart';

/// Serialization model representing data layout output parsed to the clients.
///
/// This schema includes database-generated tracking fields like 'id' and 'date'
/// and structures the individual exchange rate records returned by the endpoints.
///
/// Attributes:
///   - id (String): Unique database auto-generated record token identifier.
///   - fiat (FiatCurrency): The fiat currency target recorded for the trading pair.
///   - asset (BinanceAsset): The digital asset stablecoin cryptocurrency recorded.
///   - tradeType (TradeType): The P2P book perspective recorded (BUY or SELL).
///   - averagePrice (double?): The persistent calculated historical average price.
///   - medianPrice (double?): The persistent calculated historical median price.
///   - date (DateTime): The UTC timestamp when the metrics were written to the database.
class BinanceCurrencyResponse {
  final String id;
  final FiatCurrency fiat;
  final BinanceAsset asset;
  final TradeType tradeType;
  final double? averagePrice;
  final double? medianPrice;
  final DateTime date;

  BinanceCurrencyResponse({
    required this.id,
    required this.fiat,
    required this.asset,
    required this.tradeType,
    required this.averagePrice,
    required this.medianPrice,
    required this.date,
  });

  factory BinanceCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return BinanceCurrencyResponse(
      id: json['id'] as String,
      fiat: _parseFiatCurrency(json['fiat'] as String),
      asset: _parseBinanceAsset(json['asset'] as String),
      tradeType: _parseTradeType(json['trade_type'] as String),
      averagePrice: (json['average_price'] as num?)?.toDouble(),
      medianPrice: (json['median_price'] as num?)?.toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fiat': fiat.value,
      'asset': asset.value,
      'trade_type': tradeType.value,
      'average_price': averagePrice,
      'median_price': medianPrice,
      'date': date.toIso8601String(),
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
