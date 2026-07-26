import 'binance_currency_response.dart';

/// Paginated collection payload structure aggregating multiple rate response
/// items.
///
/// This layout ensures clients receive consistency concerning pagination
/// states, binding both the requested records window slice and the real
/// overall table records total.
///
/// Attributes:
///   - currencies (List[BinanceCurrencyResponse]): Collection list containing
///     validated rate dataset representations.
///   - count (int): Absolute global count matching filters used to manage
///     client pagination states.
class BinanceCurrencyListResponse {
  final List<BinanceCurrencyResponse> currencies;
  final int count;

  BinanceCurrencyListResponse({required this.currencies, required this.count});

  factory BinanceCurrencyListResponse.fromJson(Map<String, dynamic> json) {
    return BinanceCurrencyListResponse(
      currencies: (json['currencies'] as List<dynamic>)
          .map(
            (e) => BinanceCurrencyResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencies': currencies.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}
