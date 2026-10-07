import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/logs_provider.dart';
import '../components/empty_logs.dart';
import '../components/log_actions.dart';
import '../components/log_filter.dart';
import '../components/log_list.dart';

/// Vista principal encargada de renderizar la consola e historial de eventos de la aplicación.
///
/// Inyecta el [LogsProvider] mediante un patrón de proveedor local y gestiona
/// el ensamblado de los componentes de filtrado, listado y acciones.
class LogsView extends StatelessWidget {
  /// Crea una instancia de [LogsView].
  const LogsView({super.key});

  /// Copia el contenido formateado del historial de logs al portapapeles del dispositivo.
  ///
  /// Args:
  ///   - `context` (BuildContext): Contexto para la presentación de notificaciones SnackBar.
  ///   - `provider` (LogsProvider): Instancia del proveedor para extraer los logs en formato texto.
  ///
  /// Returns:
  ///   - `void`
  void _copyToClipboard(BuildContext context, LogsProvider provider) {
    final formattedText = provider.getFormattedLogs();
    Clipboard.setData(ClipboardData(text: formattedText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registros copiados al portapapeles'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Despliega un diálogo de confirmación previo a la purga de registros de memoria.
  ///
  /// Args:
  ///   - `context` (BuildContext): Contexto de construcción del diálogo de confirmación.
  ///   - `provider` (LogsProvider): Instancia del proveedor que ejecutará la acción de borrado.
  ///
  /// Returns:
  ///   - `void`
  void _confirmClearLogs(BuildContext context, LogsProvider provider) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Limpiar historial'),
          content: const Text(
            '¿Está seguro de que desea eliminar todos los registros de eventos de la memoria?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                provider.clearLogs();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Limpiar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /* Inyección del proveedor de registros para el árbol de widgets subyacente */
    return ChangeNotifierProvider<LogsProvider>(
      create: (_) => LogsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registros del Sistema'),
          elevation: 0,
        ),
        body: Consumer<LogsProvider>(
          builder: (context, provider, child) {
            final filteredLogs = provider.filteredLogs;

            return Column(
              children: [
                /* Selector desplegable de nivel de severidad */
                LogFilter(
                  selectedFilter: provider.selectedFilter,
                  onFilterSelected: provider.setFilter,
                ),

                /* Área principal de visualización de eventos */
                Expanded(
                  child: provider.isEmpty
                      ? const EmptyLogs()
                      : LogList(logs: filteredLogs),
                ),

                /* Barra inferior de acciones (Copiar y Limpiar) */
                LogActions(
                  isEmpty: provider.logs.isEmpty,
                  onCopy: () => _copyToClipboard(context, provider),
                  onClear: () => _confirmClearLogs(context, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
