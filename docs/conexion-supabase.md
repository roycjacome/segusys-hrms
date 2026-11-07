# Conexion real a Supabase

Este proyecto mantiene fallback demo para vender y desarrollar sin backend, pero las superficies ya estan preparadas para conectarse a Supabase.

## Superficies

- `panel-admin`: usa `src/lib/domain/admin-data.ts`. Si existen `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY`, consulta Supabase; si no, usa `demo-data.ts`.
- `app-admin-cliente`: usa `AppRepository`. Por defecto intenta `SupabaseAppRepository` si Supabase fue inicializado; si no, usa `DemoAppRepository`.
- `app-guardia`: ya tiene `SupabaseService` para RPCs criticas de PIN, check-in y check-out.

## Variables necesarias

Copiar `04-desarrollo/.env.example` a cada workspace:

- `panel-admin/.env.local`
- `app-guardia/.env`
- `app-admin-cliente/.env`

Minimo para panel:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://<project>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
DEFAULT_TENANT_ID=<tenant-id-demo>
```

Minimo para app admin/cliente:

```bash
SUPABASE_URL_ADMIN_CLIENTE=https://<project>.supabase.co
SUPABASE_ANON_KEY_ADMIN_CLIENTE=<anon-key>
```

## Flujo recomendado para piloto

1. Crear tenant.
2. Crear usuarios admin/supervisor/cliente en Supabase Auth.
3. Crear registros en `users` con `role`.
4. Crear ubicaciones desde `/dashboard/ubicaciones`.
5. Crear `client_location_access` para usuarios cliente.
6. Crear guardias, turnos e incidencias.
7. Validar:
   - Panel admin ve todo el tenant.
   - App guardia solo ve sus turnos.
   - App cliente solo ve ubicaciones autorizadas.

## Pendientes tecnicos

- Reemplazar login demo de app admin/cliente por `signInWithPassword`.
- Agregar formulario web de guardias con creacion coordinada en Supabase Auth.
- Agregar formulario web de turnos.
- Agregar pruebas de RLS para `client_location_access`.

