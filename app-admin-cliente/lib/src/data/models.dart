class AdminSummary {
  final String coverage;
  final String coveredShifts;
  final int hrAlerts;
  final int openIncidents;
  final List<String> recommendedActions;

  const AdminSummary({
    required this.coverage,
    required this.coveredShifts,
    required this.hrAlerts,
    required this.openIncidents,
    required this.recommendedActions,
  });
}

class ClientSummary {
  final int protectedSites;
  final String compliance;
  final int incidents;
  final List<String> evidence;

  const ClientSummary({
    required this.protectedSites,
    required this.compliance,
    required this.incidents,
    required this.evidence,
  });
}

class LocationStatus {
  final String name;
  final String guards;
  final String status;

  const LocationStatus(this.name, this.guards, this.status);
}

class IncidentSummary {
  final String title;
  final String owner;
  final String priority;

  const IncidentSummary(this.title, this.owner, this.priority);
}
