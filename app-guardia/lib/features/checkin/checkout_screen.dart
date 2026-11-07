import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TODO Sprint 2: check-out con resumen + observaciones.
/// Wireframe en `03-diseno/mockups-app-guardia.html` (pantalla 07).
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({required this.shiftId, super.key});
  final String shiftId;
  @override
  Widget build(BuildContext c, WidgetRef r) =>
      Scaffold(body: Center(child: Text('Check-out shift=$shiftId')));
}
