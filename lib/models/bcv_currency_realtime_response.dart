import '../enums/bcv_currencies.dart';
import '../enums/trade_type.dart';

/// Schema for the real time response from BCV for a single currency.
///
/// Attributes:
///   - currency (BcvCurrency): Currency tracked by BCV.
///   - tradeType (TradeType): Trade type operation for the currency.
///   - rate (double): Rate of the currency.
///   - date (DateTime): Date of the response.
class BCVCurrencyRealTimeResponse {
  final BcvCurrency currency;
  final TradeType tradeType;
  final double rate;
  final DateTime date;

  BCVCurrencyRealTimeResponse({
    required this.currency,
    required this.tradeType,
    required this.rate,
    required this.date,
  });

  factory BCVCurrencyRealTimeResponse.fromJson(Map<String, dynamic> json) {
    return BCVCurrencyRealTimeResponse(
      currency: _parseBcvCurrency(json['currency'] as String),
      tradeType: _parseTradeType(json['trade_type'] as String),
      rate: (json['rate'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency.value,
      'trade_type': tradeType.value,
      'rate': rate,
      'date': date.toIso8601String(),
    };
  }

  static BcvCurrency _parseBcvCurrency(String value) {
    return BcvCurrency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw FormatException('Invalid BcvCurrency: $value'),
    );
  }

  static TradeType _parseTradeType(String value) {
    return TradeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw FormatException('Invalid TradeType: $value'),
    );
  }
}
