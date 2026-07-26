/// Estructura de datos que contiene los resultados de conversión para cada tasa disponible.
///
/// Attributes:
///   - bcvDolarResult (double): Resultado de la conversión usando la tasa del Dólar BCV.
///   - binanceUsdtResult (double): Resultado de la conversión usando la tasa de USDT/VES Buy en Binance.
///   - bcvEuroResult (double): Resultado de la conversión usando la tasa del Euro BCV.
///   - averageResult (double): Resultado de la conversión usando la tasa Promedio.
class CalculatorResult {
  final double bcvDolarResult;
  final double binanceUsdtResult;
  final double bcvEuroResult;
  final double averageResult;

  /// Constructor de CalculatorResult.
  ///
  /// Args:
  ///   bcvDolarResult (double): Valor convertido a la tasa del Dólar BCV.
  ///   binanceUsdtResult (double): Valor convertido a la tasa USDT.
  ///   bcvEuroResult (double): Valor convertido a la tasa del Euro BCV.
  ///   averageResult (double): Valor convertido a la tasa promedio.
  const CalculatorResult({
    required this.bcvDolarResult,
    required this.binanceUsdtResult,
    required this.bcvEuroResult,
    required this.averageResult,
  });

  /// Retorna una instancia con todos los valores inicializados en cero.
  ///
  /// Returns:
  ///   CalculatorResult: Objeto con resultados en 0.0.
  factory CalculatorResult.zero() {
    return const CalculatorResult(
      bcvDolarResult: 0.0,
      binanceUsdtResult: 0.0,
      bcvEuroResult: 0.0,
      averageResult: 0.0,
    );
  }
}
