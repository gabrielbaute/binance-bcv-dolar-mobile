import 'package:flutter/material.dart';

/// Botón reutilizable para la acción de refresco de datos en las distintas vistas.
///
/// Attributes:
///   - onRefresh (VoidCallback): Función a ejecutar al presionar el botón.
///   - isLoading (bool): Indica si la petición está en curso para deshabilitar o mostrar animación.
class RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isLoading;

  /// Constructor de RefreshButton.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   onRefresh (VoidCallback): Callback de actualización.
  ///   isLoading (bool): Estado de carga actual.
  const RefreshButton({
    super.key,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      tooltip: 'Actualizar datos',
      onPressed: isLoading ? null : onRefresh,
      icon: isLoading
          ? SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            )
          : Icon(Icons.refresh_rounded, color: theme.colorScheme.primary),
    );
  }
}
