import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'refresh_button.dart';

/// AppBar personalizada y reutilizable para las pantallas de la aplicación.
///
/// Attributes:
///   - title (String): Título que se mostrará en el encabezado.
///   - onRefresh (VoidCallback?): Callback opcional para la acción del botón de actualización.
///   - isRefreshing (bool): Estado de carga del botón de actualización.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  /// Constructor de CustomAppBar.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   title (String): Texto del título.
  ///   onRefresh (VoidCallback?): Acción de refresco opcional.
  ///   isRefreshing (bool): Indica si se está ejecutando la recarga de datos.
  const CustomAppBar({
    super.key,
    required this.title,
    this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title, style: theme.textTheme.titleLarge),
      centerTitle: false,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: <Widget>[
        if (onRefresh != null)
          RefreshButton(onRefresh: onRefresh!, isLoading: isRefreshing),
        IconButton(
          tooltip: 'Cambiar tema',
          icon: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: theme.colorScheme.primary,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }
}
