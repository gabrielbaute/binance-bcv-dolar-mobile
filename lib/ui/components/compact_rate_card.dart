import 'package:flutter/material.dart';

/// Tarjeta visual reducida optimizada para mostrar tasas en filas múltiples o grillas.
///
/// Attributes:
///   - title (String): Nombre de la entidad o tasa (ej. "BCV Dólar").
///   - rate (double?): Valor numérico de la tasa.
///   - currencySymbol (String): Símbolo de la divisa (por defecto "Bs.").
///   - badgeText (String?): Etiqueta pequeña (ej. "Oficial", "P2P").
///   - icon (IconData?): Ícono ilustrativo opcional.
class CompactRateCard extends StatelessWidget {
  final String title;
  final double? rate;
  final String currencySymbol;
  final String? badgeText;
  final IconData? icon;

  /// Constructor de CompactRateCard.
  ///
  /// Args:
  ///   key (Key?): Llave identificadora del widget.
  ///   title (String): Nombre de la tasa.
  ///   rate (double?): Monto de la tasa.
  ///   currencySymbol (String): Símbolo a mostrar.
  ///   badgeText (String?): Etiqueta descriptiva superior.
  ///   icon (IconData?): Ícono descriptivo.
  const CompactRateCard({
    super.key,
    required this.title,
    required this.rate,
    this.currencySymbol = 'Bs.',
    this.badgeText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /* Badge / Etiqueta superior opcional */
            if (badgeText != null) ...<Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    badgeText!,
                    style: textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
            ],

            /* Título con ícono e interlineado ajustado */
            Row(
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 14.0, color: theme.colorScheme.primary),
                  const SizedBox(width: 4.0),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            /* Monto ajustado automáticamente para evitar saltos de línea */
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                rate != null
                    ? '$currencySymbol ${rate!.toStringAsFixed(2)}'
                    : '---',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
