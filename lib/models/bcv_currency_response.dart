import '../enums/bcv_currencies.dart';
import '../enums/trade_type.dart';

/// Schema for the response from BCV for a single currency.
///
/// Attributes:
///   - id (String): Unique identifier for the record.
///   - currency (BcvCurrency): Currency tracked by BCV.
///   - tradeType (TradeType): Trade type operation for the currency.
///   - rate (double): Rate of the currency.
///   - date (DateTime): Date of the response.
class BCVCurrencyResponse {
  final String id;
  final BcvCurrency currency;
  final TradeType tradeType;
  final double rate;
  final DateTime date;

  BCVCurrencyResponse({
    required this.id,
    required this.currency,
    required this.tradeType,
    required this.rate,
    required this.date,
  });

  factory BCVCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return BCVCurrencyResponse(
      id: json['id'] as String,
      currency: _parseBcvCurrency(json['currency'] as String),
      tradeType: _parseTradeType(json['trade_type'] as String),
      rate: (json['rate'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
