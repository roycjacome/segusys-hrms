import { AlertTriangle, Camera, Clock } from 'lucide-react';
import { getIncidents } from '@/lib/domain/admin-data';
import { AdminShell, SectionHeader } from '../components/admin-shell';

export default async function IncidenciasPage() {
  const incidents = await getIncidents();

  return (
    <AdminShell>
      <SectionHeader
        eyebrow="Bitacora y evidencia"
        title="Incidencias"
        description="Eventos reportados por guardias, supervisores o reglas automaticas del sistema."
      />
      <section className="grid gap-4">
        {incidents.map((incident) => (
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5" key={`${incident.title}-${incident.time}`}>
            <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
              <div>
                <div className="flex items-center gap-2">
                  <AlertTriangle className="h-4 w-4 text-segusys-accent" />
                  <h3 className="font-bold">{incident.title}</h3>
                </div>
                <p className="mt-2 text-sm text-segusys-muted">{incident.location}</p>
              </div>
              <div className="flex flex-wrap gap-2 text-sm text-segusys-muted">
                <span className="inline-flex items-center gap-2 rounded-md border border-white/10 px-3 py-2">
                  <Camera className="h-4 w-4" /> Evidencia
                </span>
                <span className="inline-flex items-center gap-2 rounded-md border border-white/10 px-3 py-2">
                  <Clock className="h-4 w-4" /> {incident.time}
                </span>
                <span className="rounded-md border border-segusys-accent/40 bg-segusys-accent/10 px-3 py-2 text-segusys-accent">
                  {incident.priority}
                </span>
              </div>
            </div>
          </article>
        ))}
      </section>
    </AdminShell>
  );
}
