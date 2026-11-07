import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../widgets/segusys_shell.dart';

class IncidentsScreen extends ConsumerWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentsProvider);

    return incidents.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('No se pudieron cargar incidencias'))),
      data: (items) {
        final high = items.where((item) => item.priority == 'Alta').toList();
        final followUp = items.where((item) => item.priority != 'Alta').toList();

        return SegusysShell(
          title: 'Alertas e incidencias',
          subtitle: 'Eventos operativos que requieren seguimiento.',
          children: [
            ListPanel(
              title: 'Prioridad alta',
              items: high.map((item) => '${item.title} · ${item.owner}.').toList(),
            ),
            ListPanel(
              title: 'En seguimiento',
              items: followUp.map((item) => '${item.title} · ${item.owner} · ${item.priority}.').toList(),
            ),
          ],
        );
      },
    );
  }
}
