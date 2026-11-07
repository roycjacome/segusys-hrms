import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_repository.dart';
import 'supabase_app_repository.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) {
  try {
    return SupabaseAppRepository(Supabase.instance.client);
  } catch (_) {
    return const DemoAppRepository();
  }
});

final adminSummaryProvider = FutureProvider((ref) {
  return ref.watch(appRepositoryProvider).getAdminSummary();
});

final clientSummaryProvider = FutureProvider((ref) {
  return ref.watch(appRepositoryProvider).getClientSummary();
});

final locationsProvider = FutureProvider((ref) {
  return ref.watch(appRepositoryProvider).getLocations();
});

final incidentsProvider = FutureProvider((ref) {
  return ref.watch(appRepositoryProvider).getIncidents();
});

final reportsProvider = FutureProvider((ref) {
  return ref.watch(appRepositoryProvider).getReports();
});
