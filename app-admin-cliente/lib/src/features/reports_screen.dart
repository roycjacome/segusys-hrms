import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../theme.dart';
import '../widgets/segusys_shell.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);

    return reports.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('No se pudieron cargar reportes'))),
      data: (items) => SegusysShell(
        title: 'Reportes',
        subtitle: 'Cierres operativos para direccion y clientes.',
        children: [
          const MetricCard(
            label: 'Pre-nomina',
            value: 'Lista',
            detail: 'Periodo semanal validado',
            icon: Icons.payments_outlined,
            color: SegusysPalette.success,
          ),
          const SizedBox(height: 12),
          ListPanel(title: 'Reportes disponibles', items: items),
        ],
      ),
    );
  }
}
