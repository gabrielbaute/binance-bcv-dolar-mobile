import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layouts/main_layout.dart';

/// Vista de información sobre la aplicación Dolar Pulse VE, filosofía Open Source y enlaces al código fuente.
///
/// Attributes:
///   - currentPath (String): Ruta de navegación activa enviada al MainLayout.
class AboutView extends StatefulWidget {
  final String currentPath;

  /// Constructor de AboutView.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  ///   currentPath (String): Ruta activa en GoRouter.
  const AboutView({super.key, required this.currentPath});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String _version = '...';
  String _buildNumber = '...';
  bool _isLoadingInfo = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  /// Carga los datos nativos de versión y build desde el paquete de la app.
  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _isLoadingInfo = false;
      });
    } catch (_) {
      setState(() {
        _version = '1.0.0';
        _buildNumber = '1';
        _isLoadingInfo = false;
      });
    }
  }

  /// Abre un enlace externo en el navegador del dispositivo.
  ///
  /// Args:
  ///   urlString (String): URL de destino a la que se desea navegar.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir la URL: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainLayout(
      title: 'Acerca de',
      currentPath: widget.currentPath,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /* Cabecera del Proyecto */
            Center(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.currency_exchange_rounded,
                    size: 64.0,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Dolar Pulse VE',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _isLoadingInfo
                        ? 'Cargando versión...'
                        : 'Versión $_version (Build $_buildNumber)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            /* Propósito y Filosofía */
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Transparencia y Datos Libres',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Dolar Pulse VE nace de la necesidad de contar con información confiable y abierta sobre el mercado cambiario venezolano, un entorno históricamente expuesto a especulación y datos poco transparentes.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nuestro objetivo es brindar datos directos, históricos y totalmente verificables para fomentar la conciencia financiera y poner a disposición de la comunidad herramientas de libre acceso.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            /* Arquitectura Backend y Self-Hosted */
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.dns_rounded,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Infraestructura y Ecosistema',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Esta aplicación consume la API REST de BnB-BCV, un desarrollo en Python y FastAPI que lleva más de un año recolectando y procesando registros de tasas de cambio de forma ininterrumpida.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Fieles a la filosofía de soberanía digital y self-hosting, puedes clonar nuestro código fuente, compilar tu propia versión del cliente Flutter e inyectar la URL de tu propia instancia de BnB-BCV para gestionar tus datos o agregar nuevas monedas.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            /* Código Fuente y Repositorios */
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.code_rounded,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Código Fuente y Verificación',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Creemos en la verificación abierta. Consulta y audita el código de ambos proyectos en GitHub:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12.0),
                    OutlinedButton.icon(
                      onPressed: () => _launchURL(
                        'https://github.com/gabrielbaute/binance-bcv-dolar-mobile',
                      ),
                      icon: const Icon(Icons.phone_android_rounded),
                      label: const Text('App Móvil (Dolar Pulse VE)'),
                    ),
                    const SizedBox(height: 8.0),
                    OutlinedButton.icon(
                      onPressed: () => _launchURL(
                        'https://github.com/gabrielbaute/binance-bcv-dolar',
                      ),
                      icon: const Icon(Icons.dns_rounded),
                      label: const Text('Servidor Backend (BnB-BCV)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            /* Reconocimientos */
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.favorite_rounded, color: Colors.redAccent),
                        const SizedBox(width: 8.0),
                        Text(
                          'Reconocimientos',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Un agradecimiento especial al usuario @DevOpsLP por publicar el script original en Google Apps Script que sirvió de punto de partida para integrar las tasas del P2P de Binance.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            /* Pie de Licencia */
            Center(
              child: Text(
                'Licencia GNU General Public License v3.0 (GPLv3)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
