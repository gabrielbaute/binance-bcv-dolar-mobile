import 'bcv_currency_response.dart';
import 'binance_currency_response.dart';

/// Schema for dolar prices from BCV and Binance for Venezuela interest case.
///
/// Attributes:
///   - bcvDolar (BCVCurrencyResponse?): BCV dolar response.
///   - bcvEuro (BCVCurrencyResponse?): BCV euro response.
///   - binanceUsdtVesBuy (BinanceCurrencyResponse?): Binance USDT/VES response
///     at Buy trade type.
///   - averageUsdtVes (double?): Average price between BCV and Binance.
///   - date (DateTime): Date of the response.
class DolarResponse {
  final BCVCurrencyResponse? bcvDolar;
  final BCVCurrencyResponse? bcvEuro;
  final BinanceCurrencyResponse? binanceUsdtVesBuy;
  final double? averageUsdtVes;
  final DateTime date;

  DolarResponse({
    this.bcvDolar,
    this.bcvEuro,
    this.binanceUsdtVesBuy,
    this.averageUsdtVes,
    required this.date,
  });

  factory DolarResponse.fromJson(Map<String, dynamic> json) {
    return DolarResponse(
      bcvDolar: json['bcv_dolar'] != null
          ? BCVCurrencyResponse.fromJson(
              json['bcv_dolar'] as Map<String, dynamic>,
            )
          : null,
      bcvEuro: json['bcv_euro'] != null
          ? BCVCurrencyResponse.fromJson(
              json['bcv_euro'] as Map<String, dynamic>,
            )
          : null,
      binanceUsdtVesBuy: json['binance_usdt_ves_buy'] != null
          ? BinanceCurrencyResponse.fromJson(
              json['binance_usdt_ves_buy'] as Map<String, dynamic>,
            )
          : null,
      averageUsdtVes: (json['average_usdt_ves'] as num?)?.toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bcv_dolar': bcvDolar?.toJson(),
      'bcv_euro': bcvEuro?.toJson(),
      'binance_usdt_ves_buy': binanceUsdtVesBuy?.toJson(),
      'average_usdt_ves': averageUsdtVes,
      'date': date.toIso8601String(),
    };
  }
}
