import 'package:flutter/material.dart';

/// Componente genérico y reutilizable tipo interruptor (Switch) con tarjeta para activaciones o ajustes.
///
/// Attributes:
///   - title (String): Título descriptivo de la opción.
///   - subtitle (String?): Texto secundario opcional con contexto adicional.
///   - value (bool): Estado booleano actual del interruptor.
///   - onChanged (ValueChanged&lt;bool&gt;): Callback ejecutado al cambiar el estado.
///   - isLoading (bool): Indica si hay una operación asíncrona en curso para deshabilitar el control.
///   - icon (IconData?): Ícono representativo opcional.
class ToggleActivationButton extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLoading;
  final IconData? icon;

  /// Constructor de ToggleActivationButton.
  ///
  /// Args:
  ///   - key (Key?): Llave identificadora del widget.
  ///   - title (String): Título principal.
  ///   - subtitle (String?): Subtítulo explicativo.
  ///   - value (bool): Estado activo/inactivo.
  ///   - onChanged (ValueChanged&lt;bool&gt;): Notificador de cambio.
  ///   - isLoading (bool): Estado de carga.
  ///   - icon (IconData?): Ícono ilustrativo.
  const ToggleActivationButton({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            /* Ícono opcional izquierdo */
            if (icon != null) ...<Widget>[
              Icon(icon, color: theme.colorScheme.primary, size: 24.0),
              const SizedBox(width: 16.0),
            ],

            /* Textos principales (Título y Subtítulo) */
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12.0),

            /* Indicador de carga o Switch interactivo */
            if (isLoading)
              const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
