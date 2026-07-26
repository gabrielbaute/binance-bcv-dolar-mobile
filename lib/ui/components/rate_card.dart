import 'package:flutter/material.dart';

/// Tarjeta visual reutilizable para la exhibición de precios y tasas de cambio.
///
/// Attributes:
///   - title (String): Nombre o entidad de la tasa (ej. "BCV Dólar", "Binance USDT").
///   - rate (double?): Valor numérico de la tasa.
///   - currencySymbol (String): Símbolo de la moneda destino (ej. "Bs.").
///   - isPrimary (bool): Indica si debe destacar visualmente (tarjeta principal).
///   - badgeText (String?): Etiqueta opcional de contexto (ej. "Live", "Oficial").
///   - icon (IconData?): Ícono representativo de la fuente de datos.
class RateCard extends StatelessWidget {
  final String title;
  final double? rate;
  final String currencySymbol;
  final bool isPrimary;
  final String? badgeText;
  final IconData? icon;

  /// Constructor de RateCard.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   title (String): Nombre de la fuente de tasa.
  ///   rate (double?): Valor de la tasa.
  ///   currencySymbol (String): Símbolo a mostrar. Por defecto es "Bs.".
  ///   isPrimary (bool): Si destaca como tarjeta primaria. Por defecto es false.
  ///   badgeText (String?): Texto opcional para un badge superior.
  ///   icon (IconData?): Ícono ilustrativo.
  const RateCard({
    super.key,
    required this.title,
    required this.rate,
    this.currencySymbol = 'Bs.',
    this.isPrimary = false,
    this.badgeText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final cardBorder = isPrimary
        ? Border.all(color: theme.colorScheme.primary, width: 1.5)
        : Border.all(color: theme.colorScheme.outline);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: cardBorder.top,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Encabezado de la tarjeta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (icon != null) ...<Widget>[
                      Icon(icon, size: 18.0, color: theme.colorScheme.primary),
                      const SizedBox(width: 6.0),
                    ],
                    Text(title, style: textTheme.titleMedium),
                  ],
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                    child: Text(
                      badgeText!,
                      style: textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Monto de la Tasa
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    rate != null
                        ? '$currencySymbol ${rate!.toStringAsFixed(2)}'
                        : '---',
                    style: isPrimary
                        ? textTheme.displayLarge
                        : textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
