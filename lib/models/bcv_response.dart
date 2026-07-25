import 'bcv_currency_response.dart';

/// Schema for the general response from BCV to all currencies.
///
/// Attributes:
///   - dolar (BCVCurrencyResponse?): BCV dolar response.
///   - euro (BCVCurrencyResponse?): BCV euro response.
///   - yuan (BCVCurrencyResponse?): BCV yuan response.
///   - lira (BCVCurrencyResponse?): BCV lira response.
///   - rublo (BCVCurrencyResponse?): BCV rublo response.
class BCVResponse {
  final BCVCurrencyResponse? dolar;
  final BCVCurrencyResponse? euro;
  final BCVCurrencyResponse? yuan;
  final BCVCurrencyResponse? lira;
  final BCVCurrencyResponse? rublo;

  BCVResponse({this.dolar, this.euro, this.yuan, this.lira, this.rublo});

  factory BCVResponse.fromJson(Map<String, dynamic> json) {
    return BCVResponse(
      dolar: json['dolar'] != null
          ? BCVCurrencyResponse.fromJson(json['dolar'] as Map<String, dynamic>)
          : null,
      euro: json['euro'] != null
          ? BCVCurrencyResponse.fromJson(json['euro'] as Map<String, dynamic>)
          : null,
      yuan: json['yuan'] != null
          ? BCVCurrencyResponse.fromJson(json['yuan'] as Map<String, dynamic>)
          : null,
      lira: json['lira'] != null
          ? BCVCurrencyResponse.fromJson(json['lira'] as Map<String, dynamic>)
          : null,
      rublo: json['rublo'] != null
          ? BCVCurrencyResponse.fromJson(json['rublo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dolar': dolar?.toJson(),
      'euro': euro?.toJson(),
      'yuan': yuan?.toJson(),
      'lira': lira?.toJson(),
      'rublo': rublo?.toJson(),
    };
  }
}
