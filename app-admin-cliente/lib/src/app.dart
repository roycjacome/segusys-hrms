import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/admin_dashboard_screen.dart';
import 'features/client_dashboard_screen.dart';
import 'features/incidents_screen.dart';
import 'features/locations_screen.dart';
import 'features/login_screen.dart';
import 'features/reports_screen.dart';
import 'theme.dart';

final selectedModeProvider = StateProvider<AppMode>((ref) => AppMode.admin);

enum AppMode { admin, client }

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: '/client', builder: (_, __) => const ClientDashboardScreen()),
      GoRoute(path: '/incidents', builder: (_, __) => const IncidentsScreen()),
      GoRoute(path: '/locations', builder: (_, __) => const LocationsScreen()),
      GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
    ],
  );
});

class SegusysAdminClienteApp extends ConsumerWidget {
  const SegusysAdminClienteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Segusys Admin Cliente',
      debugShowCheckedModeBanner: false,
      theme: segusysTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
