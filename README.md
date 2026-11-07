# Segusys: operations HRMS for private security companies

A vertical HRMS for Mexican private-security firms: guards, sites, shifts, GPS check-in, incident logs, client reporting and pre-payroll.

## Apps (monorepo)

| Workspace | Stack | For |
|---|---|---|
| `app-guardia/` | Flutter (iOS + Android) | Guards: GPS check-in, shift log, incidents, **offline queue with background sync** |
| `panel-admin/` | Next.js 14 | Operations staff: guards, clients, sites, incidents dashboard |
| `app-admin-cliente/` | Flutter | Supervisors and client companies: sites and reports |
| `supabase/` | Postgres + RLS + Edge Functions | Multi-tenant schema |

## Status

This is an MVP. The schema, guard app and admin panel are scaffolded and functional with demo data. It was originally scoped for a single client and then repositioned as a product for the whole market.

Setup and conventions (Spanish): [README.es.md](README.es.md). Copy `.env.example` into each workspace.

## License

AGPL-3.0 © 2026 Roy Camacho Jácome. You can use, modify and self-host it; if you offer it to others as a service, you must publish your source code under the same license. For a commercial license, contact the author. See [LICENSE](LICENSE).
