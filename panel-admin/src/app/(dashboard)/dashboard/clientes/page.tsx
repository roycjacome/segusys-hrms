import { Smartphone, UsersRound } from 'lucide-react';
import { getClients } from '@/lib/domain/admin-data';
import { AdminShell, SectionHeader } from '../components/admin-shell';

export default async function ClientesPage() {
  const clients = await getClients();

  return (
    <AdminShell>
      <SectionHeader
        eyebrow="Portal cliente"
        title="Clientes finales"
        description="Administra accesos para que cada cliente vea solo sus ubicaciones, evidencias e indicadores."
      />
      <section className="grid gap-4 md:grid-cols-3">
        {clients.map((client) => (
          <article className="rounded-lg border border-white/10 bg-segusys-surface p-5" key={client.name}>
            <UsersRound className="h-5 w-5 text-segusys-accent" />
            <h3 className="mt-4 font-bold">{client.name}</h3>
            <div className="mt-4 space-y-2 text-sm text-segusys-muted">
              <p>{client.users}</p>
              <p>{client.locations}</p>
              <p>{client.status}</p>
            </div>
          </article>
        ))}
      </section>
      <footer className="mt-6 flex items-center gap-2 text-sm text-segusys-muted">
        <Smartphone className="h-4 w-4 text-segusys-accent2" />
        Estos accesos se consumen desde la app admin/cliente mediante RLS por ubicacion.
      </footer>
    </AdminShell>
  );
}
