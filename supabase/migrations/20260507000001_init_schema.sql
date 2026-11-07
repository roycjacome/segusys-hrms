-- ============================================================================
-- Segusys · HRMS operativo para seguridad privada · Esquema MVP
-- ----------------------------------------------------------------------------
-- Stack: PostgreSQL 15 (Supabase Cloud)
-- Producto: plataforma multiempresa para mercado mexicano
-- Versión: 0.2.0
-- Ejecutar en orden: este archivo → rls-policies.sql → functions.sql → seeds.sql
-- ============================================================================

-- =====================================================================
-- 0. EXTENSIONES Y CONFIGURACIÓN BASE
-- =====================================================================
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";       -- bcrypt para PIN hashing
create extension if not exists "postgis";        -- consultas geoespaciales
create extension if not exists "pg_trgm";        -- búsquedas por nombre

-- =====================================================================
-- 1. TIPOS ENUM
-- =====================================================================
create type user_role as enum ('admin', 'supervisor', 'guard', 'client');
create type shift_status as enum ('scheduled', 'in_progress', 'completed', 'missed', 'cancelled');
create type event_type as enum ('check_in', 'check_out');
create type incident_type as enum ('anomaly', 'access', 'round', 'damage', 'other');
create type queue_status as enum ('pending', 'syncing', 'synced', 'failed');
create type document_status as enum ('pending', 'valid', 'expired', 'rejected');
create type equipment_status as enum ('assigned', 'returned', 'lost', 'damaged');
create type training_status as enum ('scheduled', 'completed', 'expired', 'cancelled');
create type leave_status as enum ('requested', 'approved', 'rejected', 'cancelled');

