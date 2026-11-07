import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../theme.dart';
import '../widgets/segusys_shell.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(adminSummaryProvider);

    return summary.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('No se pudo cargar la operacion'))),
      data: (data) => SegusysShell(
        title: 'Operacion nacional',
        subtitle: 'Vista movil para direccion y supervisores.',
        children: [
          MetricCard(
            label: 'Cobertura hoy',
            value: data.coverage,
            detail: data.coveredShifts,
            icon: Icons.verified_user_outlined,
            color: SegusysPalette.success,
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Alertas HRMS',
            value: data.hrAlerts.toString(),
            detail: 'Documentos o cursos por vencer',
            icon: Icons.folder_copy_outlined,
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Incidencias abiertas',
            value: data.openIncidents.toString(),
            detail: '2 prioridad alta',
            icon: Icons.warning_amber_outlined,
            color: SegusysPalette.danger,
          ),
          ListPanel(
            title: 'Acciones recomendadas',
            items: data.recommendedActions,
          ),
        ],
      ),
    );
  }
}
