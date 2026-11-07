import { BadgeCheck, FileWarning, type LucideIcon, Radio, UserRoundCheck } from 'lucide-react';
import { getGuards } from '@/lib/domain/admin-data';
import { AdminShell, SectionHeader } from '../components/admin-shell';

export default async function GuardiasPage() {
  const guards = await getGuards();
  const completeFiles = guards.filter((guard) => /vigente|vence/i.test(guard.fileStatus)).length;
  const equipmentPending = guards.filter((guard) => /incompleto|revisar|pendiente/i.test(guard.equipment)).length;

  return (
    <AdminShell>
      <SectionHeader
        eyebrow="HRMS operativo"
        title="Guardias y expediente"
        description="Vista inicial para administrar personal, estatus operativo, documentos, capacitaciones y equipo asignado."
      />
      <div className="grid gap-4 lg:grid-cols-4">
        <Metric icon={UserRoundCheck} label="Activos" value={String(guards.length)} />
        <Metric icon={BadgeCheck} label="Expedientes con vigencia" value={String(completeFiles)} />
        <Metric icon={FileWarning} label="Docs por revisar" value={String(Math.max(guards.length - completeFiles, 0))} />
        <Metric icon={Radio} label="Equipo pendiente" value={String(equipmentPending)} />
      </div>
      <section className="mt-6 overflow-hidden rounded-lg border border-white/10 bg-segusys-surface">
        <div className="grid grid-cols-[1.2fr_0.7fr_0.7fr_1fr_1fr] gap-4 border-b border-white/10 px-5 py-3 text-xs font-bold uppercase tracking-wide text-segusys-muted">
          <span>Guardia</span>
          <span>Codigo</span>
          <span>Estado</span>
          <span>Expediente</span>
          <span>Equipo</span>
        </div>
        {guards.map((guard) => (
          <div className="grid grid-cols-[1.2fr_0.7fr_0.7fr_1fr_1fr] gap-4 border-b border-white/10 px-5 py-4 text-sm last:border-0" key={guard.code}>
            <span className="font-bold text-segusys-text">{guard.name}</span>
            <span className="text-segusys-muted">{guard.code}</span>
            <span className="text-segusys-muted">{guard.status}</span>
            <span className="text-segusys-muted">{guard.fileStatus}</span>
            <span className="text-segusys-muted">{guard.equipment}</span>
          </div>
        ))}
      </section>
    </AdminShell>
  );
}

function Metric({ icon: Icon, label, value }: { icon: LucideIcon; label: string; value: string }) {
  return (
    <article className="rounded-lg border border-white/10 bg-segusys-surface p-5">
      <Icon className="h-5 w-5 text-segusys-accent" />
      <p className="mt-4 text-sm text-segusys-muted">{label}</p>
      <p className="mt-1 text-3xl font-black">{value}</p>
    </article>
  );
}
