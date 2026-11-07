import {
  AlertTriangle,
  BadgeCheck,
  BriefcaseBusiness,
  CalendarClock,
  ClipboardList,
  FileWarning,
  MapPin,
  Radio,
  ShieldCheck,
  Users,
} from 'lucide-react';
import { AdminShell, SectionHeader } from './components/admin-shell';
import { getDashboardData } from '@/lib/domain/admin-data';

const modules = [
  'Asistencia GPS',
  'Expediente digital',
  'Equipo asignado',
  'Capacitaciones',
  'Pre-nomina',
  'Reportes a clientes',
];

const toneClass: Record<string, string> = {
  success: 'border-segusys-success/40 bg-segusys-success/10 text-segusys-success',
  warning: 'border-segusys-accent/50 bg-segusys-accent/10 text-segusys-accent',
  info: 'border-segusys-accent2/50 bg-segusys-accent2/10 text-segusys-accent2',
  danger: 'border-segusys-danger/50 bg-segusys-danger/10 text-segusys-danger',
};

const statIcons = {
  users: Users,
  shield: ShieldCheck,
  clock: CalendarClock,
  file: FileWarning,
};

export default async function DashboardPage() {
  const { stats, liveShifts, hrAlerts, source } = await getDashboardData();

  return (
    <AdminShell>
      <section>
        <div className="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
          <SectionHeader
            eyebrow="Consola de operaciones y RH"
            title="Dashboard ejecutivo"
            description={`Presencia, expedientes, equipo, vencimientos y pre-nomina en una sola vista. Fuente: ${source === 'supabase' ? 'Supabase' : 'demo local'}.`}
          />
          <div className="grid grid-cols-2 gap-2 text-xs text-segusys-muted sm:grid-cols-3">
            {modules.map((module) => (
              <span
                className="rounded-md border border-white/10 bg-white/[0.03] px-3 py-2"
                key={module}
              >
                {module}
              </span>
            ))}
          </div>
        </div>
      </section>

      <section>
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          {stats.map((stat) => {
            const Icon = statIcons[stat.icon];
            return (
              <article
                className="rounded-lg border border-white/10 bg-segusys-surface p-5"
                key={stat.label}
              >
                <div className="flex items-center justify-between">
                  <p className="text-sm text-segusys-muted">{stat.label}</p>
                  <Icon className="h-5 w-5 text-segusys-accent" />
                </div>
                <div className="mt-4 text-3xl font-black">{stat.value}</div>
                <p className="mt-1 text-sm text-segusys-muted">{stat.detail}</p>
              </article>
            );
          })}
        </div>

        <div className="mt-6 grid gap-6 lg:grid-cols-[1.5fr_1fr]">
          <section className="rounded-lg border border-white/10 bg-segusys-surface">
            <header className="flex items-center justify-between border-b border-white/10 px-5 py-4">
              <div>
                <h2 className="text-lg font-bold">Presencia en vivo</h2>
                <p className="text-sm text-segusys-muted">
                  Turnos activos y excepciones del dia
                </p>
              </div>
              <MapPin className="h-5 w-5 text-segusys-accent2" />
            </header>
            <div className="divide-y divide-white/10">
              {liveShifts.map((shift) => (
                <article className="grid gap-4 px-5 py-4 md:grid-cols-[1fr_auto]" key={shift.code}>
                  <div>
                    <div className="flex flex-wrap items-center gap-2">
                      <h3 className="font-bold">{shift.guard}</h3>
                      <span className="rounded border border-white/10 px-2 py-1 font-mono text-xs text-segusys-muted">
                        {shift.code}
                      </span>
                    </div>
                    <p className="mt-2 text-sm text-segusys-muted">
                      {shift.location} · {shift.client}
                    </p>
                  </div>
                  <div className="flex flex-col items-start gap-2 md:items-end">
                    <span className={`rounded-md border px-3 py-1 text-xs font-bold ${toneClass[shift.tone]}`}>
                      {shift.status}
                    </span>
                    <span className="text-sm text-segusys-muted">{shift.time}</span>
                  </div>
                </article>
              ))}
            </div>
          </section>

          <section className="rounded-lg border border-white/10 bg-segusys-surface">
            <header className="flex items-center justify-between border-b border-white/10 px-5 py-4">
              <div>
                <h2 className="text-lg font-bold">Alertas HRMS</h2>
                <p className="text-sm text-segusys-muted">
                  Expediente, equipo y certificaciones
                </p>
              </div>
              <AlertTriangle className="h-5 w-5 text-segusys-accent" />
            </header>
            <div className="space-y-3 p-5">
              {hrAlerts.map((alert) => (
                <article className="rounded-md border border-white/10 bg-white/[0.03] p-4" key={alert.label}>
                  <p className="font-bold">{alert.label}</p>
                  <div className="mt-2 flex items-center justify-between text-sm text-segusys-muted">
                    <span>{alert.owner}</span>
                    <span>{alert.due}</span>
                  </div>
                </article>
              ))}
            </div>
          </section>
        </div>

        <div className="mt-6 grid gap-4 md:grid-cols-3">
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5">
            <ClipboardList className="h-5 w-5 text-segusys-accent" />
            <h2 className="mt-3 font-bold">Pre-nomina lista</h2>
            <p className="mt-2 text-sm leading-6 text-segusys-muted">
              Horas, faltas, retardos y turnos dobles preparados para exportar.
            </p>
          </article>
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5">
            <Radio className="h-5 w-5 text-segusys-accent2" />
            <h2 className="mt-3 font-bold">Equipo trazable</h2>
            <p className="mt-2 text-sm leading-6 text-segusys-muted">
              Uniformes, radios y herramientas ligados al expediente del guardia.
            </p>
          </article>
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5">
            <BriefcaseBusiness className="h-5 w-5 text-segusys-success" />
            <h2 className="mt-3 font-bold">Piloto nacional</h2>
            <p className="mt-2 text-sm leading-6 text-segusys-muted">
              Datos ficticios listos para vender pruebas pagadas sin marca de un cliente.
            </p>
          </article>
        </div>

        <footer className="mt-8 flex items-center gap-2 text-sm text-segusys-muted">
          <BadgeCheck className="h-4 w-4 text-segusys-success" />
          Producto reencauzado: control de guardias como entrada, HRMS vertical como negocio.
        </footer>
      </section>
    </AdminShell>
  );
}
