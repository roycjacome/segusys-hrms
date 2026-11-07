import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/login_screen.dart';
import '../../features/shifts/home_screen.dart';
import '../../features/checkin/checkin_screen.dart';
import '../../features/checkin/checkin_success_screen.dart';
import '../../features/checkin/checkout_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/bitacora/bitacora_screen.dart';
import '../../features/profile/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggedIn = session != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: '/checkin/:shiftId',
        builder: (_, s) => CheckinScreen(shiftId: s.pathParameters['shiftId']!),
      ),
      GoRoute(
        path: '/checkin-success',
        builder: (_, s) {
          final folio = s.uri.queryParameters['folio'] ?? '';
          return CheckinSuccessScreen(folio: folio);
        },
      ),
      GoRoute(
        path: '/checkout/:shiftId',
        builder: (_, s) => CheckoutScreen(shiftId: s.pathParameters['shiftId']!),
      ),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(path: '/bitacora', builder: (_, __) => const BitacoraScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    ],
  );
});
