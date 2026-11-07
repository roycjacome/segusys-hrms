import 'package:flutter/material.dart';

/// Confirmación post-checkin con folio.
/// Wireframe en `03-diseno/mockups-app-guardia.html` (pantalla 05).
class CheckinSuccessScreen extends StatelessWidget {
  const CheckinSuccessScreen({required this.folio, super.key});
  final String folio;
  @override
  Widget build(BuildContext c) =>
      Scaffold(body: Center(child: Text('✓ Folio: $folio')));
}
