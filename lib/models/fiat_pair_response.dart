import 'binance_currency_response.dart';

/// Schema for fiat pair prices from Binance.
///
/// Attributes:
///   - fiat1P2pBuy (BinanceCurrencyResponse): Fiat 1 P2P response for buy.
///   - fiat1P2pSell (BinanceCurrencyResponse): Fiat 1 P2P response for sell.
///   - fiat2P2pBuy (BinanceCurrencyResponse): Fiat 2 P2P response for buy.
///   - fiat2P2pSell (BinanceCurrencyResponse): Fiat 2 P2P response for sell.
///   - averageExchangeRateF1F2 (double?): Exchange rate from Fiat 1 to Fiat 2.
///   - averageExchangeRateF2F1 (double?): Exchange rate from Fiat 2 to Fiat 1.
///   - date (DateTime): Date of the response.
class FiatPairResponse {
  final BinanceCurrencyResponse fiat1P2pBuy;
  final BinanceCurrencyResponse fiat1P2pSell;
  final BinanceCurrencyResponse fiat2P2pBuy;
  final BinanceCurrencyResponse fiat2P2pSell;
  final double? averageExchangeRateF1F2;
  final double? averageExchangeRateF2F1;
  final DateTime date;

  FiatPairResponse({
    required this.fiat1P2pBuy,
    required this.fiat1P2pSell,
    required this.fiat2P2pBuy,
    required this.fiat2P2pSell,
    required this.averageExchangeRateF1F2,
    required this.averageExchangeRateF2F1,
    required this.date,
  });

  factory FiatPairResponse.fromJson(Map<String, dynamic> json) {
    return FiatPairResponse(
      fiat1P2pBuy: BinanceCurrencyResponse.fromJson(
        json['fiat_1_p2p_buy'] as Map<String, dynamic>,
      ),
      fiat1P2pSell: BinanceCurrencyResponse.fromJson(
        json['fiat_1_p2p_sell'] as Map<String, dynamic>,
      ),
      fiat2P2pBuy: BinanceCurrencyResponse.fromJson(
        json['fiat_2_p2p_buy'] as Map<String, dynamic>,
      ),
      fiat2P2pSell: BinanceCurrencyResponse.fromJson(
        json['fiat_2_p2p_sell'] as Map<String, dynamic>,
      ),
      averageExchangeRateF1F2: (json['average_exchange_rate_f1_f2'] as num?)
          ?.toDouble(),
      averageExchangeRateF2F1: (json['average_exchange_rate_f2_f1'] as num?)
          ?.toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fiat_1_p2p_buy': fiat1P2pBuy.toJson(),
      'fiat_1_p2p_sell': fiat1P2pSell.toJson(),
      'fiat_2_p2p_buy': fiat2P2pBuy.toJson(),
      'fiat_2_p2p_sell': fiat2P2pSell.toJson(),
      'average_exchange_rate_f1_f2': averageExchangeRateF1F2,
      'average_exchange_rate_f2_f1': averageExchangeRateF2F1,
      'date': date.toIso8601String(),
    };
  }
}
