import { createClient } from '@/lib/supabase/server';
import * as demo from './demo-data';
import type { GuardRow, IncidentRow, LiveShift, LocationRow } from './types';

function hasSupabaseEnv() {
  return Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
}

function formatTimeRange(start?: string | null, end?: string | null) {
  if (!start || !end) return 'Sin horario';
  const formatter = new Intl.DateTimeFormat('es-MX', { hour: '2-digit', minute: '2-digit' });
  return `${formatter.format(new Date(start))} - ${formatter.format(new Date(end))}`;
}

function mapLiveStatus(status: string): { label: string; tone: LiveShift['tone'] } {
  switch (status) {
    case 'on_duty':
      return { label: 'En turno', tone: 'success' };
    case 'late_arrival_window':
      return { label: 'Check-in pendiente', tone: 'warning' };
    case 'missed':
      return { label: 'Turno perdido', tone: 'danger' };
    case 'upcoming':
      return { label: 'Proximo', tone: 'info' };
    default:
      return { label: status, tone: 'info' };
  }
}

export async function getDashboardData() {
  if (!hasSupabaseEnv()) {
    return {
      stats: demo.dashboardStats,
      liveShifts: demo.liveShifts,
      hrAlerts: demo.hrAlerts,
      source: 'demo' as const,
    };
  }

  try {
    const supabase = createClient();
    const [{ data: presence }, { data: hr }] = await Promise.all([
      supabase.from('v_live_presence').select('*').order('scheduled_start'),
      supabase.from('v_guard_hr_alerts').select('*').limit(5),
    ]);

    const liveShifts: LiveShift[] = (presence ?? []).map((row: any) => {
      const status = mapLiveStatus(row.live_status);
      return {
        guard: row.guard_name ?? 'Guardia sin nombre',
        code: row.employee_code ?? 'SIN-CODIGO',
        location: row.location_name ?? 'Ubicacion sin nombre',
        client: row.client_name ?? 'Cliente final',
        status: status.label,
        time: formatTimeRange(row.scheduled_start, row.scheduled_end),
        tone: status.tone,
      };
    });

    const hrAlerts = (hr ?? [])
      .filter((row: any) => Number(row.documents_expiring_30d ?? 0) > 0 || Number(row.trainings_expiring_30d ?? 0) > 0)
      .map((row: any) => ({
        label: Number(row.documents_expiring_30d ?? 0) > 0 ? 'Documento por vencer' : 'Capacitacion por vencer',
        owner: row.guard_name ?? 'Guardia',
        due: '30 dias',
      }));

    return {
      stats: demo.dashboardStats,
      liveShifts: liveShifts.length > 0 ? liveShifts : demo.liveShifts,
      hrAlerts: hrAlerts.length > 0 ? hrAlerts : demo.hrAlerts,
      source: 'supabase' as const,
    };
  } catch {
    return {
      stats: demo.dashboardStats,
      liveShifts: demo.liveShifts,
      hrAlerts: demo.hrAlerts,
      source: 'demo' as const,
    };
  }
}

export async function getGuards(): Promise<GuardRow[]> {
  if (!hasSupabaseEnv()) return demo.guards;
  try {
    const supabase = createClient();
    const { data } = await supabase
      .from('guards')
      .select('employee_code, certification_expires_at, users(full_name)')
      .order('employee_code')
      .limit(50);

    const rows = (data ?? []).map((row: any) => ({
      name: row.users?.full_name ?? 'Guardia sin nombre',
      code: row.employee_code ?? 'SIN-CODIGO',
      status: 'Activo',
      fileStatus: row.certification_expires_at ? `Cert. vence ${row.certification_expires_at}` : 'Sin certificacion',
      equipment: 'Equipo por revisar',
    }));
    return rows.length > 0 ? rows : demo.guards;
  } catch {
    return demo.guards;
  }
}

export async function getLocations(): Promise<LocationRow[]> {
  if (!hasSupabaseEnv()) return demo.locations;
  try {
    const supabase = createClient();
    const { data } = await supabase
      .from('v_client_location_status')
      .select('*')
      .order('location_name')
      .limit(50);

    const rows = (data ?? []).map((row: any) => ({
      name: row.location_name ?? 'Ubicacion sin nombre',
      client: row.client_name ?? 'Cliente final',
      guards: `${row.active_shifts ?? 0}/${row.shifts_today ?? 0} turnos activos`,
      status: Number(row.open_incidents ?? 0) > 0 ? `${row.open_incidents} incidencias abiertas` : 'Sin novedad',
    }));
    return rows.length > 0 ? rows : demo.locations;
  } catch {
    return demo.locations;
  }
}

export async function getIncidents(): Promise<IncidentRow[]> {
  if (!hasSupabaseEnv()) return demo.incidents;
  try {
    const supabase = createClient();
    const { data } = await supabase
      .from('incidents')
      .select('title, type, severity, created_at, shifts(locations(name))')
      .order('created_at', { ascending: false })
      .limit(50);

    const rows = (data ?? []).map((row: any) => ({
      title: row.title ?? row.type ?? 'Incidencia',
      location: row.shifts?.locations?.name ?? 'Ubicacion',
      priority: Number(row.severity ?? 1) >= 4 ? 'Alta' : Number(row.severity ?? 1) >= 2 ? 'Media' : 'Baja',
      time: row.created_at ? new Intl.DateTimeFormat('es-MX', { hour: '2-digit', minute: '2-digit' }).format(new Date(row.created_at)) : 'Sin hora',
    }));
    return rows.length > 0 ? rows : demo.incidents;
  } catch {
    return demo.incidents;
  }
}

export async function getClients() {
  return demo.clients;
}
