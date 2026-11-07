import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../theme.dart';
import '../widgets/segusys_shell.dart';

class ClientDashboardScreen extends ConsumerWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(clientSummaryProvider);

    return summary.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('No se pudo cargar el portal'))),
      data: (data) => SegusysShell(
        title: 'Portal movil cliente',
        subtitle: 'Estado de ubicaciones, evidencias e incidencias.',
        homePath: '/client',
        children: [
          MetricCard(
            label: 'Sitios protegidos',
            value: data.protectedSites.toString(),
            detail: 'Todos con cobertura activa',
            icon: Icons.location_on_outlined,
            color: SegusysPalette.cyan,
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Cumplimiento',
            value: data.compliance,
            detail: 'Rondas y presencia del periodo',
            icon: Icons.check_circle_outline,
            color: SegusysPalette.success,
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Incidencias',
            value: data.incidents.toString(),
            detail: '1 resuelta, 1 en seguimiento',
            icon: Icons.report_outlined,
          ),
          ListPanel(title: 'Ultimas evidencias', items: data.evidence),
        ],
      ),
    );
  }
}
