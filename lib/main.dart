import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dolar_promedio_provider.dart';
import 'providers/realtime_provider.dart';
import 'providers/history_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DolarPromedioProvider()),
        ChangeNotifierProvider(create: (_) => RealtimeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

/// Widget raíz de la aplicación.
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
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Dolar Pulse VE'))),
    );
  }
}
