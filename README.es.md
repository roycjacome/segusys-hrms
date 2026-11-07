# Repo de desarrollo · Sistema Segusys · MVP

Estructura tipo monorepo con cuatro workspaces independientes que se despliegan por separado.

## Estructura

```
04-desarrollo/
├── app-guardia/         Flutter (Dart) · iOS + Android
├── panel-admin/         Next.js 14 · panel administrativo
├── app-admin-cliente/   Flutter (Dart) · app movil admin/supervisor/cliente
├── supabase/            Migraciones SQL + Edge Functions (Deno)
├── scripts/             Bootstrap, deploy, utilidades
├── docs/                Documentación operativa adicional
└── .env.example         Variables de entorno (copia a .env por workspace)
```

## Quick start

```bash
# 1. Clonar e instalar dependencias raíz
npm install -g supabase
brew install flutter      # o https://flutter.dev/docs/get-started/install

# 2. Crear proyecto Supabase y aplicar migraciones
cd supabase
supabase login
supabase link --project-ref <tu-proyecto-ref>
supabase db push

# 3. Levantar panel admin en local
cd ../panel-admin
cp ../.env.example .env.local
# editar .env.local con keys de Supabase
npm install
npm run dev
# → http://localhost:3000

# 4. Levantar app móvil de guardia
cd ../app-guardia
cp ../.env.example .env
# editar .env con keys
flutter pub get
flutter run                # device/simulator

# 5. Levantar app móvil admin/cliente
cd ../app-admin-cliente
cp ../.env.example .env
flutter pub get
flutter run

# 6. Cargar seeds
cd ../supabase
supabase db execute --file ../03-diseno/seeds.sql
```

## Convenciones

- **Branching:** `main` (producción), `staging` (pre-prod), `feat/*`, `fix/*`
- **Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`)
- **PRs:** Requieren CI verde + 1 review + actualización de CHANGELOG
- **Migraciones:** Solo se añaden, nunca se editan después de mergear

## Workspaces

| Workspace | Stack | Despliegue | README |
|---|---|---|---|
| `app-guardia/` | Flutter 3.x · Riverpod · Hive | App Store + Play Store | [README](app-guardia/README.md) |
| `panel-admin/` | Next.js 14 · TypeScript · Tailwind | Vercel | [README](panel-admin/README.md) |
| `app-admin-cliente/` | Flutter 3.x · Riverpod | App Store + Play Store | [README](app-admin-cliente/README.md) |
| `supabase/` | PostgreSQL 15 · Deno | Supabase Cloud | [README](supabase/README.md) |

## Documentación de arquitectura

Ver [`../03-diseno/`](../03-diseno/):
- `arquitectura-mvp.md` · documento maestro
- `esquema-bd.sql` · esquema base
- `rls-policies.sql` · row level security
- `rpc-functions.sql` · funciones RPC
- `diagrama-arquitectura.svg` · vista de capas
- `diagrama-flujo-checkin.svg` · flujo crítico de check-in
- `diagrama-flujo-offline.svg` · sincronización offline
- `diagrama-flujo-auth.svg` · autenticación

Ver tambien:
- [`docs/conexion-supabase.md`](docs/conexion-supabase.md) · como pasar de demo local a datos reales

## Plan de sprints

- **Sprint 0 (1 sem):** CI/CD, auth E2E, deploy a staging
- **Sprint 1-2 (4 sem):** App de guardia: login, mi turno, check-in/out con GPS y validación
- **Sprint 3-4 (4 sem):** Panel admin: CRUD guardias/ubicaciones/clientes, dashboard live, export
- **Sprint 5 (2 sem):** App admin/cliente, portal cliente movil, modo offline, bitácora, historial, polish UI
- **Sprint 6 (1 sem):** QA, capacitación, lanzamiento

## Contacto

- Cliente: Sponsor piloto (Empresa de Seguridad Privada Demo)
- Development: Roy Camacho
