# app-guardia · Flutter

App móvil para guardias de seguridad privada de empresa prospecto.

## Stack
- Flutter 3.19+ / Dart 3.3+
- Supabase Flutter SDK
- Riverpod (state)
- Go Router (navigation)
- Hive (offline queue)
- Firebase Messaging (push)

## Setup local

```bash
# 1. Instalar Flutter (https://flutter.dev/docs/get-started/install)
flutter doctor

# 2. Configurar .env
cp ../.env.example .env
# Editar .env con SUPABASE_URL_FLUTTER y SUPABASE_ANON_KEY_FLUTTER

# 3. Configurar Firebase (para FCM)
# Descargar google-services.json (Android) → android/app/
# Descargar GoogleService-Info.plist (iOS) → ios/Runner/

# 4. Instalar dependencias
flutter pub get

# 5. Generar código (Riverpod, Hive)
dart run build_runner build --delete-conflicting-outputs

# 6. Correr
flutter run                    # device conectado o simulador
flutter run -d chrome          # web (solo para debug, no producción)
```

## Estructura de carpetas

```
lib/
├── main.dart                 # entry point
├── app.dart                  # MaterialApp + router
├── core/
│   ├── config/               # constants, theme, env
│   ├── services/             # supabase, location, tamper, fcm
│   ├── models/               # entidades (Guard, Shift, Event)
│   ├── utils/                # helpers, formatters
│   └── widgets/              # componentes compartidos
├── features/
│   ├── auth/                 # login con código + PIN
│   ├── shifts/               # mi turno actual
│   ├── checkin/              # flujo check-in con mapa y validación
│   ├── history/              # historial de turnos
│   ├── bitacora/             # novedades
│   └── profile/              # perfil + logout
└── data/
    ├── repositories/         # interfaces
    ├── datasources/          # supabase rpc + rest
    └── offline/              # hive queue + sync worker
```

## Tests

```bash
flutter test                                          # unit + widget
patrol test                                           # E2E (requiere device)
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

## Build de producción

```bash
# iOS
flutter build ipa --release --flavor prod

# Android
flutter build appbundle --release --flavor prod
```

## Releases

Versionado semántico en `pubspec.yaml`. Tag de Git `v*.*.*` dispara workflow de CI/CD.
