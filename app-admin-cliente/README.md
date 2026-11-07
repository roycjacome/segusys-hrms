# app-admin-cliente · Flutter

App movil para administradores, supervisores y clientes finales de empresas de seguridad privada.

## Objetivo

Dar visibilidad rapida fuera de oficina:

- **Admin / direccion:** cobertura, asistencia, alertas HRMS, incidencias y pre-nomina.
- **Supervisor:** turnos activos, guardias por ubicacion, incidencias y acciones de campo.
- **Cliente final:** estado de sus ubicaciones, evidencias, bitacora y cumplimiento.

## Stack

- Flutter 3.19+ / Dart 3.3+
- Supabase Flutter SDK
- Riverpod
- Go Router
- Firebase Messaging
- Sentry

## Setup local

```bash
cp ../.env.example .env
flutter pub get
flutter run
```

## Pantallas iniciales

- Login email/password.
- Selector de rol demo: admin o cliente.
- Dashboard admin.
- Dashboard cliente.
- Incidencias.
- Ubicaciones.
- Reportes.

