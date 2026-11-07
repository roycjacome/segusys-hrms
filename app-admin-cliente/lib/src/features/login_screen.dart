import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../theme.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(selectedModeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const _Brand(),
              const SizedBox(height: 28),
              const Text(
                'App Admin y Cliente',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visibilidad movil para direccion, supervisores y clientes finales.',
                style: TextStyle(color: SegusysPalette.muted, height: 1.5),
              ),
              const SizedBox(height: 28),
              SegmentedButton<AppMode>(
                segments: const [
                  ButtonSegment(value: AppMode.admin, label: Text('Admin')),
                  ButtonSegment(value: AppMode.client, label: Text('Cliente')),
                ],
                selected: {mode},
                onSelectionChanged: (selection) {
                  ref.read(selectedModeProvider.notifier).state = selection.first;
                },
              ),
              const SizedBox(height: 16),
              const _Field(label: 'Correo', value: 'demo@segusys.mx'),
              const SizedBox(height: 10),
              const _Field(label: 'Contrasena', value: '••••••••'),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => context.go(mode == AppMode.admin ? '/admin' : '/client'),
                child: Text(mode == AppMode.admin ? 'ENTRAR COMO ADMIN' : 'ENTRAR COMO CLIENTE'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Demo local. Sprint siguiente: auth Supabase + RLS por rol.',
                textAlign: TextAlign.center,
                style: TextStyle(color: SegusysPalette.muted, fontSize: 12),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 62,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: SegusysPalette.accent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'S',
          style: TextStyle(
            color: Color(0xFF1F1100),
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SegusysPalette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: SegusysPalette.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
