import 'bcv_currency_realtime_response.dart';
import 'binance_realtime_response.dart';

/// Schema for dolar prices from BCV and Binance for Venezuela interest case.
///
/// Attributes:
///   - bcvDolar (BCVCurrencyRealTimeResponse?): BCV dolar response.
///   - bcvEuro (BCVCurrencyRealTimeResponse?): BCV euro response.
///   - binanceUsdtVesBuy (BinanceRealTimeResponse?): Binance USDT/VES response
///     at Buy trade type.
///   - averageUsdtVes (double?): Average price between BCV and Binance.
///   - date (DateTime): Date of the response.
class RealTimeDolarResponse {
  final BCVCurrencyRealTimeResponse? bcvDolar;
  final BCVCurrencyRealTimeResponse? bcvEuro;
  final BinanceRealTimeResponse? binanceUsdtVesBuy;
  final double? averageUsdtVes;
  final DateTime date;

  RealTimeDolarResponse({
    this.bcvDolar,
    this.bcvEuro,
    this.binanceUsdtVesBuy,
    this.averageUsdtVes,
    required this.date,
  });

  factory RealTimeDolarResponse.fromJson(Map<String, dynamic> json) {
    return RealTimeDolarResponse(
      bcvDolar: json['bcv_dolar'] != null
          ? BCVCurrencyRealTimeResponse.fromJson(
              json['bcv_dolar'] as Map<String, dynamic>,
            )
          : null,
      bcvEuro: json['bcv_euro'] != null
          ? BCVCurrencyRealTimeResponse.fromJson(
              json['bcv_euro'] as Map<String, dynamic>,
            )
          : null,
      binanceUsdtVesBuy: json['binance_usdt_ves_buy'] != null
          ? BinanceRealTimeResponse.fromJson(
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
