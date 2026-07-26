/// Modos de conversión de la calculadora según la moneda de entrada.
///
/// - `usd`: Conversión de Dólares a Bolívares.
/// - `ves`: Conversión de Bolívares a Dólares.
enum CurrencyMode {
  usd('USD'),
  ves('VES');

  final String value;
  const CurrencyMode(this.value);
}
