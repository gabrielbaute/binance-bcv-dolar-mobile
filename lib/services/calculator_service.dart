import '../enums/currency_mode.dart';
import '../models/calculator_result.dart';

/// Servicio responsable de realizar los cálculos de conversión monetaria.
class CalculatorService {
  /// Realiza la conversión de un monto a múltiples tasas de cambio según el modo de entrada.
  ///
  /// Args:
  ///   amount (double): Monto ingresado por el usuario.
  ///   mode (CurrencyMode): Dirección de la conversión (USD o VES).
  ///   bcvDolarRate (double?): Tasa del dólar BCV.
  ///   binanceUsdtRate (double?): Tasa de USDT/VES Buy en Binance.
  ///   bcvEuroRate (double?): Tasa del euro BCV.
  ///   averageRate (double?): Tasa promedio.
  ///
  /// Returns:
  ///   CalculatorResult: Instancia con los montos convertidos a cada tasa de cambio.
  CalculatorResult calculate({
    required double amount,
    required CurrencyMode mode,
    required double? bcvDolarRate,
    required double? binanceUsdtRate,
    required double? bcvEuroRate,
    required double? averageRate,
  }) {
    if (amount <= 0.0) {
      return CalculatorResult.zero();
    }

    return CalculatorResult(
      bcvDolarResult: _convert(amount, bcvDolarRate, mode),
      binanceUsdtResult: _convert(amount, binanceUsdtRate, mode),
      bcvEuroResult: _convert(amount, bcvEuroRate, mode),
      averageResult: _convert(amount, averageRate, mode),
    );
  }

  /// Convierte un monto individual según una tasa dada y la dirección del modo.
  ///
  /// Args:
  ///   amount (double): Monto base a convertir.
  ///   rate (double?): Tasa de cambio a aplicar.
  ///   mode (CurrencyMode): Dirección de la moneda origen.
  ///
  /// Returns:
  ///   double: Resultado de la operación matemática o 0.0 si la tasa es nula o inválida.
  double _convert(double amount, double? rate, CurrencyMode mode) {
    if (rate == null || !rate.isFinite || rate <= 0.0) {
      return 0.0;
    }

    return mode == CurrencyMode.usd ? amount * rate : amount / rate;
  }
}
