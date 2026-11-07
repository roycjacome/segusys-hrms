import Link from 'next/link';
import { Building2, LayoutDashboard, ShieldAlert, UserRoundCheck, UsersRound } from 'lucide-react';

const navItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/dashboard/guardias', label: 'Guardias', icon: UserRoundCheck },
  { href: '/dashboard/ubicaciones', label: 'Ubicaciones', icon: Building2 },
  { href: '/dashboard/incidencias', label: 'Incidencias', icon: ShieldAlert },
  { href: '/dashboard/clientes', label: 'Clientes', icon: UsersRound },
];

export function AdminShell({ children }: { children: React.ReactNode }) {
  return (
    <main className="min-h-screen bg-segusys-bg">
      <aside className="border-b border-white/10 bg-[#07111f]">
        <div className="mx-auto flex max-w-7xl flex-col gap-4 px-5 py-5 lg:flex-row lg:items-center lg:justify-between">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.22em] text-segusys-accent">
              Segusys HRMS Mexico
            </p>
            <h1 className="mt-1 text-2xl font-black text-segusys-text">
              Panel administrativo
            </h1>
          </div>
          <nav className="flex gap-2 overflow-x-auto pb-1">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <Link
                  className="inline-flex items-center gap-2 rounded-md border border-white/10 bg-white/[0.03] px-3 py-2 text-sm text-segusys-muted transition hover:border-segusys-accent/60 hover:text-segusys-text"
                  href={item.href}
                  key={item.href}
                >
                  <Icon className="h-4 w-4" />
                  {item.label}
                </Link>
              );
            })}
          </nav>
        </div>
      </aside>
      <section className="mx-auto max-w-7xl px-5 py-6">{children}</section>
    </main>
  );
}

export function SectionHeader({
  eyebrow,
  title,
  description,
}: {
  eyebrow: string;
  title: string;
  description: string;
}) {
  return (
    <header className="mb-6">
      <p className="text-xs font-bold uppercase tracking-[0.2em] text-segusys-accent">{eyebrow}</p>
      <h2 className="mt-2 text-3xl font-black text-segusys-text">{title}</h2>
      <p className="mt-2 max-w-2xl text-sm leading-6 text-segusys-muted">{description}</p>
    </header>
  );
}
