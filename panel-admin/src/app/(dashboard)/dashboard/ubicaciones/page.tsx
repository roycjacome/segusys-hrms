import { Building2, MapPin } from 'lucide-react';
import { createLocationAction } from '@/lib/domain/admin-actions';
import { getLocations } from '@/lib/domain/admin-data';
import { AdminShell, SectionHeader } from '../components/admin-shell';

export default async function UbicacionesPage() {
  const locations = await getLocations();

  return (
    <AdminShell>
      <SectionHeader
        eyebrow="Operacion de campo"
        title="Ubicaciones y clientes finales"
        description="Controla geocercas, clientes, cobertura y estado operativo por sitio."
      />
      <form action={createLocationAction} className="mb-6 rounded-lg border border-white/10 bg-segusys-surface p-5">
        <div className="mb-4">
          <h3 className="font-bold">Alta rapida de ubicacion</h3>
          <p className="mt-1 text-sm text-segusys-muted">
            Crea un sitio con geocerca para turnos, app guardia y portal cliente.
          </p>
        </div>
        <div className="grid gap-3 md:grid-cols-3">
          <input name="name" required placeholder="Nombre del sitio" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="client_name" placeholder="Cliente final" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="address" placeholder="Direccion" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="city" placeholder="Ciudad" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="state" placeholder="Estado" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="geofence_radius_m" type="number" min="10" defaultValue="50" placeholder="Radio m" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="lat" type="number" step="0.000001" defaultValue="19.4326" placeholder="Latitud" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <input name="lng" type="number" step="0.000001" defaultValue="-99.1332" placeholder="Longitud" className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-sm outline-none focus:border-segusys-accent" />
          <button className="rounded-md bg-segusys-accent px-3 py-2 text-sm font-black text-segusys-bg" type="submit">
            Guardar ubicacion
          </button>
        </div>
      </form>
      <div className="grid gap-4 md:grid-cols-2">
        {locations.map((location) => (
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5" key={location.name}>
            <div className="flex items-start justify-between gap-4">
              <div>
                <h3 className="font-bold">{location.name}</h3>
                <p className="mt-1 text-sm text-segusys-muted">{location.client}</p>
              </div>
              <MapPin className="h-5 w-5 text-segusys-accent2" />
            </div>
            <div className="mt-5 grid grid-cols-2 gap-3 text-sm">
              <span className="rounded-md border border-white/10 bg-white/[0.03] px-3 py-2 text-segusys-muted">{location.guards}</span>
              <span className="rounded-md border border-white/10 bg-white/[0.03] px-3 py-2 text-segusys-muted">{location.status}</span>
            </div>
          </article>
        ))}
      </div>
      <footer className="mt-6 flex items-center gap-2 text-sm text-segusys-muted">
        <Building2 className="h-4 w-4 text-segusys-accent" />
        Estas ubicaciones alimentan el panel web, la app de guardia y la app del cliente final.
      </footer>
    </AdminShell>
  );
}
