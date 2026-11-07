'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';

/**
 * Login del panel admin (admin/supervisor) con email + password.
 * Los guardias usan código + PIN en la app móvil, no aquí.
 */
export default function LoginPage() {
  const router = useRouter();
  const supabase = createClient();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!supabase) {
      router.replace('/dashboard');
      return;
    }
    setLoading(true); setError(null);
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);
    if (error) {
      setError('Credenciales inválidas');
      return;
    }
    router.replace('/dashboard');
  }

  return (
    <main className="min-h-screen flex items-center justify-center px-4">
      <form onSubmit={onSubmit} className="w-full max-w-sm bg-segusys-surface rounded-2xl p-8 space-y-4">
        <header className="text-center mb-2">
          <div className="inline-flex h-12 w-12 rounded-xl bg-segusys-accent items-center justify-center font-extrabold text-segusys-bg text-xl">S</div>
          <h1 className="text-2xl font-bold mt-4">Segusys · Admin</h1>
          <p className="text-sm text-segusys-muted">Acceso para operaciones, RH y supervisores</p>
        </header>
        <input
          type="email" required value={email} onChange={(e) => setEmail(e.target.value)}
          placeholder="correo@segusys.mx"
          className="w-full px-4 py-3 rounded-xl bg-segusys-surface2 text-segusys-text outline-none focus:ring-2 focus:ring-segusys-accent"
        />
        <input
          type="password" required value={password} onChange={(e) => setPassword(e.target.value)}
          placeholder="Contraseña"
          className="w-full px-4 py-3 rounded-xl bg-segusys-surface2 text-segusys-text outline-none focus:ring-2 focus:ring-segusys-accent"
        />
        {error && <p className="text-sm text-segusys-danger">{error}</p>}
        <button
          type="submit" disabled={loading}
          className="w-full py-3 rounded-xl bg-segusys-accent text-segusys-bg font-extrabold tracking-wider uppercase disabled:opacity-50"
        >
          {loading ? 'Entrando...' : 'Ingresar'}
        </button>
      </form>
    </main>
  );
}
