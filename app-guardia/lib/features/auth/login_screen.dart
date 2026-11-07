import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: SegusysColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'S',
                  style: TextStyle(
                    color: Color(0xFF1F1100),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Segusys Guardia',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Control de turno para empresas mexicanas de seguridad privada.',
                style: TextStyle(color: SegusysColors.muted, height: 1.5),
              ),
              const SizedBox(height: 36),
              const _DemoField(label: 'Codigo de empleado', value: 'SEG-1042'),
              const SizedBox(height: 12),
              const _DemoField(label: 'PIN', value: '••••'),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {},
                child: const Text('ENTRAR EN MODO DEMO'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sprint siguiente: conectar rpc_verify_pin y sesion Supabase.',
                textAlign: TextAlign.center,
                style: TextStyle(color: SegusysColors.muted, fontSize: 12),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoField extends StatelessWidget {
  const _DemoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: SegusysColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: SegusysColors.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
