# supabase · Backend

Configuración del proyecto Supabase: migraciones SQL + Edge Functions.

## Setup local (Docker)

```bash
npm install -g supabase
supabase init                  # solo primera vez
supabase start                 # arranca Postgres + Auth + Storage en local

# Aplicar migraciones
supabase db reset              # destruye + aplica todo

# Cargar seeds
psql -h localhost -p 54322 -U postgres -d postgres -f ../../03-diseno/seeds.sql
```

## Setup producción

```bash
supabase login
supabase link --project-ref <ref-del-proyecto>

# Aplicar SQL
supabase db push

# Subir secretos para Edge Functions
supabase secrets set FCM_SERVER_KEY=AAAA...
supabase secrets set SLACK_WEBHOOK_ALERTS=https://...

# Deploy de funciones
supabase functions deploy verify-pin
supabase functions deploy send-push-alert
supabase functions deploy export-payroll
supabase functions deploy schedule-cron-missed
```

## Estructura

```
supabase/
├── config.toml                     # configuración del proyecto
├── migrations/
│   └── 20260507000001_init.sql     # esquema base + RLS + RPCs
├── functions/
│   ├── verify-pin/
│   ├── send-push-alert/
│   ├── export-payroll/
│   ├── schedule-cron-missed/
│   └── _shared/
└── seed/                           # seeds de QA
```

## Cron jobs

Configurar en Supabase Dashboard → Edge Functions → Cron:

| Función | Cron | Descripción |
|---|---|---|
| `schedule-cron-missed` | `0 */1 * * *` | Cada hora, marca turnos perdidos |

## Backups

- PITR habilitado · retención 30 días (Pro)
- Snapshot manual antes de cada migración a prod

## Tests SQL (pgTAP)

```bash
# TODO Sprint 0: instalar pgTAP y suite de tests para RLS y funciones
```
