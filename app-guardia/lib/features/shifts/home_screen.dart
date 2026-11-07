import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _Header(),
            SizedBox(height: 18),
            _ShiftCard(),
            SizedBox(height: 16),
            _StatusGrid(),
            SizedBox(height: 16),
            _HrCard(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hola, Marisol', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        SizedBox(height: 6),
        Text('SEG-1042 · Seguridad Operativa Norte', style: TextStyle(color: SegusysColors.muted)),
      ],
    );
  }
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Turno de hoy', style: TextStyle(color: SegusysColors.muted)),
            const SizedBox(height: 8),
            const Text(
              'Planta Industrial Apodaca',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text('07:00 - 19:00 · Geocerca 60m'),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {},
              child: const Text('INICIAR CHECK-IN'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusGrid extends StatelessWidget {
  const _StatusGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatusTile(label: 'GPS', value: 'Preciso', color: SegusysColors.success)),
        SizedBox(width: 10),
        Expanded(child: _StatusTile(label: 'Offline', value: 'Listo', color: SegusysColors.accent2)),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SegusysColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: SegusysColors.muted, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _HrCard extends StatelessWidget {
  const _HrCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SegusysColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expediente operativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          SizedBox(height: 12),
          Text('INE vigente · Certificacion vence en 184 dias', style: TextStyle(color: SegusysColors.muted)),
          SizedBox(height: 8),
          Text('Equipo: radio Motorola, uniforme completo, lampara', style: TextStyle(color: SegusysColors.muted)),
        ],
      ),
    );
  }
}
