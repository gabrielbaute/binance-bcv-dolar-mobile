import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';

/// Layout estructural principal que encapsula la AppBar, la BottomBar y el contenido central.
///
/// Attributes:
///   - title (String): Título a desplegar en la CustomAppBar.
///   - child (Widget): Contenido específico de la pantalla actual.
///   - currentPath (String): Ruta activa enviada a la CustomBottomBar para sincronizar pestañas.
///   - onRefresh (VoidCallback?): Callback opcional para ejecutar la recarga de datos.
///   - isRefreshing (bool): Estado de carga para el indicador del botón de recarga.
class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final String currentPath;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  /// Constructor de MainLayout.
  ///
  /// Args:
  ///   key (Key?): Llave identificadora del widget.
  ///   title (String): Título superior.
  ///   child (Widget): Cuerpo de la vista.
  ///   currentPath (String): Ruta URI actual de GoRouter.
  ///   onRefresh (VoidCallback?): Acción de refresco para la vista activa.
  ///   isRefreshing (bool): Estado de procesamiento del refresco.
  const MainLayout({
    super.key,
    required this.title,
    required this.child,
    required this.currentPath,
    this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* Encabezado superior con acción opcional de actualización */
      appBar: CustomAppBar(
        title: title,
        onRefresh: onRefresh,
        isRefreshing: isRefreshing,
      ),
      /* Cuerpo dinámico inyectado desde la vista */
      body: child,
      /* Navegación inferior persistente */
      bottomNavigationBar: CustomBottomBar(currentPath: currentPath),
    );
  }
}
