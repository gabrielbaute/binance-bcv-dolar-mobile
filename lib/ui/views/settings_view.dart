import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/ntfy_provider.dart';
import '../../providers/theme_provider.dart';
import '../components/toggle_activation_button.dart';
import '../layouts/main_layout.dart';

/// Vista de configuración general de la aplicación.
///
/// Permite gestionar las preferencias de tema visual, el estado de las
/// notificaciones push NTFY y accesos directos al sistema de logs e información.
class SettingsView extends StatelessWidget {
  /// Variables de entorno para las pruebas de suscripción NTFY.
  static const String _ntfyTopicUrl = String.fromEnvironment(
    'NTFY_TOPIC_URL',
    defaultValue: 'https://some-ntfy-server',
  );
  static const String _ntfyUsername = String.fromEnvironment(
    'NTFY_USERNAME',
    defaultValue: 'newuser85',
  );
  static const String _ntfyPassword = String.fromEnvironment(
    'NTFY_PASSWORD',
    defaultValue: 'some-secure-pass',
  );

  /// Ruta actual para mantener la sincronización con el layout principal.
  final String currentPath;

  /// Crea una instancia de [SettingsView].
  ///
  /// Args:
  ///   - key (Key?): Llave identificadora del widget.
  ///   - currentPath (String): Ruta URI actual.
  const SettingsView({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final ntfyProvider = context.watch<NtfyProvider>();

    return MainLayout(
      title: 'Configuración',
      currentPath: currentPath,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /* Sección de Apariencia y Tema */
            Text(
              'Apariencia',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Modo Oscuro',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                'Alternar entre tema claro y oscuro',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            /* Sección de Notificaciones Push */
            Text(
              'Notificaciones',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ToggleActivationButton(
              title: 'Notificaciones Push (NTFY)',
              subtitle: 'Suscripción al servidor autónomo de tasas',
              icon: Icons.notifications_active_rounded,
              value: ntfyProvider.isSubscribed,
              isLoading: ntfyProvider.isLoading,
              onChanged: (bool enabled) async {
                await ntfyProvider.toggleNotifications(
                  topicUrl: _ntfyTopicUrl,
                  username: _ntfyUsername.isNotEmpty ? _ntfyUsername : null,
                  password: _ntfyPassword.isNotEmpty ? _ntfyPassword : null,
                );

                if (ntfyProvider.errorMessage != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ntfyProvider.errorMessage!),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24.0),

            /* Sección de Sistema y Enlaces */
            Text(
              'Sistema e Información',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.terminal_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Registros del Sistema'),
                    subtitle: const Text(
                      'Ver consola e historial de eventos en vivo',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/logs'),
                  ),
                  const Divider(height: 1.0),
                  ListTile(
                    leading: Icon(
                      Icons.info_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Acerca de'),
                    subtitle: const Text(
                      'Versión, filosofía Open Source y enlaces',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/about'),
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
