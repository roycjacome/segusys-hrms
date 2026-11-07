import 'models.dart';

abstract class AppRepository {
  Future<AdminSummary> getAdminSummary();
  Future<ClientSummary> getClientSummary();
  Future<List<LocationStatus>> getLocations();
  Future<List<IncidentSummary>> getIncidents();
  Future<List<String>> getReports();
}

class DemoAppRepository implements AppRepository {
  const DemoAppRepository();

  @override
  Future<AdminSummary> getAdminSummary() async {
    return const AdminSummary(
      coverage: '96%',
      coveredShifts: '74 de 77 turnos cubiertos',
      hrAlerts: 18,
      openIncidents: 7,
      recommendedActions: [
        'Cubrir 3 turnos pendientes antes de las 18:00.',
        'Revisar certificaciones proximas a vencer.',
        'Autorizar export de pre-nomina semanal.',
      ],
    );
  }

  @override
  Future<ClientSummary> getClientSummary() async {
    return const ClientSummary(
      protectedSites: 4,
      compliance: '98%',
      incidents: 2,
      evidence: [
        '07:08 Check-in confirmado · Planta Industrial Apodaca.',
        '09:14 Bitacora: acceso de proveedor registrado.',
        '11:30 Ronda perimetral sin novedad.',
      ],
    );
  }

  @override
  Future<List<LocationStatus>> getLocations() async {
    return const [
      LocationStatus('Planta Industrial Apodaca', '12 guardias', 'Cobertura completa'),
      LocationStatus('Centro Logistico Tlalnepantla', '8 guardias', '1 pendiente'),
      LocationStatus('Torre Corporativa Reforma', '6 guardias', 'Sincronizando offline'),
      LocationStatus('Parque Industrial Queretaro', '10 guardias', 'Sin novedad'),
    ];
  }

  @override
  Future<List<IncidentSummary>> getIncidents() async {
    return const [
      IncidentSummary('Check-in omitido', 'Centro Logistico Tlalnepantla', 'Alta'),
      IncidentSummary('Documento vencido', 'Luis Moreno', 'Alta'),
      IncidentSummary('Acceso no autorizado', 'Planta Industrial Apodaca', 'Media'),
      IncidentSummary('Equipo pendiente de retorno', 'Jorge Luna', 'Media'),
    ];
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
