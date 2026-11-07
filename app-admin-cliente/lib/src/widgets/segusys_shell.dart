import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class SegusysShell extends StatelessWidget {
  const SegusysShell({
    required this.title,
    required this.subtitle,
    required this.children,
    this.homePath = '/admin',
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String homePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: SegusysPalette.muted, height: 1.4)),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: SegusysPalette.surface,
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) {
          final routes = [homePath, '/locations', '/incidents', '/reports'];
          context.go(routes[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.location_on_outlined), label: 'Sitios'),
          NavigationDestination(icon: Icon(Icons.report_problem_outlined), label: 'Alertas'),
          NavigationDestination(icon: Icon(Icons.summarize_outlined), label: 'Reportes'),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final path = GoRouterState.of(context).matchedLocation;
    if (path.startsWith('/client')) return 0;
    if (path.startsWith('/locations')) return 1;
    if (path.startsWith('/incidents')) return 2;
    if (path.startsWith('/reports')) return 3;
    return 0;
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    this.color = SegusysPalette.accent,
    super.key,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SegusysPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: SegusysPalette.muted)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(color: SegusysPalette.muted, fontSize: 12)),
              ],
            ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );
  }
}

class ListPanel extends StatelessWidget {
  const ListPanel({required this.title, required this.items, super.key});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SegusysPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(item, style: const TextStyle(color: SegusysPalette.muted)),
            ),
        ],
      ),
    );
  }
}
