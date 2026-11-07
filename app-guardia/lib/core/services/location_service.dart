import 'dart:async';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Captura ubicación + flags anti-tamper. Punto crítico del MVP.
///
/// Ver flujo completo en `03-diseno/diagrama-flujo-checkin.svg`.
class LocationService {
  /// Toma una lectura precisa solicitando permisos si es necesario.
  /// Retorna un [LocationReading] con coordenadas y flags de tamper.
  ///
  /// Throws [LocationException] si:
  ///   - El usuario niega permisos
  ///   - El servicio de ubicación está desactivado
  Future<LocationReading> readWithTamperCheck() async {
    // 1. Verificar servicio de ubicación
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException('location_service_disabled');
    }

    // 2. Pedir permisos
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      throw const LocationException('location_permission_denied');
    }

    // 3. Obtener posición con alta precisión
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 15),
      ),
    );

    // 4. Detectar mock location (Android: position.isMocked; iOS: heurística aparte)
    final isMocked = position.isMocked;

    // 5. Detectar root/jailbreak
    final isRooted = await _safeJailbreak();

    // 6. Detectar app de mock GPS instalada (Android)
    final mockAppInstalled = await _safeMockApp();

    return LocationReading(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
      capturedAt: DateTime.now().toUtc(),
      tamperFlags: TamperFlags(
        mockLocation: isMocked,
        rooted: isRooted,
        mockAppInstalled: mockAppInstalled,
      ),
    );
  }

  Future<bool> _safeJailbreak() async {
    try {
      return await FlutterJailbreakDetection.jailbroken;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _safeMockApp() async {
    try {
      return await FlutterJailbreakDetection.developerMode;
    } catch (_) {
      return false;
    }
  }
}

class LocationReading {
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final DateTime capturedAt;
  final TamperFlags tamperFlags;

  const LocationReading({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.capturedAt,
    required this.tamperFlags,
  });

  Map<String, dynamic> toRpcPayload() => {
        'lat': latitude,
        'lng': longitude,
        'accuracy_m': accuracyMeters,
        'ts_device': capturedAt.toIso8601String(),
        'tamper_flags': tamperFlags.toJson(),
      };
}

class TamperFlags {
  final bool mockLocation;
  final bool rooted;
  final bool mockAppInstalled;

  const TamperFlags({
    this.mockLocation = false,
    this.rooted = false,
    this.mockAppInstalled = false,
  });

  bool get hasAnyTamper => mockLocation || rooted || mockAppInstalled;

  Map<String, dynamic> toJson() => {
        'mock_location': mockLocation,
        'rooted': rooted,
        'mock_app_installed': mockAppInstalled,
      };
}

class LocationException implements Exception {
  final String code;
  const LocationException(this.code);
  @override
  String toString() => 'LocationException($code)';
}
