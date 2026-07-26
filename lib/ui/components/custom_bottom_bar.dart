import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Barra de navegación inferior que coordina el cambio de pantallas mediante GoRouter.
///
/// Attributes:
///   - currentPath (String): Ruta actual utilizada para seleccionar el ítem activo.
class CustomBottomBar extends StatelessWidget {
  final String currentPath;

  /// Constructor de CustomBottomBar.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   currentPath (String): URI de la ruta activa en GoRouter.
  const CustomBottomBar({super.key, required this.currentPath});

  int _getSelectedIndex() {
    if (currentPath.startsWith('/realtime')) return 1;
    if (currentPath.startsWith('/history')) return 2;
    return 0; // Default: /promedio
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/promedio');
        break;
      case 1:
        context.go('/realtime');
        break;
      case 2:
        context.go('/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: (int index) => _onItemTapped(context, index),
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Promedio',
        ),
        NavigationDestination(
          icon: Icon(Icons.bolt_outlined),
          selectedIcon: Icon(Icons.bolt),
          label: 'Tiempo Real',
        ),
        NavigationDestination(
          icon: Icon(Icons.show_chart_outlined),
          selectedIcon: Icon(Icons.show_chart),
          label: 'Historial',
        ),
      ],
    );
  }
}
