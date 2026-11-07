import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';

class CheckinScreen extends ConsumerWidget {
  const CheckinScreen({required this.shiftId, super.key});

  final String shiftId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar ubicacion')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: SegusysColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: SegusysColors.accent.withOpacity(0.5), width: 2),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: SegusysColors.accent2,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Positioned(
                    bottom: 18,
                    child: Text('Dentro de geocerca · 18m del punto', style: TextStyle(color: SegusysColors.muted)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _Validation(label: 'GPS preciso', value: 'Precision 9m', ok: true),
            const _Validation(label: 'Sin manipulacion', value: 'Mock location apagado', ok: true),
            const _Validation(label: 'Ventana de turno', value: 'Check-in permitido', ok: true),
            const Spacer(),
            FilledButton(
              onPressed: () {},
              child: Text('CONFIRMAR CHECK-IN $shiftId'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Validation extends StatelessWidget {
  const _Validation({required this.label, required this.value, required this.ok});

  final String label;
  final String value;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SegusysColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ok ? SegusysColors.success.withOpacity(0.4) : SegusysColors.danger),
      ),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.error, color: ok ? SegusysColors.success : SegusysColors.danger),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(value, style: const TextStyle(color: SegusysColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
