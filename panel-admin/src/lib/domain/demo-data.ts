import type {
  ClientRow,
  DashboardStat,
  GuardRow,
  HrAlert,
  IncidentRow,
  LiveShift,
  LocationRow,
} from './types';

export const dashboardStats: DashboardStat[] = [
  { label: 'Guardias activos', value: '184', detail: '12 altas este mes', icon: 'users' },
  { label: 'Cobertura hoy', value: '96%', detail: '74 de 77 turnos cubiertos', icon: 'shield' },
  { label: 'Retardos', value: '5', detail: '2 fuera de tolerancia', icon: 'clock' },
  { label: 'Docs por vencer', value: '18', detail: 'Proximos 30 dias', icon: 'file' },
];

export const liveShifts: LiveShift[] = [
  {
    guard: 'Marisol Vega Torres',
    code: 'SEG-1042',
    location: 'Planta Industrial Apodaca',
    client: 'Grupo Aceros del Norte',
    status: 'En turno',
    time: '07:02 - 19:00',
    tone: 'success',
  },
  {
    guard: 'Hector Salgado Ruiz',
    code: 'SEG-1180',
    location: 'Centro Logistico Tlalnepantla',
    client: 'Logistica Metropolitana',
    status: 'Check-in pendiente',
    time: '08:00 - 20:00',
    tone: 'warning',
  },
  {
    guard: 'Daniela Cruz Perez',
    code: 'SEG-0917',
    location: 'Torre Corporativa Reforma',
    client: 'Inmobiliaria Reforma',
    status: 'Offline sincronizando',
    time: '06:45 - 18:45',
    tone: 'info',
  },
];

export const hrAlerts: HrAlert[] = [
  { label: 'Certificacion SSPC por vencer', owner: 'Luis Moreno', due: '12 dias' },
  { label: 'Contrato sin firma digital', owner: 'Paola Rivas', due: 'Hoy' },
  { label: 'Uniforme pendiente de retorno', owner: 'Jorge Luna', due: '3 dias' },
];

export const guards: GuardRow[] = [
  { name: 'Marisol Vega Torres', code: 'SEG-1042', status: 'Activo', fileStatus: 'Certificacion vigente', equipment: 'Radio + uniforme' },
  { name: 'Hector Salgado Ruiz', code: 'SEG-1180', status: 'Retardo', fileStatus: 'INE por vencer', equipment: 'Uniforme completo' },
  { name: 'Daniela Cruz Perez', code: 'SEG-0917', status: 'Offline', fileStatus: 'Curso pendiente', equipment: 'Radio asignado' },
  { name: 'Luis Moreno Alba', code: 'SEG-1204', status: 'Disponible', fileStatus: 'SSPC vence pronto', equipment: 'Equipo incompleto' },
];

export const locations: LocationRow[] = [
  { name: 'Planta Industrial Apodaca', client: 'Grupo Aceros del Norte', guards: '12 guardias', status: 'Cobertura completa' },
  { name: 'Centro Logistico Tlalnepantla', client: 'Logistica Metropolitana', guards: '8 guardias', status: '1 check-in pendiente' },
  { name: 'Torre Corporativa Reforma', client: 'Inmobiliaria Reforma', guards: '6 guardias', status: 'Offline sincronizando' },
  { name: 'Parque Industrial Queretaro', client: 'Manufactura Bajio', guards: '10 guardias', status: 'Sin novedad' },
];

export const incidents: IncidentRow[] = [
  { title: 'Check-in omitido', location: 'Centro Logistico Tlalnepantla', priority: 'Alta', time: '08:32' },
  { title: 'Acceso de proveedor', location: 'Planta Industrial Apodaca', priority: 'Media', time: '09:14' },
  { title: 'Equipo pendiente retorno', location: 'Torre Corporativa Reforma', priority: 'Media', time: 'Ayer' },
  { title: 'Ronda offline', location: 'Parque Industrial Queretaro', priority: 'Baja', time: '11:30' },
];

export const clients: ClientRow[] = [
  { name: 'Grupo Aceros del Norte', users: '3 usuarios cliente', locations: '2 ubicaciones', status: 'Reportes activos' },
  { name: 'Logistica Metropolitana', users: '2 usuarios cliente', locations: '1 ubicacion', status: 'Incidencias visibles' },
  { name: 'Inmobiliaria Reforma', users: '4 usuarios cliente', locations: '1 ubicacion', status: 'Portal movil activo' },
];
