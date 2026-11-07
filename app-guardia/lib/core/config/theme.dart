import 'package:flutter/material.dart';

/// Tema visual Segusys · modo oscuro (apropiado para turnos nocturnos).
const _bg = Color(0xFF0A1628);
const _surface = Color(0xFF14233D);
const _surface2 = Color(0xFF1F3252);
const _accent = Color(0xFFF59E0B);
const _accent2 = Color(0xFF00B4D8);
const _success = Color(0xFF10B981);
const _danger = Color(0xFFEF4444);
const _text = Color(0xFFE5E7EB);
const _muted = Color(0xFF94A3B8);

final segusysDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _bg,
  primaryColor: _accent,
  colorScheme: const ColorScheme.dark(
    primary: _accent,
    secondary: _accent2,
    error: _danger,
    surface: _surface,
    onPrimary: Color(0xFF1F1100),
    onSecondary: Color(0xFF003044),
    onSurface: _text,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: _text),
    bodySmall: TextStyle(color: _muted),
  ),
  cardTheme: const CardTheme(
    color: _surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: _accent,
      foregroundColor: const Color(0xFF1F1100),
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
    ),
  ),
);

class SegusysColors {
  static const bg = _bg;
  static const surface = _surface;
  static const surface2 = _surface2;
  static const accent = _accent;
  static const accent2 = _accent2;
  static const success = _success;
  static const danger = _danger;
  static const text = _text;
  static const muted = _muted;
}
