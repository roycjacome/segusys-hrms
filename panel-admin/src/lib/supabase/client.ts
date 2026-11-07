import { createBrowserClient } from '@supabase/ssr';

/**
 * Cliente Supabase para componentes client-side ('use client').
 * Usa cookies HTTP-only manejadas por @supabase/ssr.
 */
export function createClient() {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
    return null;
  }

  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
