import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/theme.dart';
import 'core/config/router.dart';

class SegusysApp extends ConsumerWidget {
  const SegusysApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Segusys · Guardia',
      debugShowCheckedModeBanner: false,
      theme: segusysDarkTheme,
      routerConfig: router,
    );
  }
}