-- =====================================================================
-- 2. TABLA tenants  (preparado multi-tenant; MVP single-tenant)
-- =====================================================================
create table tenants (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null,
  rfc           text,
  billing_tier  text not null default 'mvp',          -- mvp | professional | premium
  active        boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

comment on table tenants is 'Empresas cliente que usan Segusys. Cada tenant aísla operación, RH y reportes.';

-- =====================================================================
-- 3. TABLA users  (extiende auth.users de Supabase)
-- =====================================================================
create table users (
  id            uuid primary key references auth.users(id) on delete cascade,
  tenant_id     uuid not null references tenants(id),
  email         text unique,
  full_name     text not null,
  role          user_role not null default 'guard',
  active        boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index idx_users_tenant on users(tenant_id);
create index idx_users_role on users(role) where active = true;

-- =====================================================================
-- 4. TABLA guards  (perfil del guardia · 1:1 con users.role='guard')
-- =====================================================================
create table guards (
  id                          uuid primary key default uuid_generate_v4(),
  user_id                     uuid not null unique references users(id) on delete cascade,
  tenant_id                   uuid not null references tenants(id),
  employee_code               text not null,
  pin_hash                    text not null,                 -- bcrypt hash del PIN
  pin_failed_attempts         int not null default 0,
  pin_locked_until            timestamptz,
  hire_date                   date,
  certification_expires_at    date,
  photo_url                   text,
  phone                       text,
  emergency_contact_name      text,
  emergency_contact_phone     text,
  fcm_token                   text,                          -- token push notif
  device_id                   text,                          -- último device usado
  created_at                  timestamptz not null default now(),
  updated_at                  timestamptz not null default now(),
  unique(tenant_id, employee_code)
);

create index idx_guards_tenant on guards(tenant_id);
create index idx_guards_employee_code on guards(tenant_id, employee_code);
create index idx_guards_cert_expiry on guards(certification_expires_at)
  where certification_expires_at is not null;

comment on column guards.pin_hash is 'Bcrypt hash del PIN. Nunca almacenar en claro.';
comment on column guards.pin_locked_until is 'Si NOT NULL y > now(), el guardia está bloqueado.';

-- =====================================================================
-- 5. TABLA locations  (sitios donde se asignan guardias)
-- =====================================================================
create table locations (
  id                  uuid primary key default uuid_generate_v4(),
  tenant_id           uuid not null references tenants(id),
  name                text not null,
  client_name         text,                              -- empresa cliente final
  address             text,
  city                text,
  state               text,
  geo                 geography(point, 4326) not null,   -- lat/lng
  geofence_radius_m   int not null default 50,           -- radio geocerca metros
  notes               text,
  active              boolean not null default true,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

create index idx_locations_tenant on locations(tenant_id);
create index idx_locations_active on locations(tenant_id) where active = true;
create index idx_locations_geo on locations using gist(geo);

comment on column locations.geofence_radius_m is 'Radio en metros para validar check-in. Default 50m.';
comment on column locations.geo is 'Punto geográfico SRID 4326 (WGS84 GPS estándar).';

-- =====================================================================
-- 6. TABLA client_location_access  (portal/app cliente final)
-- =====================================================================
create table client_location_access (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  user_id         uuid not null references users(id) on delete cascade,
  location_id     uuid not null references locations(id) on delete cascade,
  client_name     text,
  can_view_reports boolean not null default true,
  can_view_incidents boolean not null default true,
  active          boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique(user_id, location_id)
);

create index idx_client_location_access_user on client_location_access(user_id, active);
create index idx_client_location_access_location on client_location_access(location_id, active);

-- =====================================================================
-- 7. TABLAS HRMS  (expediente, equipo, capacitacion, ausencias)
-- =====================================================================
create table guard_documents (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  guard_id        uuid not null references guards(id) on delete cascade,
  document_type   text not null,                  -- INE, contrato, comprobante, permiso, etc.
  document_name   text not null,
  file_url        text,
  status          document_status not null default 'pending',
  issued_at       date,
  expires_at      date,
  verified_by     uuid references users(id),
  verified_at     timestamptz,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_guard_documents_tenant on guard_documents(tenant_id);
create index idx_guard_documents_guard on guard_documents(guard_id);
create index idx_guard_documents_expiry on guard_documents(tenant_id, expires_at)
  where expires_at is not null and status in ('valid', 'expired');

create table guard_equipment (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  guard_id        uuid not null references guards(id) on delete cascade,
  item_type       text not null,                  -- uniforme, radio, lampara, fornitura, arma, otro
  item_name       text not null,
  serial_number   text,
  assigned_at     date not null default current_date,
  expected_return_at date,
  returned_at     date,
  status          equipment_status not null default 'assigned',
  condition_notes text,
  created_by      uuid references users(id),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_guard_equipment_tenant on guard_equipment(tenant_id);
create index idx_guard_equipment_guard on guard_equipment(guard_id);
create index idx_guard_equipment_status on guard_equipment(tenant_id, status);

create table guard_training (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  guard_id        uuid not null references guards(id) on delete cascade,
  training_name   text not null,
  provider        text,
  status          training_status not null default 'scheduled',
  completed_at    date,
  expires_at      date,
  certificate_url text,
  score           numeric(5,2),
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_guard_training_tenant on guard_training(tenant_id);
create index idx_guard_training_guard on guard_training(guard_id);
create index idx_guard_training_expiry on guard_training(tenant_id, expires_at)
  where expires_at is not null;

create table guard_leave_requests (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  guard_id        uuid not null references guards(id) on delete cascade,
  leave_type      text not null,                  -- vacaciones, permiso, incapacidad, falta justificada
  starts_on       date not null,
  ends_on         date not null,
  status          leave_status not null default 'requested',
  reason          text,
  evidence_url    text,
  reviewed_by     uuid references users(id),
  reviewed_at     timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint guard_leave_dates_check check (ends_on >= starts_on)
);

create index idx_guard_leave_tenant on guard_leave_requests(tenant_id);
create index idx_guard_leave_guard on guard_leave_requests(guard_id);
create index idx_guard_leave_dates on guard_leave_requests(starts_on, ends_on);

-- =====================================================================
-- 8. TABLA shifts  (turnos programados)
-- =====================================================================
create table shifts (
  id                uuid primary key default uuid_generate_v4(),
  tenant_id         uuid not null references tenants(id),
  guard_id          uuid not null references guards(id),
  location_id       uuid not null references locations(id),
  scheduled_start   timestamptz not null,
  scheduled_end     timestamptz not null,
  actual_start      timestamptz,                          -- de check_in event
  actual_end        timestamptz,                          -- de check_out event
  status            shift_status not null default 'scheduled',
  created_by        uuid references users(id),
  notes             text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint shifts_time_check check (scheduled_end > scheduled_start)
);

create index idx_shifts_tenant on shifts(tenant_id);
create index idx_shifts_guard on shifts(guard_id);
create index idx_shifts_location on shifts(location_id);
create index idx_shifts_scheduled on shifts(scheduled_start, scheduled_end);
create index idx_shifts_status on shifts(status) where status in ('scheduled','in_progress');
create index idx_shifts_guard_active on shifts(guard_id, status)
  where status in ('scheduled','in_progress');

-- Regla de negocio: un guardia solo puede tener 1 turno in_progress
create unique index unique_guard_active_shift on shifts(guard_id)
  where status = 'in_progress';

-- =====================================================================
-- 9. TABLA shift_events  (check-in / check-out · auditable)
-- =====================================================================
create table shift_events (
  id                      uuid primary key default uuid_generate_v4(),
  tenant_id               uuid not null references tenants(id),
  shift_id                uuid not null references shifts(id),
  guard_id                uuid not null references guards(id),
  event_type              event_type not null,
  ts_device               timestamptz not null,           -- reloj del dispositivo
  ts_server               timestamptz not null default now(),  -- reloj del servidor (autoritativo)
  geo                     geography(point, 4326) not null,
  accuracy_m              numeric(8,2),
  distance_to_point_m     numeric(8,2),
  tamper_flags            jsonb not null default '{}'::jsonb, -- {mock_location, rooted, mock_app, ...}
  is_valid                boolean not null default true,      -- false si tamper detectado
  folio                   text not null unique,           -- CK-AAAAMMDD-####
  device_info             jsonb,                          -- {os, version, model}
  notes                   text,                           -- observaciones del guardia
  created_at              timestamptz not null default now()
);

create index idx_events_tenant on shift_events(tenant_id);
create index idx_events_shift on shift_events(shift_id);
create index idx_events_guard on shift_events(guard_id);
create index idx_events_ts_server on shift_events(ts_server desc);
create index idx_events_invalid on shift_events(tenant_id, is_valid) where is_valid = false;

comment on column shift_events.ts_server is 'Hora del servidor; AUTORITATIVA para auditoría. ts_device puede ser manipulada.';
comment on column shift_events.folio is 'Identificador legible único: CK-20260507-1042.';
comment on column shift_events.tamper_flags is 'JSONB con flags: mock_location, rooted, mock_app_installed, gps_off, ...';

-- =====================================================================
-- 10. TABLA incidents  (bitácora de novedades)
-- =====================================================================
create table incidents (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  shift_id        uuid not null references shifts(id),
  guard_id        uuid not null references guards(id),
  type            incident_type not null,
  title           text,
  description     text not null,
  photo_url       text,
  geo             geography(point, 4326),
  severity        int default 1 check (severity between 1 and 5),
  resolved        boolean not null default false,
  resolved_by     uuid references users(id),
  resolved_at     timestamptz,
  created_at      timestamptz not null default now()
);

create index idx_incidents_tenant on incidents(tenant_id);
create index idx_incidents_shift on incidents(shift_id);
create index idx_incidents_guard on incidents(guard_id);
create index idx_incidents_unresolved on incidents(tenant_id, resolved) where resolved = false;
create index idx_incidents_created on incidents(created_at desc);

-- =====================================================================
-- 11. TABLA offline_queue  (cola de eventos pendientes de sincronizar)
-- =====================================================================
create table offline_queue (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  guard_id        uuid not null references guards(id),
  device_id       text,
  payload_type    text not null,                  -- 'shift_event' | 'incident' | 'photo'
  payload         jsonb not null,                 -- payload completo del evento
  ts_device       timestamptz not null,           -- cuándo lo registró el guardia
  created_at      timestamptz not null default now(),
  synced_at       timestamptz,
  status          queue_status not null default 'pending',
  attempts        int not null default 0,
  error_message   text
);

create index idx_queue_guard_pending on offline_queue(guard_id, status)
  where status in ('pending','failed');
create index idx_queue_status on offline_queue(status);

-- =====================================================================
-- 12. TABLA notifications  (registro de pushes enviadas)
-- =====================================================================
create table notifications (
  id              uuid primary key default uuid_generate_v4(),
  tenant_id       uuid not null references tenants(id),
  user_id         uuid not null references users(id),
  type            text not null,                  -- 'shift_reminder' | 'tamper_alert' | ...
  title           text not null,
  body            text not null,
  data            jsonb,
  fcm_message_id  text,
  sent_at         timestamptz default now(),
  read_at         timestamptz,
  delivered       boolean not null default false
);

create index idx_notifications_user on notifications(user_id, sent_at desc);

-- =====================================================================
-- 13. TABLA audit_log  (auditoría inmutable de acciones críticas)
-- =====================================================================
create table audit_log (
  id              bigserial primary key,
  tenant_id       uuid references tenants(id),
  actor_id        uuid references users(id),
  action          text not null,                  -- 'shift.created', 'guard.deactivated', ...
  entity_type     text not null,
  entity_id       uuid,
  metadata        jsonb,
  ip_address      inet,
  user_agent      text,
  created_at      timestamptz not null default now()
);

create index idx_audit_tenant_ts on audit_log(tenant_id, created_at desc);
create index idx_audit_entity on audit_log(entity_type, entity_id);

-- =====================================================================
-- 14. TRIGGERS · updated_at automático
-- =====================================================================
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger trg_tenants_updated_at before update on tenants
  for each row execute function set_updated_at();
create trigger trg_users_updated_at before update on users
  for each row execute function set_updated_at();
create trigger trg_guards_updated_at before update on guards
  for each row execute function set_updated_at();
create trigger trg_locations_updated_at before update on locations
  for each row execute function set_updated_at();
create trigger trg_client_location_access_updated_at before update on client_location_access
  for each row execute function set_updated_at();
create trigger trg_guard_documents_updated_at before update on guard_documents
  for each row execute function set_updated_at();
create trigger trg_guard_equipment_updated_at before update on guard_equipment
  for each row execute function set_updated_at();
create trigger trg_guard_training_updated_at before update on guard_training
  for each row execute function set_updated_at();
create trigger trg_guard_leave_requests_updated_at before update on guard_leave_requests
  for each row execute function set_updated_at();
create trigger trg_shifts_updated_at before update on shifts
  for each row execute function set_updated_at();

-- =====================================================================
-- 15. TRIGGER · Sincroniza shift.status con shift_events
-- =====================================================================
create or replace function sync_shift_status()
returns trigger language plpgsql as $$
begin
  if new.event_type = 'check_in' and new.is_valid = true then
    update shifts set
      status = 'in_progress',
      actual_start = new.ts_server
    where id = new.shift_id and status = 'scheduled';
  elsif new.event_type = 'check_out' and new.is_valid = true then
    update shifts set
      status = 'completed',
      actual_end = new.ts_server
    where id = new.shift_id and status = 'in_progress';
  end if;
  return new;
end;
$$;

create trigger trg_sync_shift_status after insert on shift_events
  for each row execute function sync_shift_status();

-- =====================================================================
-- 16. FUNCIÓN · Generador de folio único
-- =====================================================================
create or replace function generate_event_folio(p_event_type event_type)
returns text language plpgsql as $$
declare
  prefix text;
  date_part text;
  seq_part text;
  candidate text;
begin
  prefix := case p_event_type when 'check_in' then 'CK' else 'CO' end;
  date_part := to_char(now(), 'YYYYMMDD');
  -- Cuenta eventos del día + 1, con padding 4 dígitos
  select lpad((count(*) + 1)::text, 4, '0')
    into seq_part
    from shift_events
   where event_type = p_event_type
     and ts_server::date = current_date;
  candidate := prefix || '-' || date_part || '-' || seq_part;
  return candidate;
end;
$$;

-- =====================================================================
-- 17. FUNCIÓN · Validación de geocerca (usada por Edge Function)
-- =====================================================================
create or replace function check_within_geofence(
  p_location_id uuid,
  p_lat numeric,
  p_lng numeric
)
returns table(within_zone boolean, distance_m numeric, radius_m int)
language plpgsql stable as $$
begin
  return query
  select
    st_distance(l.geo, st_makepoint(p_lng, p_lat)::geography) <= l.geofence_radius_m as within_zone,
    st_distance(l.geo, st_makepoint(p_lng, p_lat)::geography)::numeric(8,2) as distance_m,
    l.geofence_radius_m as radius_m
  from locations l
  where l.id = p_location_id and l.active = true;
end;
$$;

-- =====================================================================
-- 18. VISTA · Tablero de presencia en vivo (panel admin)
-- =====================================================================
create or replace view v_live_presence as
select
  s.id as shift_id,
  s.tenant_id,
  s.guard_id,
  g.employee_code,
  u.full_name as guard_name,
  s.location_id,
  l.name as location_name,
  s.scheduled_start,
  s.scheduled_end,
  s.actual_start,
  s.status,
  case
    when s.status = 'scheduled' and s.scheduled_start > now() then 'upcoming'
    when s.status = 'scheduled' and s.scheduled_start <= now() and now() < s.scheduled_start + interval '30 min' then 'late_arrival_window'
    when s.status = 'scheduled' and now() >= s.scheduled_start + interval '30 min' then 'missed'
    when s.status = 'in_progress' then 'on_duty'
    else s.status::text
  end as live_status,
  extract(epoch from (now() - s.actual_start))::int as seconds_on_duty
from shifts s
join guards g on g.id = s.guard_id
join users u on u.id = g.user_id
join locations l on l.id = s.location_id
where s.scheduled_start::date = current_date
   or s.status = 'in_progress';

comment on view v_live_presence is 'Vista en tiempo real del estado de turnos del día. Usada por el dashboard admin.';

-- =====================================================================
-- 19. VISTA · Reporte de horas por guardia (export a Excel)
-- =====================================================================
create or replace view v_payroll_summary as
select
  s.tenant_id,
  s.guard_id,
  g.employee_code,
  u.full_name as guard_name,
  date_trunc('week', s.scheduled_start) as week_start,
  count(*) filter (where s.status = 'completed') as completed_shifts,
  count(*) filter (where s.status = 'missed') as missed_shifts,
  coalesce(
    sum(extract(epoch from (s.actual_end - s.actual_start)) / 3600.0)
      filter (where s.status = 'completed'),
    0
  )::numeric(8,2) as hours_worked,
  count(distinct s.location_id) as locations_covered
from shifts s
join guards g on g.id = s.guard_id
join users u on u.id = g.user_id
group by s.tenant_id, s.guard_id, g.employee_code, u.full_name, date_trunc('week', s.scheduled_start);

-- =====================================================================
-- 20. VISTA · Alertas HRMS del expediente operativo
-- =====================================================================
create or replace view v_guard_hr_alerts as
select
  g.tenant_id,
  g.id as guard_id,
  u.full_name as guard_name,
  g.employee_code,
  count(distinct d.id) filter (
    where d.expires_at is not null
      and d.expires_at <= current_date + interval '30 days'
      and d.status in ('valid', 'expired')
  ) as documents_expiring_30d,
  count(distinct t.id) filter (
    where t.expires_at is not null
      and t.expires_at <= current_date + interval '30 days'
      and t.status in ('completed', 'expired')
  ) as trainings_expiring_30d,
  count(distinct e.id) filter (where e.status = 'assigned') as assigned_equipment
from guards g
join users u on u.id = g.user_id
left join guard_documents d on d.guard_id = g.id
left join guard_training t on t.guard_id = g.id
left join guard_equipment e on e.guard_id = g.id
group by g.tenant_id, g.id, u.full_name, g.employee_code;

-- =====================================================================
-- 21. VISTA · Portal cliente por ubicacion
-- =====================================================================
create or replace view v_client_location_status as
select
  l.tenant_id,
  l.id as location_id,
  l.name as location_name,
  l.client_name,
  count(distinct s.id) filter (where s.scheduled_start::date = current_date) as shifts_today,
  count(distinct s.id) filter (where s.status = 'in_progress') as active_shifts,
  count(distinct s.id) filter (
    where s.status = 'scheduled'
      and s.scheduled_start <= now()
      and now() >= s.scheduled_start + interval '30 min'
  ) as missed_or_late_shifts,
  count(distinct i.id) filter (where i.resolved = false) as open_incidents
from locations l
left join shifts s on s.location_id = l.id
left join incidents i on i.shift_id = s.id
where l.active = true
group by l.tenant_id, l.id, l.name, l.client_name;

-- =====================================================================
-- 22. ÍNDICES ADICIONALES DE RENDIMIENTO
-- =====================================================================
create index idx_shifts_tenant_schedule_status on shifts(tenant_id, scheduled_start, status);

-- ============================================================================
-- FIN del esquema base. Ejecutar a continuación: rls-policies.sql
-- ============================================================================
