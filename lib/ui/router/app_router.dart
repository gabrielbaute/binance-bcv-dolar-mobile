import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/promedio_view.dart';
import '../views/realtime_view.dart';
import '../views/history_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router centralizado de la aplicación.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/promedio',
    routes: <RouteBase>[
      GoRoute(
        path: '/promedio',
        builder: (BuildContext context, GoRouterState state) {
          return PromedioView(currentPath: state.uri.toString());
        },
      ),
      GoRoute(
        path: '/realtime',
        builder: (BuildContext context, GoRouterState state) {
          return RealtimeView(currentPath: state.uri.toString());
        },
      ),
      GoRoute(
        path: '/history',
        builder: (BuildContext context, GoRouterState state) {
          return HistoryView(currentPath: state.uri.toString());
        },
      ),
    ],
  );
}
