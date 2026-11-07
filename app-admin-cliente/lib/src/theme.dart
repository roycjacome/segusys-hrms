import 'package:flutter/material.dart';

class SegusysPalette {
  static const bg = Color(0xFF07111F);
  static const surface = Color(0xFF14233D);
  static const surface2 = Color(0xFF1F3252);
  static const accent = Color(0xFFF59E0B);
  static const cyan = Color(0xFF00B4D8);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const text = Color(0xFFE5E7EB);
  static const muted = Color(0xFF94A3B8);
}

final segusysTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: SegusysPalette.bg,
  colorScheme: const ColorScheme.dark(
    primary: SegusysPalette.accent,
    secondary: SegusysPalette.cyan,
    surface: SegusysPalette.surface,
    error: SegusysPalette.danger,
    onPrimary: Color(0xFF1F1100),
    onSurface: SegusysPalette.text,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: SegusysPalette.bg,
    foregroundColor: SegusysPalette.text,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: SegusysPalette.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: SegusysPalette.accent,
      foregroundColor: const Color(0xFF1F1100),
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
);
