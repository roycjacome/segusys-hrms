import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_repository.dart';
import 'models.dart';

class SupabaseAppRepository implements AppRepository {
  SupabaseAppRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<AdminSummary> getAdminSummary() async {
    final results = await Future.wait([
      _client.from('v_live_presence').select('*'),
      _client.from('v_guard_hr_alerts').select('*'),
      _client.from('incidents').select('id, severity, resolved').eq('resolved', false),
    ]);

    final presence = List<Map<String, dynamic>>.from(results[0] as List);
    final hr = List<Map<String, dynamic>>.from(results[1] as List);
    final incidents = List<Map<String, dynamic>>.from(results[2] as List);

    final activeOrCovered = presence.where((row) {
      final status = row['live_status']?.toString();
      return status == 'on_duty' || status == 'upcoming';
    }).length;

    final coverage = presence.isEmpty ? '100%' : '${((activeOrCovered / presence.length) * 100).round()}%';

    final expiring = hr.fold<int>(0, (sum, row) {
      return sum +
          ((row['documents_expiring_30d'] as num?)?.toInt() ?? 0) +
          ((row['trainings_expiring_30d'] as num?)?.toInt() ?? 0);
    });

    final highPriority = incidents.where((row) => ((row['severity'] as num?)?.toInt() ?? 1) >= 4).length;

    return AdminSummary(
      coverage: coverage,
      coveredShifts: '$activeOrCovered de ${presence.length} turnos cubiertos',
      hrAlerts: expiring,
      openIncidents: incidents.length,
      recommendedActions: [
        if (presence.any((row) => row['live_status'] == 'missed')) 'Revisar turnos perdidos del dia.',
        if (expiring > 0) 'Revisar documentos y capacitaciones por vencer.',
        if (highPriority > 0) 'Atender $highPriority incidencias de prioridad alta.',
        if (presence.isEmpty && expiring == 0 && highPriority == 0) 'Operacion sin alertas criticas.',
      ],
    );
  }

  @override
  Future<ClientSummary> getClientSummary() async {
    final locations = await getLocations();
    final incidents = await getIncidents();
    final openIncidents = incidents.length;
    final cleanSites = locations.where((item) => !item.status.toLowerCase().contains('incidencia')).length;
    final compliance = locations.isEmpty ? '100%' : '${((cleanSites / locations.length) * 100).round()}%';

    return ClientSummary(
      protectedSites: locations.length,
      compliance: compliance,
      incidents: openIncidents,
      evidence: [
        for (final location in locations.take(3)) '${location.name} · ${location.status}.',
      ],
    );
  }

  @override
  Future<List<LocationStatus>> getLocations() async {
    final rows = await _client
        .from('v_client_location_status')
        .select('*')
        .order('location_name');

    return List<Map<String, dynamic>>.from(rows as List).map((row) {
      final active = row['active_shifts'] ?? 0;
      final today = row['shifts_today'] ?? 0;
      final openIncidents = row['open_incidents'] ?? 0;
      return LocationStatus(
        row['location_name']?.toString() ?? 'Ubicacion',
        '$active/$today turnos activos',
        (openIncidents as num).toInt() > 0 ? '$openIncidents incidencias abiertas' : 'Sin novedad',
      );
    }).toList();
  }

  @override
  Future<List<IncidentSummary>> getIncidents() async {
    final rows = await _client
        .from('incidents')
        .select('title, type, severity, shifts(locations(name))')
        .eq('resolved', false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows as List).map((row) {
      final severity = ((row['severity'] as num?)?.toInt() ?? 1);
      final shifts = row['shifts'] as Map<String, dynamic>?;
      final location = shifts?['locations'] as Map<String, dynamic>?;
      return IncidentSummary(
        row['title']?.toString() ?? row['type']?.toString() ?? 'Incidencia',
        location?['name']?.toString() ?? 'Ubicacion',
        severity >= 4 ? 'Alta' : severity >= 2 ? 'Media' : 'Baja',
      );
    }).toList();
  }

  @override
  Future<List<String>> getReports() async {
    return const [
      'Horas trabajadas por guardia.',
      'Cumplimiento por ubicacion.',
      'Incidencias con evidencia fotografica.',
      'Documentos y certificaciones por vencer.',
    ];
  }
}
