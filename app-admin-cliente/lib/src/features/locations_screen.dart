import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../widgets/segusys_shell.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);

    return locations.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('No se pudieron cargar ubicaciones'))),
      data: (items) => SegusysShell(
        title: 'Ubicaciones',
        subtitle: 'Clientes finales, geocercas y estado de cobertura.',
        children: [
          ListPanel(
            title: 'Sitios activos',
            items: items.map((item) => '${item.name} · ${item.guards} · ${item.status}.').toList(),
          ),
        ],
      ),
    );
  }
}
