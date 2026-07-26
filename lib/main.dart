import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dolar_promedio_provider.dart';
import 'providers/history_provider.dart';
import 'providers/realtime_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/themes/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DolarPromedioProvider()),
        ChangeNotifierProvider(create: (_) => RealtimeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

/// Widget raíz de la aplicación que configura el tema y la navegación principal.
///
/// Attributes:
///   - key (Key?): Llave identificadora del widget.
class MainApp extends StatelessWidget {
  /// Constructor de MainApp.
  ///
  /// Args:
  ///   key (Key?): Llave del widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Dolar Pulse VE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const Scaffold(body: Center(child: Text('Dolar Pulse VE'))),
    );
  }
}
