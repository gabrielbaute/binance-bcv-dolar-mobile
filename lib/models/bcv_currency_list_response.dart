import 'bcv_currency_response.dart';

/// Schema for list response.
///
/// Attributes:
///   - currencies (List[BCVCurrencyResponse]): List of BCVCurrencyResponse objects.
///   - count (int): Total amount of BCVCurrencyResponse objects.
class BCVCurrencyListResponse {
  final List<BCVCurrencyResponse> currencies;
  final int count;

  BCVCurrencyListResponse({this.currencies = const [], this.count = 0});

  factory BCVCurrencyListResponse.fromJson(Map<String, dynamic> json) {
    return BCVCurrencyListResponse(
      currencies:
          (json['currencies'] as List<dynamic>?)
              ?.map(
                (e) => BCVCurrencyResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencies': currencies.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}
